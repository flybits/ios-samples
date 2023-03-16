//
//  AccountsView.swift
//  FourLakes
//
//  Created by Michael Hollis on 2023-03-14.
//

import SwiftUI

struct AccountsView: View {

    init() {
            //Use this if NavigationBarTitle is with Large Font
            UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.red]

            //Use this if NavigationBarTitle is with displayMode = .inline
            UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.red]
        }

    @State private var cEvent: URL?
    @State private var selection: String? = nil

    var body: some View {
        NavigationView(content: {
            ScrollView(content: {
                let _ = Self._printChanges()
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
                FourLakesConciergeView(["Zone1"], events: { conciergeEvent in
                    if FourLakesConcierge.willNavigate(conciergeEvent) {
                        cEvent = conciergeEvent
                        selection = "4"
                    } else {
                        FourLakesConcierge.handleNonNavigationActionLink(conciergeEvent)
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
                }), tag: "4", selection: $selection) {
                    EmptyView()
                }
            })
            .background(Color(red:5.0/255.0,green: 84.0/255.0,blue:52.0/255.0))
            .navigationBarTitleDisplayMode(.inline)
        })
    }
}




struct AccountsView_Previews: PreviewProvider {
    static var previews: some View {
        AccountsView()
    }
}
