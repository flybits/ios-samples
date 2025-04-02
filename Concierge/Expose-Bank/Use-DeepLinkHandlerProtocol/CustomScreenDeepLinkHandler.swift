//
//  CustomScreen.swift
//  Expose-Bank
//
//  Created by Caio Dias on 2025-04-02.
//

import UIKit
import SwiftUI
import FlybitsConcierge
import FlybitsCoreConcierge
import FlybitsKernelSDK

struct CustomScreenDeepLinkHandler: DeepLinkHandlerProtocol {
    static var identifier: String {
        "customScreenView" // This string is the identifier that must be used on Actionable Link app name value.
    }

    static func viewController(contentData: ContentData?) -> UIViewController? {
        /// When `contentData` is not nil, it will have content information, such as title, description, header...
        return CustomSettingsViewController(contentView: CustomSettingsView())
    }

    static func customPresent(presentingController: UIViewController) -> ConciergeCallToActionResult {

        presentingController.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: presentingController, action: #selector(CustomSettingsViewController.dismissView))

        let navigationController = UINavigationController(rootViewController: presentingController)

        return .show(navigationController)
    }
}
