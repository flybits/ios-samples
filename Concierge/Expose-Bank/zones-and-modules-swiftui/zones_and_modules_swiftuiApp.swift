//
//  zones_and_modules_swiftuiApp.swift
//  zones-and-modules-swiftui
//
//  Created by Caio Dias on 2024-12-18.
//

import SwiftUI
import FlybitsConcierge

@main
struct zones_and_modules_swiftuiApp: App {
    let projectIdentifier: String = "2CE41988-B1D3-4116-98DD-42FFB8754384"
    let gatewayURL: String = "https://api.demo.flybits.com"
    let webServiceURL: String = "https://static-files-concierge.demo.flybits.com/latest"

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }

    init() {
        Concierge.enableLogging()

        let config = FlybitsConciergeConfiguration.Builder()
            .setProjectId(projectIdentifier)
            .setGatewayUrl(gatewayURL)
            .setWebService(webServiceURL)
            .build()

        Concierge.configure(configuration: config, contextPlugins: [])
    }
}
