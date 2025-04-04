//
//  CustomSettingsViewController.swift
//  Expose-Bank
//
//  Created by Caio Dias on 2025-04-02.
//

import UIKit
import SwiftUI

protocol Dismissable: UIViewController {
    func dismissView()
}

final class CustomSettingsViewController: UIViewController {

    var contentView: CustomSettingsView

    init(contentView: CustomSettingsView) {
        self.contentView = contentView
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let hostingController = UIHostingController(rootView: contentView)

        // Add the SwiftUI view as a child view controller
        addChild(hostingController)

        // Add the SwiftUI view to the view hierarchy
        view.addSubview(hostingController.view)

        // Set constraints for the SwiftUI view
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        // Notify the hosting controller that it has been moved to a parent view controller.
        hostingController.didMove(toParent: self)
    }
}

extension CustomSettingsViewController: Dismissable {
    @objc
    func dismissView() {
        dismiss(animated: true, completion: nil)
    }
}

