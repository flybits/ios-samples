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

    var body: some View {
        NavigationView(content: {
            ScrollView(content: {
                FourLakesConciergeView(["Zone1"], events: {
                }).applyHeight()
                ForEach(["Accounts", "Manage Transfers", "Savings"], id: \.self) { name in
                    HStack {
                        Text(name)
                    }.frame(maxWidth: .infinity, minHeight: 60).background(content: {
                        RoundedRectangle(cornerRadius: 10).fill(.white).shadow(radius: 1)
                    })
                }.padding([.leading, .trailing], 5).padding([.bottom], 5)
            })
            .background(Color(red: 211.0/255.0, green: 211.0/255.0, blue: 211.0/255.0))
            .navigationTitle("Hello World")
            .navigationBarTitleDisplayMode(.inline)
        }).padding()
    }
}




struct AccountsView_Previews: PreviewProvider {
    static var previews: some View {
        AccountsView()
    }
}
