//
//  AppDelegate.swift
//  Banner-Bank
//
//  Created by Howard Tsai on 2022-05-26.
//

import UIKit
import FlybitsConcierge

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    let projectIdentifier: String = "2CE41988-B1D3-4116-98DD-42FFB8754384"
    let gatewayURL: String = "https://api.demo.flybits.com"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let config = FlybitsConciergeConfiguration.Builder().setProjectId(projectIdentifier).setGatewayUrl(gatewayURL).build()
        Concierge.configure(configuration: config, contextPlugins: [], launchOptions: launchOptions)

        return true
    }
}

