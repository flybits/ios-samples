//
//  AppDelegate.swift
//  zones-and-modules-storyboard
//
//  Created by Caio Dias on 2024-12-18.
//

import UIKit
import FlybitsConcierge

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    let projectIdentifier: String = "2CE41988-B1D3-4116-98DD-42FFB8754384"
    let gatewayURL: String = "https://api.demo.flybits.com"
    let webServiceURL: String = "https://static-files-concierge.demo.flybits.com/latest"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        Concierge.enableLogging()

        let config = FlybitsConciergeConfiguration.Builder()
            .setProjectId(projectIdentifier)
            .setGatewayUrl(gatewayURL)
            .setWebService(webServiceURL)
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

