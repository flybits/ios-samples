//
//  ViewController.swift
//  Anonymous-Connect
//
//  Created by Caio on 2020-04-24.
//  Copyright © 2020 Flybits. All rights reserved.
//

import UIKit
import FlybitsSDK

class ViewController: UIViewController {
    @IBOutlet private var projectIdTextfield: UITextField!
    @IBOutlet private var connectButton: UIButton!
    @IBOutlet private var discconnectButton: UIButton!

    private let animationTimeInterval: TimeInterval = 0.25

    override func viewDidLoad() {
        super.viewDidLoad()

        // Validate if there is already a previous connection
        if FlybitsManager.isConnected {
            // In case there is a previous connection don't allow to connect again.
            // The desirable scenario is always disconnect before start another connection
            UIView.animate(withDuration: self.animationTimeInterval) {
                self.connectButton.isHidden = true
                self.discconnectButton.isHidden = false
                self.projectIdTextfield.isEnabled = false
            }
        }
    }

    @IBAction func connectTouchUpInside(_ button: UIButton) {
        guard let projectId = self.projectIdTextfield.text else {
            print("Unable to get the project ID information from screen")
            return
        }

        let anonIDP = AnonymousIDP()

        FlybitsManager.connect(anonIDP, projectId: projectId) { (user, error) in
            guard let user = user else {
                let errorNonNil: Error

                if let error = error {
                    errorNonNil = error
                } else {
                    errorNonNil = NSError(domain: "com.flybits", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unkonwn error happened."])
                }

                self.errorScenario(with: errorNonNil)

                return
            }

            self.successScenario(with: user, on: projectId)

            DispatchQueue.main.async {
                UIView.animate(withDuration: self.animationTimeInterval) {
                    self.connectButton.isHidden = true
                    self.discconnectButton.isHidden = false
                    self.projectIdTextfield.isEnabled = false
                }
            }
        }
    }

    @IBAction func disconnectTouchUpInside(_ button: UIButton) {
        FlybitsManager.disconnect { (_, error) in
            guard error == nil else {
                self.errorScenario(with: error!)
                return
            }

            let alertController = UIAlertController(title: "Success", message: "Disconnect sucessfully.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))

            DispatchQueue.main.async {
                self.present(alertController, animated: true, completion: nil)
            }

            DispatchQueue.main.async {
                UIView.animate(withDuration: self.animationTimeInterval) {
                    self.connectButton.isHidden = false
                    self.discconnectButton.isHidden = true
                    self.projectIdTextfield.isEnabled = true
                }
            }
        }
    }

    private func successScenario(with user: User, on projectId: String) {
        let alertController = UIAlertController(title: "Success", message: "Connection sucessful to \(projectId).\n\nUser Information: \(user.description)", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))

        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }

    private func errorScenario(with error: Error) {
        let alertController = UIAlertController(title: "Fail", message: "Connection failed.\n\nError Information: \(error)", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))

        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

/// Extension added to override the basic implementation and avoid have too much code on the sample code
extension User: CustomStringConvertible {
    override public var description: String {
        return """
        \nIdentifier: \(self.identifier)
        \nDevice ID: \(self.deviceID ?? "No device ID")
        \nEmail: \(self.email ?? "No email")
        \nFirst Name: \(self.firstName ?? "No first name")
        \nLast Name: \(self.lastName ?? "No last name")
        """
    }
}
