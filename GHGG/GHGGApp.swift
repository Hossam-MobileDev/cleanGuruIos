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

    init() {
            // Initialize Google Mobile Ads SDK
            GADMobileAds.sharedInstance().start(completionHandler: { _ in
                // Initialization complete
                print("Google Mobile Ads SDK initialized")
            })
            
            // Or you can use nil explicitly with the correct type
            // GADMobileAds.sharedInstance().start(completionHandler: { (_: GADInitializationStatus?) in })
        }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(languageManager)
                .environment(\.layoutDirection, languageManager.isArabic ? .rightToLeft : .leftToRight)


        }
    }
}
