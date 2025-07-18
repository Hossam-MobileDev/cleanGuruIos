//
//  onboardingView.swift
//  GHGG
//
//  Created by test on 14/07/2025.
//

import SwiftUI
// MARK: - Onboarding Container View
//struct OnboardingView: View {
//    @Binding var showOnboarding: Bool
//    @EnvironmentObject var languageManager: LanguageManager
//    @State private var currentPage = 0
//    
//    var body: some View {
//        ZStack {
//            LinearGradient(
//                gradient: Gradient(colors: [Color(hex: "D6E8F5"), Color.white]),
//                startPoint: .top,
//                endPoint: .bottom
//            )
//            .ignoresSafeArea()
//            
//            VStack {
//                // Skip Button
//                HStack {
//                    Spacer()
//                    Button("Skip") {
//                        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
//                        showOnboarding = false
//                    }
//                    .font(.custom("Almarai", size: 16))
//                    .foregroundColor(Color(hex: "718096"))
//                    .padding(.trailing, 20)
//                    .padding(.top, 10)
//                }
//                
//                // Page View
//                TabView(selection: $currentPage) {
//                    OnboardingPage1()
//                        .environmentObject(languageManager)
//                        .tag(0)
//                    OnboardingPage2()
//                        .environmentObject(languageManager)
//                        .tag(1)
//                    OnboardingPage3()
//                        .environmentObject(languageManager)
//                        .tag(2)
//                }
//                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
//                
//                // Page Indicators
//                HStack(spacing: 8) {
//                    ForEach(0..<3) { index in
//                        Circle()
//                            .fill(index == currentPage ? Color(hex: "2C5282") : Color(hex: "CBD5E0"))
//                            .frame(width: 8, height: 8)
//                    }
//                }
//                .padding(.bottom, 30)
//                
//                // Navigation Buttons
//                HStack(spacing: 16) {
//                    if currentPage > 0 {
//                        Button("Back") {
//                            withAnimation {
//                                currentPage -= 1
//                            }
//                        }
//                        .font(.custom("Almarai", size: 16))
//                        .foregroundColor(Color(hex: "3182CE"))
//                        .frame(maxWidth: .infinity)
//                        .frame(height: 50)
//                        .background(Color.white)
//                        .cornerRadius(25)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 25)
//                                .stroke(Color(hex: "3182CE"), lineWidth: 1)
//                        )
//                        
//                        Button(currentPage == 2 ? "Get Started" : "Next") {
//                            if currentPage == 2 {
//                                UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
//                                showOnboarding = false
//                            } else {
//                                withAnimation {
//                                    currentPage += 1
//                                }
//                            }
//                        }
//                        .font(.custom("AlmaraiBold", size: 16))
//                        .foregroundColor(.white)
//                        .frame(maxWidth: .infinity)
//                        .frame(height: 50)
//                        .background(Color(hex: "3182CE"))
//                        .cornerRadius(25)
//                    } else {
//                        // First page - only Next button, centered
//                        Button("Next") {
//                            withAnimation {
//                                currentPage += 1
//                            }
//                        }
//                        .font(.custom("AlmaraiBold", size: 16))
//                        .foregroundColor(.white)
//                        .frame(width: 200, height: 50)
//                        .background(Color(hex: "3182CE"))
//                        .cornerRadius(25)
//                    }
//                }
//                .padding(.horizontal, 20)
//                .padding(.bottom, 40)
//            }
//        }
//        .environment(\.layoutDirection, languageManager.isArabic ? .rightToLeft : .leftToRight)
//    }
//}
//
//// MARK: - Onboarding Page 1
//struct OnboardingPage1: View {
//    @EnvironmentObject var languageManager: LanguageManager
//    
//    var body: some View {
//        VStack(spacing: 20) {
//            Spacer()
//            
//            // Onboarding Illustration
//            Image("onboarding_1") // Add this to Assets.xcassets
//                .resizable()
//                .scaledToFit()
//                .frame(height: 300)
//            
//            Spacer()
//            
//            // Text Content
//            VStack(spacing: 16) {
//                Text("Welcome to Clean GURU")
//                    .font(.custom("AlmaraiBold", size: 24))
//                    .foregroundColor(Color(hex: "2D3748"))
//                    .multilineTextAlignment(.center)
//                    .fixedSize(horizontal: false, vertical: true)
//                
//                Text("Boost your device's performance effortlessly. Manage storage, memory, and system health all in one place.")
//                    .font(.custom("Almarai", size: 14))
//                    .foregroundColor(Color(hex: "718096"))
//                    .multilineTextAlignment(.center)
//                    .lineSpacing(4)
//                    .fixedSize(horizontal: false, vertical: true)
//            }
//            .padding(.horizontal, 30)
//            
//            Spacer()
//        }
//        .environment(\.layoutDirection, languageManager.isArabic ? .rightToLeft : .leftToRight)
//    }
//}
//
//// MARK: - Onboarding Page 2
//struct OnboardingPage2: View {
//    @EnvironmentObject var languageManager: LanguageManager
//    
//    var body: some View {
//        VStack(spacing: 20) {
//            Spacer()
//            
//            // Onboarding Illustration
//            Image("onboarding_2") // Add this to Assets.xcassets
//                .resizable()
//                .scaledToFit()
//                .frame(height: 300)
//            
//            Spacer()
//            
//            // Text Content
//            VStack(spacing: 16) {
//                Text("All-in-One Optimization Tools")
//                    .font(.custom("AlmaraiBold", size: 24))
//                    .foregroundColor(Color(hex: "2D3748"))
//                    .multilineTextAlignment(.center)
//                    .fixedSize(horizontal: false, vertical: true)
//                
//                Text("Identify & clean up duplicate or large files. Enhance speed by freeing up RAM. Monitor & optimize your device's performance.")
//                    .font(.custom("Almarai", size: 14))
//                    .foregroundColor(Color(hex: "718096"))
//                    .multilineTextAlignment(.center)
//                    .lineSpacing(4)
//                    .fixedSize(horizontal: false, vertical: true)
//            }
//            .padding(.horizontal, 30)
//            
//            Spacer()
//        }
//        .environment(\.layoutDirection, languageManager.isArabic ? .rightToLeft : .leftToRight)
//    }
//}
//
//// MARK: - Onboarding Page 3
//struct OnboardingPage3: View {
//    @EnvironmentObject var languageManager: LanguageManager
//    
//    var body: some View {
//        VStack(spacing: 20) {
//            Spacer()
//            
//            // Onboarding Illustration
//            Image("onboarding_3") // Add this to Assets.xcassets
//                .resizable()
//                .scaledToFit()
//                .frame(height: 300)
//            
//            Spacer()
//            
//            // Text Content
//            VStack(spacing: 16) {
//                Text("Your Device, Your Control")
//                    .font(.custom("AlmaraiBold", size: 24))
//                    .foregroundColor(Color(hex: "2D3748"))
//                    .multilineTextAlignment(.center)
//                    .fixedSize(horizontal: false, vertical: true)
//                
//                Text("Take control of your device's health today. Optimize in one tap for a faster, cleaner experience!")
//                    .font(.custom("Almarai", size: 14))
//                    .foregroundColor(Color(hex: "718096"))
//                    .multilineTextAlignment(.center)
//                    .lineSpacing(4)
//                    .fixedSize(horizontal: false, vertical: true)
//            }
//            .padding(.horizontal, 30)
//            
//            Spacer()
//        }
//        .environment(\.layoutDirection, languageManager.isArabic ? .rightToLeft : .leftToRight)
//    }
//}
//
//// MARK: - Extensions
//extension Bundle {
//    var icon: UIImage? {
//        if let icons = infoDictionary?["CFBundleIcons"] as? [String: Any],
//           let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any],
//           let iconFiles = primaryIcon["CFBundleIconFiles"] as? [String],
//           let lastIcon = iconFiles.last {
//            return UIImage(named: lastIcon)
//        }
//        return nil
//    }
//}

struct OnboardingView: View {
    @Binding var showOnboarding: Bool
    @EnvironmentObject var languageManager: LanguageManager
    @State private var currentPage = 0
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(hex: "D6E8F5"), Color.white]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack {
                // Skip Button
                HStack {
                    Spacer()
                    Button(LocalizedStrings.string(for: "skip", language: languageManager.currentLanguage)) {
                        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
                        showOnboarding = false
                    }
                    .font(.custom("Almarai", size: 16))
                    .foregroundColor(Color(hex: "718096"))
                    .padding(.trailing, 20)
                    .padding(.top, 10)
                }
                
                // Page View
                TabView(selection: $currentPage) {
                    OnboardingPage1()
                        .environmentObject(languageManager)
                        .tag(0)
                    OnboardingPage2()
                        .environmentObject(languageManager)
                        .tag(1)
                    OnboardingPage3()
                        .environmentObject(languageManager)
                        .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                // Page Indicators
                HStack(spacing: 8) {
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(index == currentPage ? Color(hex: "2C5282") : Color(hex: "CBD5E0"))
                            .frame(width: 8, height: 8)
                    }
                }
                .padding(.bottom, 30)
                
                // Navigation Buttons
                HStack(spacing: 16) {
                    if currentPage > 0 {
                        Button(LocalizedStrings.string(for: "back", language: languageManager.currentLanguage)) {
                            withAnimation {
                                currentPage -= 1
                            }
                        }
                        .font(.custom("Almarai", size: 16))
                        .foregroundColor(Color(hex: "3182CE"))
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.white)
                        .cornerRadius(25)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color(hex: "3182CE"), lineWidth: 1)
                        )
                        
                        Button(currentPage == 2 ? LocalizedStrings.string(for: "get_started", language: languageManager.currentLanguage) : LocalizedStrings.string(for: "next", language: languageManager.currentLanguage)) {
                            if currentPage == 2 {
                                UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
                                showOnboarding = false
                            } else {
                                withAnimation {
                                    currentPage += 1
                                }
                            }
                        }
                        .font(.custom("AlmaraiBold", size: 16))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color(hex: "3182CE"))
                        .cornerRadius(25)
                    } else {
                        // First page - only Next button, centered
                        Button(LocalizedStrings.string(for: "next", language: languageManager.currentLanguage)) {
                            withAnimation {
                                currentPage += 1
                            }
                        }
                        .font(.custom("AlmaraiBold", size: 16))
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .background(Color(hex: "3182CE"))
                        .cornerRadius(25)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
        }
        .environment(\.layoutDirection, languageManager.isArabic ? .rightToLeft : .leftToRight)
    }
}

// MARK: - Onboarding Page 1
struct OnboardingPage1: View {
    @EnvironmentObject var languageManager: LanguageManager
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            // Onboarding Illustration
            Image("onboarding_1") // Add this to Assets.xcassets
                .resizable()
                .scaledToFit()
                .frame(height: 300)
            
            Spacer()
            
            // Text Content
            VStack(spacing: 16) {
                LocalizedText("onboarding_welcome_title")
                    .font(.custom("AlmaraiBold", size: 24))
                    .foregroundColor(Color(hex: "2D3748"))
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                
                LocalizedText("onboarding_welcome_subtitle")
                    .font(.custom("Almarai", size: 14))
                    .foregroundColor(Color(hex: "718096"))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal, 30)
            
            Spacer()
        }
        .environment(\.layoutDirection, languageManager.isArabic ? .rightToLeft : .leftToRight)
    }
}

// MARK: - Onboarding Page 2
struct OnboardingPage2: View {
    @EnvironmentObject var languageManager: LanguageManager
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            // Onboarding Illustration
            Image("onboarding_2") // Add this to Assets.xcassets
                .resizable()
                .scaledToFit()
                .frame(height: 300)
            
            Spacer()
            
            // Text Content
            VStack(spacing: 16) {
                LocalizedText("onboarding_tools_title")
                    .font(.custom("AlmaraiBold", size: 24))
                    .foregroundColor(Color(hex: "2D3748"))
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                
                LocalizedText("onboarding_tools_subtitle")
                    .font(.custom("Almarai", size: 14))
                    .foregroundColor(Color(hex: "718096"))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal, 30)
            
            Spacer()
        }
        .environment(\.layoutDirection, languageManager.isArabic ? .rightToLeft : .leftToRight)
    }
}

// MARK: - Onboarding Page 3
struct OnboardingPage3: View {
    @EnvironmentObject var languageManager: LanguageManager
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            // Onboarding Illustration
            Image("onboarding_3") // Add this to Assets.xcassets
                .resizable()
                .scaledToFit()
                .frame(height: 300)
            
            Spacer()
            
            // Text Content
            VStack(spacing: 16) {
                LocalizedText("onboarding_control_title")
                    .font(.custom("AlmaraiBold", size: 24))
                    .foregroundColor(Color(hex: "2D3748"))
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                
                LocalizedText("onboarding_control_subtitle")
                    .font(.custom("Almarai", size: 14))
                    .foregroundColor(Color(hex: "718096"))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal, 30)
            
            Spacer()
        }
        .environment(\.layoutDirection, languageManager.isArabic ? .rightToLeft : .leftToRight)
    }
}

// MARK: - Extensions
extension Bundle {
    var icon: UIImage? {
        if let icons = infoDictionary?["CFBundleIcons"] as? [String: Any],
           let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any],
           let iconFiles = primaryIcon["CFBundleIconFiles"] as? [String],
           let lastIcon = iconFiles.last {
            return UIImage(named: lastIcon)
        }
        return nil
    }
}
