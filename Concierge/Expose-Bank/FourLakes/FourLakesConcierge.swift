//
//  FourLakesConcierge.swift
//  FourLakes
//
//  Created by Michael Hollis on 2023-03-14.
//

import Foundation
import FlybitsConcierge
import SwiftUI

final class FourLakesConcierge {
    static func authenticate(_ email: String, apiKey key: String, completion: @escaping () -> ()) {
        let apiKey = APIKeyConciergeIDP(email: email, apiKey: key)

        Concierge.connect(with: apiKey, completion: { error in
            completion()
        })
    }

    static func configure() {
        let config = FlybitsConciergeConfiguration.Builder()
            .setProjectId("2CE41988-B1D3-4116-98DD-42FFB8754384")
            .setGatewayUrl("https://api.demo.flybits.com")
            .setWebService("http://localhost:3000").build()
        Concierge.configure(configuration: config, contextPlugins: [])
    }
}

struct FourLakesConciergeView: View {

    let zoneReferences: [String]
    let events: (() -> ())?

    private class internalDelegate: ConciergeEventsDelegate {
        var identifier: String = "\(#function)"

        func event(_ actionlink: URL, identifier: String) {
            print("HERE")
            Concierge.handleActionableLink(actionlink)
        }
    }


    init(_ references: [String], events: (() -> ())?) {
        self.zoneReferences = references
        self.events = events
    }

    var body: some View {
        FourLakeConcierge(Concierge.zoneConfigurations(for: zoneReferences), Concierge.delegate(from: internalDelegate()))
    }
}

extension FourLakesConciergeView {
    func applyHeight() -> some View {
        let p = Concierge.zoneConfigurations(for: zoneReferences)

        if p.height.isZero {
            return self.frame(height: 300)
        } else {
            return self.frame(height: p.height)
        }
    }
}



struct FourLakeConcierge: UIViewControllerRepresentable {

    let delegate: AnyConciergeEventsDelegate<ConciergeEventsDelegate>
    let zoneConfig: ZonesConfig

    init(_ zm: ZonesConfig, _ delegate: AnyConciergeEventsDelegate<ConciergeEventsDelegate>) {
        self.zoneConfig = zm
        self.delegate = delegate
    }

    func makeUIViewController(context: Context) -> UIViewController {
        return Concierge.viewController(.configured, params: [.requestEvents(self.delegate), .zonesfilter(zoneConfig)], options: [])
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }

    typealias UIViewControllerType = UIViewController
}

