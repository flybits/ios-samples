//
//  CustomerStatusViewController.swift
//  Connect-Sample
//
//  Created by Caio on 2022-12-15.
//

import UIKit
import FlybitsConcierge

class CustomerStatusViewController: UIViewController {
    @IBOutlet private var checkButton: UIButton!
    @IBOutlet private var customerIdentifierTextField: UITextField!
    @IBOutlet private var resultLabel: UILabel!

    var customerIdentifier: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        resultLabel.text = ""
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if !customerIdentifier.isEmpty {
            self.customerIdentifierTextField.text = customerIdentifier
        }
    }

    @IBAction func checkOnTouchUpInside(sender: UIButton) {
        // The Custom Identifier must match the same value used during Concierge.Connect API call. If multiple users are connecting, the identifier must be unique per user.
        guard let customIdentifier = self.customerIdentifierTextField.text else {
            print("Not able to get customer identifier value")
            return
        }

        let result = Concierge.status(for: customIdentifier)

        resultLabel.text = "\(result)"
    }
}
