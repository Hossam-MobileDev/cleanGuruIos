//
//  splashView.swift
//  GHGG
//
//  Created by test on 14/07/2025.
//

import SwiftUI

struct SplashView: View {
    @EnvironmentObject var languageManager: LanguageManager
    
    var body: some View {
        ZStack {
            Color(hex: "F0F4F8")
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                // App Logo
                Image("clean_guru_logo") // Replace with your actual logo
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                
           
                
                Spacer()
            }
        }
        .environment(\.layoutDirection, languageManager.isArabic ? .rightToLeft : .leftToRight)
    }
}

