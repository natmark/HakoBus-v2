//
//  AppDelegate.swift
//  HakoBus-v2
//
//  Created by AtsuyaSato on 2018/03/29.
//  Copyright © 2018年 Atsuya Sato. All rights reserved.
//

import UIKit
import RxSwift
import APIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let generateNavigationController = { (rootViewController: UIViewController) -> UINavigationController in
        var navigationController: UINavigationController
        navigationController =  UINavigationController(rootViewController: rootViewController)
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.barTintColor = #colorLiteral(red: 0.6321853995, green: 0.07877074927, blue: 0.007939325646, alpha: 1)
        navigationController.navigationBar.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        navigationController.navigationBar.prefersLargeTitles = true

        let textAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController.navigationBar.titleTextAttributes = textAttributes
        navigationController.navigationBar.largeTitleTextAttributes = textAttributes

        return navigationController
    }

    let tabBarController: UITabBarController = {
        let tabBarController = UITabBarController()
        tabBarController.tabBar.tintColor = #colorLiteral(red: 0.6321853995, green: 0.07877074927, blue: 0.007939325646, alpha: 1)
        tabBarController.tabBar.isTranslucent = false
        tabBarController.tabBar.barTintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return tabBarController
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UINavigationBar.appearance().shadowImage = UIImage()

        let searchViewController = SearchViewController.create()

        let searchNavigationController = self.generateNavigationController(searchViewController)

        searchNavigationController.tabBarItem = UITabBarItem(title: "検索", image: UIImage(named: "busIcon"), tag: 1)

        self.tabBarController.setViewControllers(
            [
                searchNavigationController,
                ],
            animated: true)

        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = self.tabBarController
        self.window?.makeKeyAndVisible()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}
