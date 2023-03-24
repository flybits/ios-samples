//
//  AuthenticationScreen.swift
//  FourLakes
//
//  Created by Michael Hollis on 2023-03-14.
//

import SwiftUI

struct AuthenticationScreen: View {
    @EnvironmentObject var coordinator: AppCoordinator
    
    @State var accountInfo = ""
    @State var password = ""
    @State var authenticate = false
    var body: some View {
            GeometryReader { geometry in
                ZStack {
                    VStack(alignment: .center) {
                        Text("Welcome To Four Lakes")
                        TextField("Account", text: $accountInfo)
                        TextField("Password", text: $password)
                        Button("Login", action: {
                            self.authenticate = true
                            //Simulate authenticating with your system
                            DispatchQueue.global().asyncAfter(deadline: .now() + 3, execute: {
                                FourLakesConcierge.authenticate("user@td.com", apiKey: "27A3D5C8-B58C-47C1-ACFB-8B4506017AEC", completion: {
                                    DispatchQueue.main.sync {
                                        //UIApplication.shared.registerForRemoteNotifications()
                                        self.coordinator.screen = .account
                                    }

                                })
                            })
                        })
                    }.opacity(self.authenticate ? 0.3 : 1)

                }.position(x: geometry.frame(in: .local).midX, y: geometry.frame(in: .local).midY)
                if authenticate {
                    VStack {
                        Text("Loading...")
                        ActivityIndicator(isAnimating: $authenticate, style: .large)
                    }.frame(width: geometry.size.width / 2, height: geometry.size.height / 5).background(Color.secondary.colorInvert()).cornerRadius(20).position(x: geometry.frame(in: .local).midX, y: geometry.frame(in: .local).midY)
                }
        }
    }
}

struct AuthenticationScreen_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationScreen()
    }
}
