//
//  AccountsView.swift
//  FourLakes
//
//  Created by Michael Hollis on 2023-03-14.
//

import SwiftUI

struct AccountsView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    
    init() {
            //Use this if NavigationBarTitle is with Large Font
            UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.red]

            //Use this if NavigationBarTitle is with displayMode = .inline
            UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.red]
        }

    @State private var cEvent: URL?
    @State private var menuEvent: URL?
    @State private var selection: String? = nil
    @State private var displayNotifications: Bool = false
    @State private var displayLanderPage: String? = nil

    var body: some View {
        NavigationView(content: {
            ScrollView(content: {
                let _ = Self._printChanges()
                Button("Disconnect", action: {
                    FourLakesConcierge.disconnect()
                    self.coordinator.screen = .authentication
                })
                ZStack {
                   HStack {
                       ForEach(["Accounts","Transfers","Deposits", "Send Money", "Pay A Bill"], id:\.self, content: { name in
                           VStack {
                               Image(name.lowercased()).resizable().frame(width: 44, height: 44)
                               Text(name).dynamicTypeSize(.xSmall).foregroundColor(Color.white)
                           }
                           Spacer()
                       })
                   }
                }.background(Color(red:5.0/255.0,green: 84.0/255.0,blue:52.0/255.0)).padding()
                Image("ad").resizable().aspectRatio(contentMode: .fit)
                FourLakesConciergeView(["homepage"], events: { conciergeEvent in
                    if FourLakesConcierge.willNavigate(conciergeEvent) {
                        cEvent = conciergeEvent
                        selection = "4"
                    }
                }).applyHeight()

                ForEach(["Accounts","Transfers","Deposits", "Send Money", "Pay A Bill"], id: \.self) { name in
                    HStack {
                        Text(name)
                    }.frame(maxWidth: .infinity, minHeight: 60).background(content: {
                        RoundedRectangle(cornerRadius: 10).fill(.white).shadow(radius: 1)
                    })
                }
                .padding([.leading, .trailing], 5).padding([.bottom], 5)
                .background(Color(red:5.0/255.0,green: 84.0/255.0,blue:52.0/255.0))
                NavigationLink(destination:FourLakesConciergeView(cEvent, events: { conciergeEvent in
                    print(conciergeEvent)
                }).background(Color(red:5.0/255.0,green: 84.0/255.0,blue:52.0/255.0)), tag: "4", selection: $selection) {
                    EmptyView()
                }
                NavigationLink(destination:FourLakesConciergeView(["landerpage"], events: { conciergeEvent in
                    if FourLakesConcierge.willNavigate(conciergeEvent) {
                        cEvent = conciergeEvent
                        selection = "4"
                    }
                }).background(Color(red:5.0/255.0,green: 84.0/255.0,blue:52.0/255.0)), tag: "5", selection: $selection) {
                    EmptyView()
                }
            })
            .background(Color(red:5.0/255.0,green: 84.0/255.0,blue:52.0/255.0))
            .navigationBarTitleDisplayMode(.inline)
            .onReceive(coordinator.$notifications) { output in
                guard let output = output else {return}
                self.cEvent = output
                self.displayNotifications = true
            }
            .sheet(isPresented: self.$displayNotifications, content: {
                FourLakesConciergeView(self.cEvent, events: { conciergeEvent in
                    if FourLakesConcierge.willNavigate(conciergeEvent) {
                        cEvent = conciergeEvent
                    }
                })
            })
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading, content: {
                    Button(action: {
                        selection = "5"
                    }) {
                        Image(systemName: "menubar.rectangle")
                        .renderingMode(Image.TemplateRenderingMode?.init(Image.TemplateRenderingMode.original))
                    }
                })
            })
        })
    }
}



struct AccountsView_Previews: PreviewProvider {
    static var previews: some View {
        AccountsView()
    }
}
