//
//  SceneDelegate.swift
//  CurrencyConverter
//
//  Created by Antonio Zdelican on 16.12.21.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        let networkManager = NetworkManager()
        let apiManager = APIManager(networkManager: networkManager)
        let contentViewModel = ContentViewModel(apiManager: apiManager)
        let contentView = ContentView(viewModel: contentViewModel)

        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }

}

