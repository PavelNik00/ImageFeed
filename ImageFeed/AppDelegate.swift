//
//  AppDelegate.swift
//  ImageFeed
//
//  Created by Pavel Nikipelov on 30.11.2023.
//

import UIKit
import ProgressHUD

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
            configureProgressHUD()
            return true
        }
    
    func configureProgressHUD() {
        ProgressHUD.animationType = .squareCircuitSnake
        ProgressHUD.colorAnimation = .lightGray
        ProgressHUD.colorBackground = .ypBlack
        ProgressHUD.colorHUD = .ypBlack
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let sceneConfiguration = UISceneConfiguration(
            name: "Main",
            sessionRole: connectingSceneSession.role
        )
        sceneConfiguration.delegateClass = SceneDelegate.self
        return sceneConfiguration
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}

