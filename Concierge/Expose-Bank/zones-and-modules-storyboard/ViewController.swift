//
//  ViewController.swift
//  zones-and-modules-storyboard
//
//  Created by Caio Dias on 2024-12-18.
//

import UIKit
import FlybitsConcierge

class ViewController: UIViewController {
    @IBOutlet private var connectButton: UIButton!
    @IBOutlet private var disconnectButton: UIButton!
    @IBOutlet private var showConciergeButton: UIButton!

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

    @IBAction func showConciergeOnTouchUpInside(sender: UIButton) {
        let vc = Concierge.viewController(.configured, params: [], options: [])
        self.navigationController?.pushViewController(vc, animated: true)
    }

    private func updateButtons() {
        if Thread.isMainThread {
            self.connectButton.isHidden = Concierge.isConnected
            self.disconnectButton.isHidden = !Concierge.isConnected
            self.showConciergeButton.isEnabled = self.connectButton.isHidden
        } else {
            DispatchQueue.main.async {
                self.connectButton.isHidden = Concierge.isConnected
                self.disconnectButton.isHidden = !Concierge.isConnected
                self.showConciergeButton.isEnabled = self.connectButton.isHidden
            }
        }
    }
}
