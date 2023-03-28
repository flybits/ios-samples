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
            .setProjectId("08A0D8CA-2173-4756-B70C-96A0984D8C68")
            .setGatewayUrl("https://api.demo.flybits.com")
            .setWebService("http://localhost:3000").build()
        Concierge.configure(configuration: config, contextPlugins: [])
    }

    static func willNavigate(_ actionURL: URL) -> Bool {
        guard let components = URLComponents(url: actionURL, resolvingAgainstBaseURL: false) else {
            return false
        }

        print(["concierge", "details"].contains(components.scheme!))

        if let scheme = components.scheme, ["concierge", "details"].contains(scheme) {
            return true
        } else {
            return false
        }
    }

    static func handleNonNavigationActionLink(_ actionableLink: URL) {
        _ = Concierge.handleActionableLink(actionableLink)
    }

    static func uploadPush(token: Data) {
        Concierge.sendPush(token: token)
    }

    static func disconnect() {
        Concierge.disconnect() { error in
            print(error)
        }
    }

    static func isFlybitsActionableLink(_ response: UNNotificationResponse) -> URL? {
        guard let conciergePush = Concierge.handlePush(response.notification.request.content.userInfo) else {
            return nil
        }
        return Concierge.actionableLink(from: conciergePush)
    }
}

struct FourLakesConciergeView: View {

    let zoneReferences: [String]
    let events: ((URL) -> ())?
    let actionLinkURL: URL?

    private class internalDelegate: ConciergeEventsDelegate {
        var identifier: String = "\(#function)"

        let events: ((URL) -> ())?

        func event(_ actionlink: URL, identifier: String) {
            events?(actionlink)
        }

        init(_ events: ((URL) -> ())?) {
            self.events = events
        }
    }


    init(_ references: [String], events: ((URL) -> ())?) {
        self.zoneReferences = references
        self.events = events
        self.actionLinkURL = nil
    }

    init(_ actionLink: URL?, events: ((URL) -> ())?) {
        self.zoneReferences = []
        self.events = events
        self.actionLinkURL = actionLink
    }

    var body: some View {
        guard let actionLinkURL = self.actionLinkURL else {
            return FourLakeConcierge(Concierge.zoneConfigurations(for: zoneReferences), Concierge.delegate(from: internalDelegate(events)))
        }
        return FourLakeConcierge(actionLinkURL, Concierge.delegate(from: internalDelegate(events)))
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
    let zoneConfig: ZonesConfig?
    let actionableLink: URL?

    init(_ zm: ZonesConfig, _ delegate: AnyConciergeEventsDelegate<ConciergeEventsDelegate>) {
        self.zoneConfig = zm
        self.delegate = delegate
        self.actionableLink = nil
    }

    init(_ actionLink: URL, _ delegate: AnyConciergeEventsDelegate<ConciergeEventsDelegate>) {
        self.zoneConfig = nil
        self.delegate = delegate
        self.actionableLink = actionLink
    }

    func makeUIViewController(context: Context) -> UIViewController {
        
        if let actionableLink = self.actionableLink {
            return Concierge.handleActionableLink(actionableLink) ?? UIViewController()
        } else {
            guard let zm = zoneConfig else {
                return Concierge.viewController(.configured, params: [.requestEvents(self.delegate)], options: [.customLoadingScreen(AnyLoadingViewable(MyLoadingViewable()))])
            }
            return Concierge.viewController(.configured, params: [.requestEvents(self.delegate), .zonesfilter(zm)], options: [.customLoadingScreen(AnyLoadingViewable(MyLoadingViewable()))])
        }
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }

    typealias UIViewControllerType = UIViewController
}


class MyLoadingViewable: LoadingViewable {

    func view(_ hasContent: Bool, _ conciergeCustomerStatus: FlybitsConcierge.ConciergeCustomerStatus) -> UIView {
        let retView = UIView()
        retView.backgroundColor = .red
        return retView
    }

    func start() {

    }

    func stop() {

    }
}

struct Previews_FourLakesConcierge_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
