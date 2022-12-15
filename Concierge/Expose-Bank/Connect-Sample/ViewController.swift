//
//  ViewController.swift
//  Connect-Sample
//
//  Created by Caio on 2022-12-07.
//

import UIKit
import FlybitsConcierge

class ViewController: UIViewController {
    @IBOutlet private var connectButton: UIButton!
    @IBOutlet private var disconnectButton: UIButton!
    @IBOutlet private var physicalDeviceIdentifierTextField: UITextField!
    @IBOutlet private var customIdentifierTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let identifier = UIDevice.current.identifierForVendor?.uuidString {
            self.physicalDeviceIdentifierTextField.text = identifier
        } else {
            print("Failed to get the `UIDevice.current.identifierForVendor?.uuidString` information")
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        updateButtons()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let vc = segue.destination as? CustomerStatusViewController,
            let customerIdentifier = customIdentifierTextField.text
        else {
            return
        }

        vc.customerIdentifier = customerIdentifier
    }

    @IBAction func connectOnTouchUpInside(sender: UIButton) {
        let physicalIdentifier = self.physicalDeviceIdentifierTextField.text
        let customIdentifier = self.customIdentifierTextField.text

        Concierge.connect(with: AnonymousConciergeIDP(), customerId: customIdentifier, physicalDeviceId: physicalIdentifier) { error in
            if let error = error {
                print("Failed to connect. Reason \(error.localizedDescription)")
                self.updateButtons()
            } else {
                print("Connected with success")
                self.updateButtons()
            }
        }
    }

    @IBAction func disconnectOnTouchUpInside(sender: UIButton) {
        Concierge.disconnect { error in
            if let error = error {
                print("Failed to disconnect. Reason \(error.localizedDescription)")
                self.updateButtons()
            } else {
                print("Disconnected with success")
                self.updateButtons()
            }
        }
    }

    private func updateButtons() {
        if Thread.isMainThread {
            self.connectButton.isHidden = Concierge.isConnected
            self.disconnectButton.isHidden = !Concierge.isConnected
        } else {
            DispatchQueue.main.async {
                self.connectButton.isHidden = Concierge.isConnected
                self.disconnectButton.isHidden = !Concierge.isConnected
            }
        }
    }
}

