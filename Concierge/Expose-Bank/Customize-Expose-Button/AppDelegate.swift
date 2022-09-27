//
//  AppDelegate.swift
//  Customize-Expose-Button
//
//  Created by Caio on 2022-09-26.
//

import UIKit
import FlybitsConcierge

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        /// Default configuration auto setup to set the project ID and the gateway so connect can happen any time
        let config = FlybitsConciergeConfiguration.Builder()
                        .setProjectId("2CE41988-B1D3-4116-98DD-42FFB8754384")
                        .setGatewayUrl("https://api.demo.flybits.com")
                        .build()

        Concierge.configure(configuration: config, contextPlugins: [], launchOptions: launchOptions)
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

