//
//  onboardingView.swift
//  GHGG
//
//  Created by test on 14/07/2025.
//

import SwiftUI




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
                // Skip Button - Improved clickable area
                HStack {
                    Spacer()
                    Button(action: {
                        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
                        showOnboarding = false
                    }) {
                        Text(LocalizedStrings.string(for: "skip", language: languageManager.currentLanguage))
                            .font(.custom("Almarai", size: 16))
                            .foregroundColor(Color(hex: "718096"))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                    }
                    .contentShape(Rectangle()) // Makes entire button area clickable
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
                
                // Navigation Buttons - Improved with better touch areas
                HStack(spacing: 16) {
                    if currentPage > 0 {
                        // Back Button
                        Button(action: {
                            withAnimation {
                                currentPage -= 1
                            }
                        }) {
                            Text(LocalizedStrings.string(for: "back", language: languageManager.currentLanguage))
                                .font(.custom("Almarai", size: 16))
                                .foregroundColor(Color(hex: "3182CE"))
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.white)
                        .cornerRadius(25)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color(hex: "3182CE"), lineWidth: 1)
                        )
                        .contentShape(RoundedRectangle(cornerRadius: 25)) // Ensures entire button is clickable
                        
                        // Next/Get Started Button
                        Button(action: {
                            if currentPage == 2 {
                                UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
                                showOnboarding = false
                            } else {
                                withAnimation {
                                    currentPage += 1
                                }
                            }
                        }) {
                            Text(currentPage == 2 ?
                                 LocalizedStrings.string(for: "get_started", language: languageManager.currentLanguage) :
                                 LocalizedStrings.string(for: "next", language: languageManager.currentLanguage))
                                .font(.custom("AlmaraiBold", size: 16))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color(hex: "3182CE"))
                        .cornerRadius(25)
                        .contentShape(RoundedRectangle(cornerRadius: 25)) // Ensures entire button is clickable
                    } else {
                        // First page - only Next button, centered
                        Button(action: {
                            withAnimation {
                                currentPage += 1
                            }
                        }) {
                            Text(LocalizedStrings.string(for: "next", language: languageManager.currentLanguage))
                                .font(.custom("AlmaraiBold", size: 16))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                        .frame(width: 200, height: 50)
                        .background(Color(hex: "3182CE"))
                        .cornerRadius(25)
                        .contentShape(RoundedRectangle(cornerRadius: 25)) // Ensures entire button is clickable
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
