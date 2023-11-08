//
//  AppDelegate.swift
//  SpiceSaga
//
//  Created by Grishma Dave on 12/10/23.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import SwiftLoader

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        prepareApplication()
        return true
    }

    private func prepareApplication() {
        FirebaseApp.configure()
        var config : SwiftLoader.Config = SwiftLoader.Config()
        config.size = 150
        config.spinnerColor = .orange
        config.foregroundColor = .black
        config.foregroundAlpha = 0.5
        SwiftLoader.setConfig(config)
        
        if Auth.auth().currentUser != nil {
            guard let loginVc = SpiceSagaStoryBoards.main.getViewController(LoginViewController.self) else { return }
            guard let tabVc = SpiceSagaStoryBoards.main.getViewController(HomeTabViewController.self) else { return }
            let navigationVc: UINavigationController = UINavigationController(rootViewController: loginVc)
            navigationVc.viewControllers = [tabVc]
            window?.rootViewController = navigationVc
        }
        FirebaseAuthManager.shared.setUpUserDetails()
    }
    
    


}

