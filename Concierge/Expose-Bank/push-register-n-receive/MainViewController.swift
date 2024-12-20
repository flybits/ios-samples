//
//  ViewController.swift
//  push-register-n-receive
//
//  Created by Caio Dias on 2024-12-19.
//

import UIKit
import FlybitsConcierge

class MainViewController: UIViewController {
    @IBOutlet private var connectButton: UIButton!
    @IBOutlet private var requestPushPermissionButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.requestPushPermissionButton.isEnabled = Concierge.pushTokenUploadStatus() == .sent
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        updateButtons()
    }

    @IBAction func connectOnTouchUpInside(sender: UIButton) {
        Concierge.connect(with: AnonymousConciergeIDP()) { error in
            if let error = error {
                print("Failed to connect. Reason \(error.localizedDescription)")
            } else {
                print("Connected with success")
            }

            self.updateButtons()
        }
    }

    @IBAction func disconnectOnTouchUpInside(sender: UIButton) {
        Concierge.disconnect { error in
            if let error = error {
                print("Failed to disconnect. Reason \(error.localizedDescription)")
            } else {
                print("Disconnected with success")
            }

            self.updateButtons()
        }
    }

    @IBAction func requestPushPermissionOnTouchUpInside(sender: UIButton) {
        Task { @MainActor in
            let center = UNUserNotificationCenter.current()

            do {
                try await center.requestAuthorization(options: [.alert, .sound, .badge])

                UIApplication.shared.registerForRemoteNotifications()

                self.updateButtons()
            } catch {
                print("Error requesting the push permission. More info: \(error.localizedDescription)")
            }
        }
    }

    private func updateButtons() {
        if Thread.isMainThread {
            self.connectButton.isEnabled = Concierge.isConnected
            self.requestPushPermissionButton.isEnabled = Concierge.pushTokenUploadStatus() == .sent ? true : Concierge.isConnected;
        } else {
            DispatchQueue.main.async {
                self.connectButton.isEnabled = Concierge.isConnected
                self.requestPushPermissionButton.isEnabled = Concierge.pushTokenUploadStatus() == .sent ? true : Concierge.isConnected;
            }
        }
    }
}

