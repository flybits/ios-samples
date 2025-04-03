//
//  ContentView.swift
//  zones-and-modules-swiftui
//
//  Created by Caio Dias on 2024-12-18.
//

import SwiftUI
import FlybitsConcierge

struct ContentView: View {

    var body: some View {
        VStack {
            Text("Check the network via Xcode console due to SDK logging or a network sniffer app like Charles.")
            Button {
                Concierge.connect(with: AnonymousConciergeIDP()) { error in
                    if let error = error {
                        print("Failed to connect. Reason \(error.localizedDescription)")
                    } else {
                        print("Connected with success")
                    }
                }
            } label: {
                Text("Connect")
            }
            Button {
                Concierge.disconnect { error in
                    if let error = error {
                        print("Failed to disconnect. Reason \(error.localizedDescription)")
                    } else {
                        print("Disconnected with success")
                    }
                }
            } label: {
                Text("Disconnect")
            }
            ConciergeViewController()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

public struct ConciergeViewController: UIViewControllerRepresentable {

    public func makeUIViewController(context: Context) -> some UIViewController {
        return Concierge.viewController(.configured, params: [], options: [])
    }

    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

    }
}
