//
//  ViewController.swift
//  FullScreen_Concierge
//
//  Created by MikeH on 2022-05-19.
//

import UIKit
import FlybitsConcierge

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let concierge = Concierge.viewController(.none, params: [], options: [])
        addChild(concierge)

        view.addSubview(concierge.view)

        NSLayoutConstraint.constraints(withVisualFormat: "H:|[child]|", metrics: nil, views: ["child": concierge.view!])
        NSLayoutConstraint.constraints(withVisualFormat: "V:|[child]|", metrics: nil, views: ["child": concierge.view!])

        concierge.didMove(toParent: self)


        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Login/Logout", image: nil, primaryAction: UIAction(handler: { action in
            if !Concierge.isConnected {
                Concierge.connect(with: AnonymousConciergeIDP()) { error in
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

