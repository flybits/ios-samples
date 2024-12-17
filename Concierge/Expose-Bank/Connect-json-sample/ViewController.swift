//
//  ViewController.swift
//  Connect-json-sample
//
//  Created by Caio Dias on 2024-12-17.
//

import UIKit
import FlybitsConcierge

class ViewController: UIViewController {
    @IBOutlet private var connectButton: UIButton!
    @IBOutlet private var disconnectButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        updateButtons()
    }

    @IBAction func connectOnTouchUpInside(sender: UIButton) {
        Concierge.connect(with: AnonymousConciergeIDP()) { error in
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

