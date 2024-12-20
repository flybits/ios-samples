//
//  AppDelegate.swift
//  push-register-n-receive
//
//  Created by Caio Dias on 2024-12-19.
//

import UIKit
import FlybitsConcierge

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let projectIdentifier: String = "2CE41988-B1D3-4116-98DD-42FFB8754384"
    let gatewayURL: String = "https://api.demo.flybits.com"
    let webServiceURL: String = "https://api.demo.flybits.com"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        Concierge.enableLogging()

        /// Default configuration auto setup to set the project ID and the gateway so connect can happen any time
        let config = FlybitsConciergeConfiguration.Builder()
            .setProjectId(projectIdentifier)
            .setGatewayUrl(gatewayURL)
            .setWebService(webServiceURL)
            .build()

        Concierge.configure(configuration: config, contextPlugins: [], launchOptions: launchOptions)

        UNUserNotificationCenter.current().delegate = self

        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        guard deviceToken.count > 0 else {
            print("Not valid device token: \(deviceToken)")
            return
        }

        let deviceTokenString = deviceToken.map { String(format: "%02x", $0) }.joined()
        print("Device Token: \(deviceTokenString)")
        // Setting the device token here will cause the token to be registered with Flybits.
        Concierge.sendPush(token: deviceToken)
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.banner)
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if let conciergePush = Concierge.handlePush(response.notification.request.content.userInfo) {
            // It is Push message that Concierge can handle
            if let vc = Concierge.deepLink(conciergePush: conciergePush) {
                vc.title = "Notification Detail"
                DispatchQueue.main.async {
                    self.window?.rootViewController?.show(vc, sender: nil)
                }
            } else {
                // Nothing to be done because Concierge will act on it automatically.
            }
        } else {
            // It is the kind of push message that Concierge SDK won't handle. please use FlybitsPushSDK to handle it. or handle it in your own logic
        }

        completionHandler()
    }
}

extension UIViewController {
    @objc
    func dismissAnimated() {
        dismiss(animated: true, completion: nil)
    }
}
