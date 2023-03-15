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
                FourLakesConciergeView(["Zone1"], events: { conciergeEvent in
                    if FourLakesConcierge.willNavigate(conciergeEvent) {
                        cEvent = conciergeEvent
                        selection = "4"
                    } else {
                        FourLakesConcierge.handleNonNavigationActionLink(conciergeEvent)
                    }
                }).applyHeight()

                ForEach(["Accounts", "Manage Transfers", "Savings"], id: \.self) { name in
                    HStack {
                        Text(name)
                    }.frame(maxWidth: .infinity, minHeight: 60).background(content: {
                        RoundedRectangle(cornerRadius: 10).fill(.white).shadow(radius: 1)
                    })
                }
                .padding([.leading, .trailing], 5).padding([.bottom], 5)
                .background(Color(red: 211.0/255.0, green: 211.0/255.0, blue: 211.0/255.0))
                NavigationLink(destination:FourLakesConciergeView(cEvent, events: { conciergeEvent in
                    print(conciergeEvent)
                }), tag: "4", selection: $selection) {
                    EmptyView()
                }
            })
            .background(.green)
            .navigationTitle("Hello World")
            .navigationBarTitleDisplayMode(.inline)

        })
    }
}




struct AccountsView_Previews: PreviewProvider {
    static var previews: some View {
        AccountsView()
    }
}
