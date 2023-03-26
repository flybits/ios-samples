//
//  FourLakesApp.swift
//  FourLakes
//
//  Created by Michael Hollis on 2023-03-14.
//

import SwiftUI


// Specify all root level screens
enum Screen {
    case authentication
    case account
}

final class AppCoordinator: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    @Published var screen: Screen = .authentication
    @Published var notifications: URL?


    func authenticationView() -> some View {
         return AuthenticationScreen()
    }

    func accountView() -> some View {
        return AccountsView()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        if let conciergePush = FourLakesConcierge.isFlybitsActionableLink(response) {
            self.notifications = conciergePush
        } else {
            //Not Flybits.
            print(response.notification.request.content.userInfo)

            if let base64data = response.notification.request.content.userInfo["data"] as? String, let data = Data(base64Encoded: base64data.data(using: .utf8) ?? Data()),
                let jsonObj = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let body = jsonObj["body"] as? [String: Any], let actionScheme = body["actionScheme"] as? String, let url = URL(string: actionScheme) {

                DispatchQueue.main.sync {
                    notifications = url
                }

            } else {
                fatalError("lbah")
            }


        }
    }
}

@main
struct FourLakesApp: App {
    @ObservedObject var coordinator = AppCoordinator()
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate

    init() {
        UNUserNotificationCenter.current().delegate = self.coordinator
        FourLakesConcierge.configure()
    }

    var body: some Scene {
        WindowGroup {
            switch coordinator.screen {
            case .authentication:
                coordinator.authenticationView().environmentObject(self.coordinator)
            case .account:
                coordinator.accountView().environmentObject(self.coordinator)
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

let b64 = """
eyJpZCI6IjA2RjE2MTU2LUYyRjQtNEIzMy1CNEFDLTNCMzNGNjg2RUI4RSIsInZlcnNpb24iOjIsInRpbWVzdGFtcCI6MTY3OTc3MDA2NiwiY2F0ZWdvcnkiOiJjdXN0b20iLCJlbnRpdHkiOiJjdXN0b20iLCJhY3Rpb24iOiJjdXN0b20iLCJhbGVydCI6IlRlc3QhIiwidGl0bGUiOiJUZXN0ISIsImJvZHkiOnsiYWN0aW9uU2NoZW1lIjoiZGV0YWlsczovLyIsInB1c2hQYXlsb2FkVHlwZUlkIjoiQ0ExN0M5MzUtQ0ZGNy00MDNBLUIzNUEtQ0RCNTBCODdBNEVFIiwicHVzaFJlcXVlc3RJZCI6IjA2RjE2MTU2LUYyRjQtNEIzMy1CNEFDLTNCMzNGNjg2RUI4RSJ9LCJwcm92aWRlciI6ImZseWJpdHMifQ==
"""

        if let data = Data(base64Encoded: b64.data(using: .utf8) ?? Data()),
            let jsonObj = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
           let body = jsonObj["body"] as? [String: Any], let actionScheme = body["actionScheme"] as? String {
            print(actionScheme)
        } else {
            fatalError("lbah")
        }



//        let center = UNUserNotificationCenter.current()
//            center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
//
//                // If granted comes true you can enabled features based on authorization.
//                DispatchQueue.main.sync {
//                    application.registerForRemoteNotifications()
//                }
//            }
        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print(deviceToken.hexString)
        FourLakesConcierge.uploadPush(token: deviceToken)
    }
}

extension Data {
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
}
