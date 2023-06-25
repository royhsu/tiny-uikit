//
//  AppDelegate.swift
//  Demo
//
//  Created by Roy Hsu on 2022/2/11.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions
      launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let newWindow = UIWindow(frame: UIScreen.main.bounds)
    window = newWindow
    newWindow.rootViewController = ContactListViewController()
    newWindow.makeKeyAndVisible()
    return true
  }
}
