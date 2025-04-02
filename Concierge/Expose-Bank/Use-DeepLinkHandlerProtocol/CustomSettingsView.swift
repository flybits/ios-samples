//
//  CustomSettingsView.swift
//  Use-DeepLinkHandlerProtocol
//
//  Created by Caio Dias on 2025-04-02.
//

import SwiftUI
import UIKit

struct CustomSettingsView: View {
    typealias UIViewControllerType = UIViewController

    var body: some View {
        VStack {
            Text("This is your custom settings screen.")
            Text("You can have anything here.")
        }
        .padding()
    }
}

#Preview {
    CustomSettingsView()
}

