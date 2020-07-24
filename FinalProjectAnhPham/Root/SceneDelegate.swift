//
//  SceneDelegate.swift
//  FinalProjectAnhPham
//
//  Created by MBA0321 on 6/30/20.
//  Copyright © 2020 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit
import LGSideMenuController
import SVProgressHUD

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    // MARK: - Singleton
    static var share: SceneDelegate {
        guard let scene = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
            fatalError("No catching scene delegate")
        }
        return scene
    }
    
    private override init() {
        
    }
    
    // MARK: - Properties
    lazy var sideMenu = LGSideMenuController()
    var window: UIWindow?
    
    // MARK: - Function
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        setupSideMenu()
        (UIApplication.shared.delegate as? AppDelegate)?.window = window
        window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    private func setupSideMenu() {
        let rootView = UINavigationController(rootViewController: HomeViewController())
        let leftView = SideMenuViewController()
        sideMenu.rootViewController = rootView
        sideMenu.leftViewController = leftView
        sideMenu.leftViewWidth = UIScreen.main.bounds.width / 1.5
        window?.rootViewController = sideMenu
    }
}
