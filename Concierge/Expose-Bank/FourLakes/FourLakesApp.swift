//
//  FourLakesApp.swift
//  FourLakes
//
//  Created by Michael Hollis on 2023-03-14.
//

import SwiftUI

// Specify all root level screens
enum Screen {
    case authentication
    case account
}

final class AppCoordinator: ObservableObject {
    @Published var screen: Screen = .authentication

    func authenticationView() -> some View {
         return AuthenticationScreen()
    }

    func accountView() -> some View {
        return AccountsView()
    }
}

@main
struct FourLakesApp: App {
    @ObservedObject var coordinator = AppCoordinator()

    init() {
        FourLakesConcierge.configure()
    }

    var body: some Scene {
        WindowGroup {
            switch coordinator.screen {
            case .authentication:
                coordinator.authenticationView().environmentObject(self.coordinator)
            case .account:
                coordinator.accountView().environmentObject(self.coordinator)
            }
        }
    }
}
