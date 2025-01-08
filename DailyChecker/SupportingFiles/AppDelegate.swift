//
//  AppDelegate.swift
//  DailyChecker
//
//  Created by Jaume García on 7/1/25.
//

import UIKit

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    private let notificationCenter = UNUserNotificationCenter.current()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        requestAuthForLocalNotifications()
        return true
    }
    
    private func requestAuthForLocalNotifications(){
          notificationCenter.delegate = self
          let options: UNAuthorizationOptions = [.alert, .sound, .badge]
          notificationCenter.requestAuthorization(options: options) { (didAllow, error) in
              if !didAllow {
                  print("User has declined notification")
              }
          }
      }
}
