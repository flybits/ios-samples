//
//  AppDelegate.swift
//  Migration-Test
//
//  Created by Michael Hollis on 2023-03-24.
//

import UIKit

import FlybitsSDK
import FlybitsContextSDK
import FlybitsContextLocationPluginSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        FlybitsManager.enableLogging()
        //FlybitsManager.environment = .demo
        ContextManager.shared.register([LocationContextPlugin()], launchOptions: launchOptions)

        let config = FlybitsConfiguration.Builder().setGateWayUrl("https://api.demo.flybits.com").setProjectId("2CE41988-B1D3-4116-98DD-42FFB8754384").build()
        FlybitsManager.configure(configuration: config)

        NotificationCenter.default.addObserver(self, selector: #selector(debugNotification), name: ContextManager.debugNotificationName, object: nil)

        return true
    }

    @objc func debugNotification(notification: NSNotification) {
        guard
            let title = notification.userInfo?["title"] as? String,
            let body = notification.userInfo?["message"] as? String
            else {
                return
        }

        print(title, body)

        //showLocalNotification(id: formatter.string(from: Date()), title: title, subtitle: "", body: body, badge: 0)
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

class LocationDelelgate: LocationContextPluginDelegate {

}
