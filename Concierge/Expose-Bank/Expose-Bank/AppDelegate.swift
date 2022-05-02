//
//  AppDelegate.swift
//  Expose-Bank
//
//  Created by Caio on 2022-05-02.
//

import UIKit
import FlybitsConcierge

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        /// Default configuration auto setup to open the sample app with content to be displayed
        let config = FlybitsConciergeConfiguration.Builder().setProjectId("D57EBC96-209B-44F7-88F7-091EF8CEA4B5").setGatewayUrl("https://api.demo.flybits.com").build()
        Concierge.configure(configuration: config, contextPlugins: [], launchOptions: launchOptions)

        /// Default connect
        if !Concierge.isConnected {
            Concierge.connect(with: AnonymousConciergeIDP()) { error in
                guard error == nil else {
                    print("Error: failed to connect due to \(error!.localizedDescription)")
                    return
                }

                print("Flybits connection succeed.")
            }
        }
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

