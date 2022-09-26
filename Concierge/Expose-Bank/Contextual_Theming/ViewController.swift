//
//  ViewController.swift
//  Contextual_Theming
//
//  Created by Caio on 2022-09-26.
//

import UIKit
import FlybitsConcierge

class ViewController: UIViewController {
    @IBOutlet private var firstView: UIView!
    @IBOutlet private var secondView: UIView!
    @IBOutlet private var thirdView: UIView!
    @IBOutlet private var scrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.firstView.backgroundColor = .white
        self.secondView.backgroundColor = .white
        self.thirdView.backgroundColor = .white

        // This Concierge Exposé instance will use the global concierge_theme.json file
        let concierge1 = Concierge.viewController(.expose,
                                                 params: [],
                                                 options: [])

        attach(viewController: concierge1, to: firstView)

        // This Concierge Exposé instance will use the custom_theme.json file provided as parameter.
        let concierge2 = Concierge.viewController(.expose,
                                                  params: [],
                                                  options: [.customTheme(.filename("custom_theme"))])

        attach(viewController: concierge2, to: secondView)

        // This Concierge Exposé instance will use the JSON String provided as parameter.
        let concierge3 = Concierge.viewController(.expose,
                                                  params: [],
                                                  options: [.customTheme(.json("""
                                                                               {\"expose\": {
                                                                                \"container\": {
                                                                                    \"backgroundColor\": {
                                                                                        \"light\": \"#f6eb05\",
                                                                                        \"dark\": \"#312f01\"
                                                                                    }
                                                                                }
                                                                               },
                                                                               \"dynamicContentFeed\": {
                                                                                    \"backgroundColor\": {
                                                                                        \"light\": \"#f6eb05\",
                                                                                        \"dark\": \"#312f01\"
                                                                                    }
                                                                               }
                                                                               }
                                                                               """))])

        attach(viewController: concierge3, to: thirdView)

//        self.scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: 350 * 3 + 16)

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

    private func attach(viewController: UIViewController, to view: UIView) {
        addChild(viewController)
        viewController.view.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(viewController.view)

        NSLayoutConstraint.activate([
            viewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        viewController.didMove(toParent: self)
    }
}

