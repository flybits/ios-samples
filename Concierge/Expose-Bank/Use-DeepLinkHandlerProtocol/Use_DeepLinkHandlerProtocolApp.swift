//
//  Use_DeepLinkHandlerProtocolApp.swift
//  Use-DeepLinkHandlerProtocol
//
//  Created by Caio Dias on 2025-04-02.
//

import SwiftUI
import FlybitsConcierge

@main
struct Use_DeepLinkHandlerProtocolApp: App {
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

        // Register your Deeplink Handler so Concierge knows about it
        Concierge.configure(configuration: config, contextPlugins: [], deepLinkHandlers: [CustomScreenDeepLinkHandler.self])
    }
}
