//
//  ViewController.swift
//  Customize-Expose-Button
//
//  Created by Caio on 2022-09-26.
//

import UIKit
import FlybitsConcierge

class ViewController: UIViewController {
    @IBOutlet private var middleScreenView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        /// The use of `exposeCallToAction` will customize the Concierge Exposé See All button to be Custom Title and the action on click to open the URL https://flybits.com
        let concierge = Concierge.viewController(.expose,
                                                 params: [],
                                                 options: [.exposeCallToAction(title: "Custom Title",
                                                                               actionUrl: "https://flybits.com")])

        addChild(concierge)
        concierge.view.translatesAutoresizingMaskIntoConstraints = false

        middleScreenView.addSubview(concierge.view)

        NSLayoutConstraint.activate([
            concierge.view.leadingAnchor.constraint(equalTo: middleScreenView.leadingAnchor),
            concierge.view.trailingAnchor.constraint(equalTo: middleScreenView.trailingAnchor)
        ])

        concierge.didMove(toParent: self)

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Login/Logout", image: nil, primaryAction: UIAction(handler: { action in
            if !Concierge.isConnected {
                Concierge.connect(with: AnonymousConciergeIDP()) { error in
                    guard let error = error else { return }
                    print("\(error)")
                }
            } else {
                Concierge.disconnect { error in
                    guard let error = error else { return }
                    print("\(error)")
                }
            }
        }))
    }
}

