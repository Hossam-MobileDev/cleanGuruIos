//
//  GHGGApp.swift
//  GHGG
//
//  Created by test on 11/05/2025.
//

import SwiftUI

import GoogleMobileAds



@main
struct GHGGApp: App {
    @StateObject private var languageManager = LanguageManager()
    //@UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var appOpenAdManager = AppOpenAdManager()


    init() {
            // Initialize Google Mobile Ads SDK
        GADMobileAds.sharedInstance().start(completionHandler: nil)

        }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(languageManager)
                .environmentObject(appOpenAdManager)

                .environment(\.layoutDirection, languageManager.isArabic ? .rightToLeft : .leftToRight)


        }
    }
}


//@main
//struct GHGGApp: App {
//    @StateObject private var languageManager = LanguageManager()
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
//    
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//                .environmentObject(languageManager)
//                .environment(\.layoutDirection, languageManager.isArabic ? .rightToLeft : .leftToRight)
//        }
//    }
//}
//
//class AppDelegate: NSObject, UIApplicationDelegate {
//    func application(_ application: UIApplication,
//                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
//        // Initialize Google Mobile Ads SDK with a slight delay to avoid potential issues
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            GADMobileAds.sharedInstance().start { status in
//                // You can inspect status.adapterStatusesByClassName if needed
//                print("AdMob initialization complete - status: \(status)")
//            }
//        }
//        return true
//    }
//}
//
//
//
//
