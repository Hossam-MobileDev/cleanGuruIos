//
//  settingsView.swift
//  GHGG
//
//  Created by test on 11/05/2025.
//

import Foundation
import SwiftUI



//struct SettinappView: View {
//    @Binding var togglefullscreen: Bool
//        @Environment(\.openURL) var openURL
//        @EnvironmentObject var languageManager: LanguageManager // Changed from @StateObject to @EnvironmentObject
//        @State private var selectedLanguage = "English"
//    
//    private let supportEmail = "support@3rabapp.com"
//    
//    private let currentAppId = "6743487109" // Replace with your app's actual ID
//
//
//    
//    private func sendEmail() {
//        let supportEmail = "support@3rabapp.com"
//        let subject = "I have a probleme Clean Guru"
//        let systemVersion = UIDevice.current.systemVersion
//        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
//
//        let body = """
//        Hello There
//        Details of the problem:
//
//        System version: \(systemVersion)
//        App version : \(appVersion)
//        """
//
//        let encodedSubject = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
//        let encodedBody = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
//
//        if let emailURL = URL(string: "mailto:\(supportEmail)?subject=\(encodedSubject)&body=\(encodedBody)") {
//            UIApplication.shared.open(emailURL)
//        }
//    }
//    
//    private let colors = SettingsColors(
//        background: .white,
//        cardBackground: Color(hex: "F5F5F5"),
//        accent: Color(hex: "007AFF"),
//        divider: Color(hex: "E0E0E0"),
//        text: .black,
//        secondaryText: Color.black.opacity(0.6)
//    )
//    
//    var body: some View {
//        ScrollView {
//            VStack(spacing: 10) {
//                // Header with close button
//                HStack {
//                  
//                }
//                
//                // Title
//                LocalizedText("main_settings")
//                    .font(.custom("System", size: 24))
//                    .foregroundColor(colors.text)
//                    .frame(maxWidth: .infinity, alignment: .center)
//                    .padding(.vertical, 8)
//                
//                // In App Section
//                SectionView(title: LocalizedStrings.string(for: "in_app", language: languageManager.currentLanguage)) {
//                    VStack(spacing: 0) {
//                        LanguageButton(
//                            selectedLanguage: $selectedLanguage,
//                            colors: colors,
//                            languageManager: languageManager
//                        )
//                    }
//                    .padding(.vertical, 8)
//                }
//                
//                // Feedback Section
//                SectionView(title: LocalizedStrings.string(for: "help_us_improve", language: languageManager.currentLanguage)) {
//                    VStack(spacing: 12) {
//                        FeedbackButton(
//                            icon: "star.fill",
//                            text: LocalizedStrings.string(for: "rate_our_app", language: languageManager.currentLanguage),
//                            iconColor: Color(hex: "FFD700"),
//                            action: rateApp
//                        )
//                        DividerLine(color: colors.divider)
//                        
//                        FeedbackButton(
//                            icon: "envelope.fill",
//                            text: LocalizedStrings.string(for: "have a problem? contact us", language: languageManager.currentLanguage),
//                            iconColor: Color(hex: "4CD964"),
//                            action: sendEmail
//                        )
//                        DividerLine(color: colors.divider)
//                        
////                        FeedbackButton(
////                            icon: "exclamationmark.triangle.fill",
////                            text: LocalizedStrings.string(for: "having_issues", language: languageManager.currentLanguage),
////                            iconColor: Color(hex: "FF9500"),
////                            action: sendEmail
////                        )
////                        DividerLine(color: colors.divider)
////                        
////                        FeedbackButton(
////                            icon: "heart.slash.fill",
////                            text: LocalizedStrings.string(for: "not_enjoying_app", language: languageManager.currentLanguage),
////                            iconColor: Color(hex: "FF3B30"),
////                            action: sendEmail
////                        )
//                        DividerLine(color: colors.divider)
//                        
//                        FeedbackButton(
//                            icon: "square.and.arrow.up",
//                            text: LocalizedStrings.string(for: "share_app_with_friends", language: languageManager.currentLanguage),
//                            iconColor: Color(hex: "007AFF"),
//                            action: shareApp
//                        )
//                    }
//                    .padding(.vertical, 8)
//                }
//                
//                // Our Apps Section
//                SectionView(title: LocalizedStrings.string(for: "check_our_apps", language: languageManager.currentLanguage)) {
//                    VStack(spacing: 16) {
//                        AppListItem(
//                            title: LocalizedStrings.string(for: "muslim_qibla", language: languageManager.currentLanguage),
//                            subtitle: LocalizedStrings.string(for: "muslim_qibla_desc", language: languageManager.currentLanguage),
//                            iconName: "qibla",
//                            appId: "id6736939515",
//                            colors: colors
//                        )
////                        AppListItem(
////                            title: "Muslim Qibla",
////                            subtitle: "Accurate Qibla Direction",
////                            iconName: "qibla",
////                            appId: "id6736939515",
////                            colors: colors
////                        )
//                        AppListItem(
//                            title: LocalizedStrings.string(for: "speedtest", language: languageManager.currentLanguage),
//                            subtitle: LocalizedStrings.string(for: "speedtest_desc", language: languageManager.currentLanguage),
//                            iconName: "speedtest",
//                            appId: "id1635139320",
//                            colors: colors
//                        )
//                        
//                        AppListItem(
//                            title: LocalizedStrings.string(for: "product_finder", language: languageManager.currentLanguage),
//                            subtitle: LocalizedStrings.string(for: "product_finder_desc", language: languageManager.currentLanguage),
//                            iconName: "finder",
//                            appId: "id6737802621",
//                            colors: colors
//                        )
//                        
//                        AppListItem(
//                            title: LocalizedStrings.string(for: "kitaba", language: languageManager.currentLanguage),
//                            subtitle: LocalizedStrings.string(for: "kitaba_desc", language: languageManager.currentLanguage),
//                            iconName: "kitaba",
//                            appId: "id958075714",
//                            colors: colors
//                        )
//                        AppListItem(
//                            title: LocalizedStrings.string(for: "currency_converter", language: languageManager.currentLanguage),
//                            subtitle: LocalizedStrings.string(for: "currency_converter_desc", language: languageManager.currentLanguage),
//                            iconName: "currency",
//                            appId: "id1492580244",
//                            colors: colors
//                        )
//                        
//                        AppListItem(
//                            title: LocalizedStrings.string(for: "zakhrafa", language: languageManager.currentLanguage),
//                            subtitle: LocalizedStrings.string(for: "zakhrafa_desc", language: languageManager.currentLanguage),
//                            iconName: "zaghrafalogo",
//                            appId: "id6476085334",
//                            colors: colors
//                        )
//                        
//                        AppListItem(
//                            title: LocalizedStrings.string(for: "steps", language: languageManager.currentLanguage),
//                            subtitle: LocalizedStrings.string(for: "steps_desc", language: languageManager.currentLanguage),
//                            iconName: "zatawaty",
//                            appId: "id6502876950",
//                            colors: colors
//                        )
//                    }
//                }
//                
//                // Footer Links
//                HStack(spacing: 16) {
//                    FooterLink(
//                        title: LocalizedStrings.string(for: "terms_of_use", language: languageManager.currentLanguage),
//                        url: "https://3rabapp.com/legal/term_of_use.html"
//                    )
//                    Text("|").foregroundColor(colors.secondaryText)
//                    FooterLink(
//                        title: LocalizedStrings.string(for: "privacy_policy", language: languageManager.currentLanguage),
//                        url: "https://3rabapp.com/legal/privacy_policy.html"
//                    )
//                }
//                .padding(.top, 32)
//                .padding(.bottom, 16)
//            }
//            .padding(.horizontal)
//        }
//        .background(colors.background.ignoresSafeArea())
//        .environment(\.layoutDirection, languageManager.isArabic ? .rightToLeft : .leftToRight)
//        .onAppear {
//            selectedLanguage = languageManager.currentLanguage
//        }
//    }
//    
//    private func rateApp() {
//           // Option 1: Direct App Store review URL (Recommended)
//           if let writeReviewURL = URL(string: "itms-apps://itunes.apple.com/app/\(currentAppId)?action=write-review") {
//               openURL(writeReviewURL)
//           }
//       }
//    
////    private func sendEmail() {
////        guard let emailURL = URL(string: "mailto:\(supportEmail)") else { return }
////        openURL(emailURL)
////    }
//    
//    private func shareApp() {
//        let appURL = "https://apps.apple.com/app/id\(currentAppId)"
//        
//        let activityVC = UIActivityViewController(
//            activityItems: [appURL],
//            applicationActivities: nil
//        )
//        
//        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//           let window = windowScene.windows.first,
//           let rootVC = window.rootViewController {
//            rootVC.present(activityVC, animated: true)
//        }
//    }
//}
//
//// Updated Language Button Component
//struct LanguageButton: View {
//    @Binding var selectedLanguage: String
//    @State private var showLanguageSheet = false
//    let colors: SettingsColors
//    let languageManager: LanguageManager
//    
//    private let availableLanguages = ["English", "العربية"]
//    
//    var body: some View {
//        Button(action: {
//            showLanguageSheet = true
//        }) {
//            HStack(spacing: 12) {
//                Image(systemName: "globe")
//                    .foregroundColor(Color(hex: "007AFF"))
//                    .font(.system(size: 20))
//                
//                Text(LocalizedStrings.string(for: "language", language: languageManager.currentLanguage))
//                    .font(.custom("AlmaraiBold", size: 15))
//                
//                Spacer()
//                
//                Text(selectedLanguage)
//                    .font(.custom("Almarai", size: 14))
//                    .foregroundColor(colors.secondaryText)
//                
//                // RTL-aware chevron direction
//                Image(systemName: languageManager.isArabic ? "chevron.left" : "chevron.right")
//                    .font(.system(size: 14, weight: .semibold))
//                    .foregroundColor(Color(hex: "787880"))
//            }
//            .foregroundColor(.black)
//            .padding(.horizontal, 16)
//            .padding(.vertical, 12)
//            .background(Color(hex: "F5F5F5"))
//            .cornerRadius(10)
//        }
//        .buttonStyle(ScaleButtonStyle())
//        .padding(.horizontal)
//        .sheet(isPresented: $showLanguageSheet) {
//            LanguageSelectionSheet(
//                selectedLanguage: $selectedLanguage,
//                availableLanguages: availableLanguages,
//                colors: colors,
//                languageManager: languageManager
//            )
//        }
//    }
//}
//
//
//// Updated Language Selection Sheet
//struct LanguageSelectionSheet: View {
//    @Binding var selectedLanguage: String
//    @Environment(\.dismiss) var dismiss
//    let availableLanguages: [String]
//    let colors: SettingsColors
//    let languageManager: LanguageManager
//    
//    var body: some View {
//        NavigationView {
//            List {
//                ForEach(availableLanguages, id: \.self) { language in
//                    HStack {
//                        Text(language)
//                            .font(.custom("Almarai", size: 16))
//                            .foregroundColor(colors.text)
//                        
//                        Spacer()
//                        
//                        if selectedLanguage == language {
//                            Image(systemName: "checkmark")
//                                .foregroundColor(colors.accent)
//                                .font(.system(size: 16, weight: .semibold))
//                        }
//                    }
//                    .contentShape(Rectangle())
//                    .onTapGesture {
//                        selectedLanguage = language
//                        languageManager.setLanguage(language)
//                        dismiss()
//                    }
//                    .listRowBackground(colors.background)
//                }
//            }
//            .listStyle(PlainListStyle())
//            .navigationTitle(LocalizedStrings.string(for: "language", language: languageManager.currentLanguage))
//            .navigationBarTitleDisplayMode(.inline)
//            .navigationBarItems(
//                trailing: Button(LocalizedStrings.string(for: "done", language: languageManager.currentLanguage)) {
//                    dismiss()
//                }
//                .foregroundColor(colors.accent)
//            )
//        }
//        .presentationDetents([.medium])
//        .environment(\.layoutDirection, languageManager.isArabic ? .rightToLeft : .leftToRight)
//    }
//}
//
//// Keep all other existing components (SettingsColors, SectionView, FeedbackButton, etc.)
//// but add language support where needed...
//
//struct SettingsColors {
//    let background: Color
//    let cardBackground: Color
//    let accent: Color
//    let divider: Color
//    let text: Color
//    let secondaryText: Color
//}
//
//struct SectionView<Content: View>: View {
//    let title: String
//    let content: Content
//    
//    init(title: String, @ViewBuilder content: () -> Content) {
//        self.title = title
//        self.content = content()
//    }
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 16) {
//            Text(title)
//                .font(.custom("AlmaraiBold", size: 17))
//                .foregroundColor(.black)
//                .frame(maxWidth: .infinity, alignment: .leading)
//            
//            content
//                .background(Color(hex: "F5F5F5"))
//                .cornerRadius(12)
//        }
//    }
//}
//
//struct FeedbackButton: View {
//    let icon: String
//    let text: String
//    let iconColor: Color
//    let action: () -> Void
//    @EnvironmentObject var languageManager: LanguageManager // Add this line
//    
//    var body: some View {
//        Button(action: action) {
//            HStack(spacing: 12) {
//                Image(systemName: icon)
//                    .foregroundColor(iconColor)
//                    .font(.system(size: 20))
//                
//                Text(text)
//                    .font(.custom("AlmaraiBold", size: 15))
//                
//                Spacer()
//                
//                // RTL-aware chevron direction
//                Image(systemName: languageManager.isArabic ? "chevron.left" : "chevron.right")
//                    .font(.system(size: 14, weight: .semibold))
//                    .foregroundColor(Color(hex: "787880"))
//            }
//            .foregroundColor(.black)
//            .padding(.horizontal, 16)
//            .padding(.vertical, 12)
//            .background(Color(hex: "F5F5F5"))
//            .cornerRadius(10)
//        }
//        .buttonStyle(ScaleButtonStyle())
//        .padding(.horizontal)
//    }
//}
//
//struct AppListItem: View {
//   let title: String
//   let subtitle: String
//   let iconName: String
//   let appId: String
//   let colors: SettingsColors
//   @Environment(\.openURL) var openURL
//   
//   var body: some View {
//       HStack(spacing: 16) {
//           // App icon
//           Image(iconName)
//               .resizable()
//               .scaledToFit()
//               .frame(width: 48, height: 48)
//               .cornerRadius(10)
//               .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
//           
//           // App details
//           VStack(alignment: .leading, spacing: 4) {
//               Text(title)
//                   .font(.custom("AlmaraiBold", size: 15))
//                   .foregroundColor(.black)
//               
//               Text(subtitle)
//                   .font(.custom("Almarai", size: 13))
//                   .foregroundColor(.black.opacity(0.6))
//           }
//           
//           Spacer()
//           
//           // Get button
//           Button {
//               let appURLs = [
//                   "Muslim Qibla": "https://apps.apple.com/bj/app/muslim-%D8%A7%D8%AA%D8%AC%D8%A7%D9%87-%D8%A7%D9%84%D9%82%D8%A8%D9%84%D9%87-%D8%A7%D9%84%D8%AF%D9%82%D9%8A%D9%82/id6736939515",
//                   "Speedtest": "https://apps.apple.com/bj/app/speedtest-%D8%B3%D8%B1%D8%B9%D8%A9-%D8%A7%D9%84%D9%86%D8%AA/id1635139320",
//                   "Product Finder": "https://apps.apple.com/bj/app/product-finder-price-compare/id6737802621",
//                   "Kitaba": "https://apps.apple.com/us/app/%D9%83%D8%AA%D8%A7%D8%A8%D8%A9-%D8%B9%D9%84%D9%89-%D8%A7%D9%84%D8%B5%D9%88%D8%B1-%D8%AA%D8%B5%D9%85%D9%8A%D9%85-%D8%B5%D9%88%D8%B1/id958075714",
//                   "Currency Converter": "https://apps.apple.com/us/app/currency-currency-converter/id1492580244",
//                   "Zakhrafa": "https://apps.apple.com/eg/app/%D8%B2%D8%AE%D8%B1%D9%81%D8%A9-%D8%B2%D8%AE%D8%B1%D9%81%D8%A9-%D9%83%D8%AA%D8%A7%D8%A8%D9%87/id6476085334",
//                   "Steps": "https://apps.apple.com/us/app/%D8%AE%D8%B7%D9%88%D8%A7%D8%AA/id6502876950"
//               ]
//               
//               if let url = URL(string: appURLs[title] ?? "https://apps.apple.com/app/\(appId)") {
//                   openURL(url)
//               }
//           } label: {
//               LocalizedText("get")
//                   .fontWeight(.medium)
//                   .font(.system(size: 14))
//                   .foregroundColor(.white)
//                   .frame(width: 70, height: 32)
//                   .background(Color.blue)
//                   .cornerRadius(16)
//           }
//       }
//       .padding(.horizontal, 16)
//       .padding(.vertical, 12)
//       .background(colors.cardBackground)
//       .cornerRadius(12)
//   }
//}
//
//struct FooterLink: View {
//    let title: String
//    let url: String
//    @Environment(\.openURL) var openURL
//    
//    var body: some View {
//        Button(title) {
//            openURL(URL(string: url)!)
//        }
//        .font(.custom("Almarai", size: 14))
//        .foregroundColor(.black)
//    }
//}
//
//struct DividerLine: View {
//    let color: Color
//    
//    var body: some View {
//        color
//            .frame(height: 1)
//            .opacity(0.2)
//    }
//}
//
//struct ScaleButtonStyle: ButtonStyle {
//    func makeBody(configuration: Configuration) -> some View {
//        configuration.label
//            .scaleEffect(configuration.isPressed ? 0.98 : 1)
//            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
//    }
//}
//
//extension Color {
//    init(hex: String) {
//        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
//        var int: UInt64 = 0
//        Scanner(string: hex).scanHexInt64(&int)
//        let a, r, g, b: UInt64
//        switch hex.count {
//        case 3: (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
//        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
//        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
//        default: (a, r, g, b) = (255, 0, 0, 0)
//        }
//        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
//    }
//}

//struct SettingsView: View {
//    @Binding var togglefullscreen: Bool
//    @Environment(\.openURL) var openURL
//    @EnvironmentObject var languageManager: LanguageManager
//    @State private var selectedLanguage = "English"
//    @State private var showLanguageSheet = false
//    @State private var allowNotifications = true
//    
//    private let supportEmail = "support@3rabapp.com"
//    private let currentAppId = "6743487109"
//    
//    var body: some View {
//        NavigationView {
//            VStack(spacing: 0) {
//                // Navigation Bar
//                HStack {
//                    Button(action: {
//                        // Handle back action - you can add your navigation logic here
//                        togglefullscreen = false
//                    }) {
//                        Image(systemName: "chevron.left")
//                            .font(.system(size: 20))
//                            .foregroundColor(.blue)
//                    }
//                    
//                    Spacer()
//                    
//                    LocalizedText("main_settings")
//                        .font(.system(size: 20, weight: .semibold))
//                    
//                    Spacer()
//                    
//                    // Empty space for balance
//                    Color.clear
//                        .frame(width: 24, height: 24)
//                }
//                .padding(.horizontal)
//                .padding(.vertical, 12)
//                
//                ScrollView {
//                    VStack(alignment: .leading, spacing: 24) {
//                        // In app section
//                        Text(LocalizedStrings.string(for: "in_app", language: languageManager.currentLanguage))
//                            .font(.system(size: 14))
//                            .foregroundColor(.gray)
//                            .padding(.horizontal)
//                            .padding(.top, 10)
//                        
//                        VStack(spacing: 0) {
//                            // Language
//                            SettingRow(
//                                icon: "language",
//                                title: LocalizedStrings.string(for: "language", language: languageManager.currentLanguage),
//                                value: selectedLanguage,
//                                showChevron: false,
//                                action: {
//                                    showLanguageSheet = true
//                                }
//                            )
//                            
//                            Divider()
//                                //.padding(.leading, 76)
//                            
//                            // Rate us
//                            SettingRow(
//                                icon: "rate",
//                                title: LocalizedStrings.string(for: "rate_our_app", language: languageManager.currentLanguage),
//                                showChevron: true,
//                                action: rateApp
//                            )
//                            
//                            Divider()
//                              //  .padding(.leading, 60)
//                            
//                            // Have a problem? contact us
//                            SettingRow(
//                                icon: "problem",
//                                title: LocalizedStrings.string(for: "have a problem? contact us", language: languageManager.currentLanguage),
//                                showChevron: true,
//                                action: sendEmail
//                            )
//                            
//                            Divider()
//                               // .padding(.leading, 60)
//                            
//                            // Allow Notifications
//                            HStack(spacing: 16) {
//                                Image("notification")
//                                    .resizable()
//                                    .scaledToFit()
//                                    .frame(width: 40, height: 40)
//                                    .foregroundColor(.blue)
//                                
//                                Text("Allow Notifications")
//                                    .font(.system(size: 16))
//                                    .foregroundColor(.black)
//                                
//                                Spacer()
//                                
//                                Toggle("", isOn: $allowNotifications)
//                                    .labelsHidden()
//                                    .tint(.green)
//                            }
//                            .padding(.horizontal)
//                            .padding(.vertical, 12)
//                            
//                            Divider()
//                                //.padding(.leading, 60)
//                            
//                            // Share with friends
//                            SettingRow(
//                                icon: "share",
//                                title: LocalizedStrings.string(for: "share_app_with_friends", language: languageManager.currentLanguage),
//                                showChevron: false,
//                                showShareIcon: true,
//                                action: shareApp
//                            )
//                        }
//                        .background(Color.white)
//                        .cornerRadius(12)
//                        .padding(.horizontal)
//                        
//                        // Check out apps on app store
//                        Text(LocalizedStrings.string(for: "check_our_apps", language: languageManager.currentLanguage))
//                            .font(.system(size: 14))
//                            .foregroundColor(.gray)
//                            .padding(.horizontal)
//                            .padding(.top, 8)
//                        
//                        VStack(spacing: 12) {
//                            AppRow(
//                                iconName: "qibla",
//                                title: LocalizedStrings.string(for: "muslim_qibla", language: languageManager.currentLanguage),
//                                subtitle: LocalizedStrings.string(for: "muslim_qibla_desc", language: languageManager.currentLanguage),
//                                appId: "id6736939515",
//                                appStoreUrl: "https://apps.apple.com/bj/app/muslim-%D8%A7%D8%AA%D8%AC%D8%A7%D9%87-%D8%A7%D9%84%D9%82%D8%A8%D9%84%D9%87-%D8%A7%D9%84%D8%AF%D9%82%D9%8A%D9%82/id6736939515"
//                            )
//                            
//                            AppRow(
//                                iconName: "speedtest",
//                                title: LocalizedStrings.string(for: "speedtest", language: languageManager.currentLanguage),
//                                subtitle: LocalizedStrings.string(for: "speedtest_desc", language: languageManager.currentLanguage),
//                                appId: "id1635139320",
//                                appStoreUrl: "https://apps.apple.com/bj/app/speedtest-%D8%B3%D8%B1%D8%B9%D8%A9-%D8%A7%D9%84%D9%86%D8%AA/id1635139320"
//                            )
//                            
//                            AppRow(
//                                iconName: "finder",
//                                title: LocalizedStrings.string(for: "product_finder", language: languageManager.currentLanguage),
//                                subtitle: LocalizedStrings.string(for: "product_finder_desc", language: languageManager.currentLanguage),
//                                appId: "id6737802621",
//                                appStoreUrl: "https://apps.apple.com/bj/app/product-finder-price-compare/id6737802621"
//                            )
//                            
//                            AppRow(
//                                iconName: "kitaba",
//                                title: LocalizedStrings.string(for: "kitaba", language: languageManager.currentLanguage),
//                                subtitle: LocalizedStrings.string(for: "kitaba_desc", language: languageManager.currentLanguage),
//                                appId: "id958075714",
//                                appStoreUrl: "https://apps.apple.com/us/app/%D9%83%D8%AA%D8%A7%D8%A8%D8%A9-%D8%B9%D9%84%D9%89-%D8%A7%D9%84%D8%B5%D9%88%D8%B1-%D8%AA%D8%B5%D9%85%D9%8A%D9%85-%D8%B5%D9%88%D8%B1/id958075714"
//                            )
//                            
//                            AppRow(
//                                iconName: "currency",
//                                title: LocalizedStrings.string(for: "currency_converter", language: languageManager.currentLanguage),
//                                subtitle: LocalizedStrings.string(for: "currency_converter_desc", language: languageManager.currentLanguage),
//                                appId: "id1492580244",
//                                appStoreUrl: "https://apps.apple.com/us/app/currency-currency-converter/id1492580244"
//                            )
//                            
//                            AppRow(
//                                iconName: "zaghrafalogo",
//                                title: LocalizedStrings.string(for: "zakhrafa", language: languageManager.currentLanguage),
//                                subtitle: LocalizedStrings.string(for: "zakhrafa_desc", language: languageManager.currentLanguage),
//                                appId: "id6476085334",
//                                appStoreUrl: "https://apps.apple.com/eg/app/%D8%B2%D8%AE%D8%B1%D9%81%D8%A9-%D8%B2%D8%AE%D8%B1%D9%81%D8%A9-%D9%83%D8%AA%D8%A7%D8%A8%D9%87/id6476085334"
//                            )
//                            
//                            AppRow(
//                                iconName: "zatawaty",
//                                title: LocalizedStrings.string(for: "steps", language: languageManager.currentLanguage),
//                                subtitle: LocalizedStrings.string(for: "steps_desc", language: languageManager.currentLanguage),
//                                appId: "id6502876950",
//                                appStoreUrl: "https://apps.apple.com/us/app/%D8%AE%D8%B7%D9%88%D8%A7%D8%AA/id6502876950"
//                            )
//                        }
//                        .padding(.horizontal)
//                        
//                        // Footer Links
//                        HStack(spacing: 16) {
//                            FooterLink(
//                                title: LocalizedStrings.string(for: "terms_of_use", language: languageManager.currentLanguage),
//                                url: "https://3rabapp.com/legal/term_of_use.html"
//                            )
//                            Text("|").foregroundColor(.gray)
//                            FooterLink(
//                                title: LocalizedStrings.string(for: "privacy_policy", language: languageManager.currentLanguage),
//                                url: "https://3rabapp.com/legal/privacy_policy.html"
//                            )
//                        }
//                        .padding(.top, 32)
//                        .padding(.bottom, 100)
//                    }
//                }
//                .background(Color(UIColor.systemGray6))
//            }
//            .navigationBarHidden(true)
//            .sheet(isPresented: $showLanguageSheet) {
//                LanguageSelectionSheet(
//                    selectedLanguage: $selectedLanguage,
//                    languageManager: languageManager
//                )
//            }
//        }
//        .environment(\.layoutDirection, languageManager.isArabic ? .rightToLeft : .leftToRight)
//        .onAppear {
//            selectedLanguage = languageManager.currentLanguage
//        }
//    }
//    
//    private func rateApp() {
//        if let writeReviewURL = URL(string: "itms-apps://itunes.apple.com/app/\(currentAppId)?action=write-review") {
//            openURL(writeReviewURL)
//        }
//    }
//    
//    private func sendEmail() {
//        let subject = "I have a probleme Clean Guru"
//        let systemVersion = UIDevice.current.systemVersion
//        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
//        
//        let body = """
//        Hello There
//        Details of the problem:
//        
//        System version: \(systemVersion)
//        App version : \(appVersion)
//        """
//        
//        let encodedSubject = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
//        let encodedBody = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
//        
//        if let emailURL = URL(string: "mailto:\(supportEmail)?subject=\(encodedSubject)&body=\(encodedBody)") {
//            UIApplication.shared.open(emailURL)
//        }
//    }
//    
//    private func shareApp() {
//        let appURL = "https://apps.apple.com/app/id\(currentAppId)"
//        
//        let activityVC = UIActivityViewController(
//            activityItems: [appURL],
//            applicationActivities: nil
//        )
//        
//        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//           let window = windowScene.windows.first,
//           let rootVC = window.rootViewController {
//            rootVC.present(activityVC, animated: true)
//        }
//    }
//}
//
//struct SettingRow: View {
//    let icon: String
//    let title: String
//    var value: String? = nil
//    var showChevron: Bool = false
//    var showShareIcon: Bool = false
//    let action: () -> Void
//    @EnvironmentObject var languageManager: LanguageManager
//    
//    var body: some View {
//        Button(action: action) {
//            HStack(spacing: 16) {
//                Image(icon)
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 40, height: 40)
//                    .foregroundColor(.blue)
//                
//                Text(title)
//                    .font(.system(size: 16))
//                    .foregroundColor(.black)
//                
//                Spacer()
//                
//                if let value = value {
//                    Text(value)
//                        .font(.system(size: 15))
//                        .foregroundColor(.gray)
//                }
//                
//                if showChevron {
//                    Image(systemName: languageManager.isArabic ? "chevron.left" : "chevron.right")
//                        .font(.system(size: 14))
//                        .foregroundColor(.gray)
//                }
//                
//                if showShareIcon {
//                    Image(systemName: "square.and.arrow.up")
//                        .font(.system(size: 18))
//                        .foregroundColor(.blue)
//                }
//            }
//            .padding(.horizontal)
//            .padding(.vertical, 12)
//        }
//    }
//}
//
//struct AppRow: View {
//    let iconName: String
//    let title: String
//    let subtitle: String
//    let appId: String
//    let appStoreUrl: String
//    @Environment(\.openURL) var openURL
//    
//    var body: some View {
//        HStack(spacing: 12) {
//            Image(iconName)
//                .resizable()
//                .scaledToFit()
//                .frame(width: 50, height: 50)
//                .cornerRadius(12)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 12)
//                        .stroke(Color.gray.opacity(0.2), lineWidth: 0.5)
//                )
//            
//            VStack(alignment: .leading, spacing: 2) {
//                Text(title)
//                    .font(.system(size: 16, weight: .medium))
//                    .foregroundColor(.black)
//                
//                Text(subtitle)
//                    .font(.system(size: 13))
//                    .foregroundColor(.gray)
//                    .lineLimit(1)
//            }
//            
//            Spacer()
//            
//            Button(action: {
//                if let url = URL(string: appStoreUrl) {
//                    openURL(url)
//                }
//            }) {
//                LocalizedText("get")
//                    .font(.system(size: 15, weight: .semibold))
//                    .foregroundColor(.white)
//                    .padding(.horizontal, 20)
//                    .padding(.vertical, 6)
//                    .background(Color.blue)
//                    .cornerRadius(16)
//            }
//        }
//        .padding(.horizontal)
//        .padding(.vertical, 8)
//        .background(Color.white)
//        .cornerRadius(12)
//    }
//}
//
//struct LanguageSelectionSheet: View {
//    @Binding var selectedLanguage: String
//    @Environment(\.dismiss) var dismiss
//    let languageManager: LanguageManager
//    
//    private let availableLanguages = ["English", "العربية"]
//    
//    var body: some View {
//        NavigationView {
//            List {
//                ForEach(availableLanguages, id: \.self) { language in
//                    HStack {
//                        Text(language)
//                            .font(.system(size: 16))
//                        
//                        Spacer()
//                        
//                        if selectedLanguage == language {
//                            Image(systemName: "checkmark")
//                                .foregroundColor(.blue)
//                                .font(.system(size: 16, weight: .semibold))
//                        }
//                    }
//                    .contentShape(Rectangle())
//                    .onTapGesture {
//                        selectedLanguage = language
//                        languageManager.setLanguage(language)
//                        dismiss()
//                    }
//                }
//            }
//            .navigationTitle(LocalizedStrings.string(for: "language", language: languageManager.currentLanguage))
//            .navigationBarTitleDisplayMode(.inline)
//            .navigationBarItems(
//                trailing: Button(LocalizedStrings.string(for: "done", language: languageManager.currentLanguage)) {
//                    dismiss()
//                }
//                .foregroundColor(.blue)
//            )
//        }
//        .presentationDetents([.medium])
//        .environment(\.layoutDirection, languageManager.isArabic ? .rightToLeft : .leftToRight)
//    }
//}
//
//struct FooterLink: View {
//    let title: String
//    let url: String
//    @Environment(\.openURL) var openURL
//    
//    var body: some View {
//        Button(title) {
//            openURL(URL(string: url)!)
//        }
//        .font(.system(size: 14))
//        .foregroundColor(.gray)
//    }
//}
//
//// Color Extension
//extension Color {
//    init(hex: String) {
//        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
//        var int: UInt64 = 0
//        Scanner(string: hex).scanHexInt64(&int)
//        let a, r, g, b: UInt64
//        switch hex.count {
//        case 3: (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
//        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
//        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
//        default: (a, r, g, b) = (255, 0, 0, 0)
//        }
//        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
//    }
//}
//struct SettinappView: View {
//    @Binding var togglefullscreen: Bool
//    @Environment(\.openURL) var openURL
//    @EnvironmentObject var languageManager: LanguageManager
//    @State private var selectedLanguage = "English"
//    @State private var showLanguageSheet = false
//    @State private var allowNotifications = true
//    
//    private let supportEmail = "support@3rabapp.com"
//    private let currentAppId = "6743487109"
//    
//    var body: some View {
//        NavigationView {
//            VStack(spacing: 0) {
//                // Navigation Bar
//                HStack {
//                    Button(action: {
//                        // Handle back action - you can add your navigation logic here
//                        togglefullscreen = false
//                    }) {
//                        Image(systemName: "chevron.left")
//                            .font(.system(size: 20))
//                            .foregroundColor(.blue)
//                    }
//                    
//                    Spacer()
//                    
//                    LocalizedText("main_settings")
//                        .font(.system(size: 20, weight: .semibold))
//                    
//                    Spacer()
//                    
//                    // Empty space for balance
//                    Color.clear
//                        .frame(width: 24, height: 24)
//                }
//                .padding(.horizontal)
//                .padding(.vertical, 12)
//                
//                ScrollView {
//                    VStack(alignment: .leading, spacing: 16) {
//                        // In app section
//                        Text(LocalizedStrings.string(for: "in_app", language: languageManager.currentLanguage))
//                            .font(.system(size: 14))
//                            .foregroundColor(.gray)
//                            .padding(.horizontal)
//                            .padding(.top, 8)
//                        
//                        VStack(spacing: 0) {
//                            // Language
//                            SettingRow(
//                                icon: "language",
//                                title: LocalizedStrings.string(for: "language", language: languageManager.currentLanguage),
//                                value: selectedLanguage,
//                                showChevron: false,
//                                action: {
//                                    showLanguageSheet = true
//                                }
//                            )
//                            
//                            Divider()
//                            
//                            // Rate us
//                            SettingRow(
//                                icon: "rate",
//                                title: LocalizedStrings.string(for: "rate_our_app", language: languageManager.currentLanguage),
//                                showChevron: true,
//                                action: rateApp
//                            )
//                            
//                            Divider()
//                                .padding(.leading, 60)
//                            
//                            // Have a problem? contact us
//                            SettingRow(
//                                icon: "problem",
//                                title: LocalizedStrings.string(for: "have a problem? contact us", language: languageManager.currentLanguage),
//                                showChevron: true,
//                                action: sendEmail
//                            )
//                            
//                            Divider()
//                                .padding(.leading, 60)
//                            
//                            // Allow Notifications
//                            HStack(spacing: 16) {
//                                Image("notification")
//                                    .resizable()
//                                    .scaledToFit()
//                                    .frame(width: 40, height: 40)
//                                    .foregroundColor(.blue)
//                                
//                                Text("Allow Notifications")
//                                    .font(.system(size: 16))
//                                    .foregroundColor(.black)
//                                
//                                Spacer()
//                                
//                                Toggle("", isOn: $allowNotifications)
//                                    .labelsHidden()
//                                    .tint(.green)
//                            }
//                            .padding(.horizontal)
//                            .padding(.vertical, 12)
//                            
//                            Divider()
//                                .padding(.leading, 60)
//                            
//                            // Share with friends
//                            SettingRow(
//                                icon: "share",
//                                title: LocalizedStrings.string(for: "share_app_with_friends", language: languageManager.currentLanguage),
//                                showChevron: false,
//                                showShareIcon: true,
//                                action: shareApp
//                            )
//                        }
//                        .background(Color.white)
//                        .cornerRadius(12)
//                        .padding(.horizontal)
//                        
//                        // Check out apps on app store
//                        Text(LocalizedStrings.string(for: "check_our_apps", language: languageManager.currentLanguage))
//                            .font(.system(size: 14))
//                            .foregroundColor(.gray)
//                            .padding(.horizontal)
//                            .padding(.top, 4)
//                        
//                        VStack(spacing: 8) {
//                            AppRow(
//                                iconName: "qibla",
//                                title: LocalizedStrings.string(for: "muslim_qibla", language: languageManager.currentLanguage),
//                                subtitle: LocalizedStrings.string(for: "muslim_qibla_desc", language: languageManager.currentLanguage),
//                                appId: "id6736939515",
//                                appStoreUrl: "https://apps.apple.com/bj/app/muslim-%D8%A7%D8%AA%D8%AC%D8%A7%D9%87-%D8%A7%D9%84%D9%82%D8%A8%D9%84%D9%87-%D8%A7%D9%84%D8%AF%D9%82%D9%8A%D9%82/id6736939515"
//                            )
//                            
//                            AppRow(
//                                iconName: "speedtest",
//                                title: LocalizedStrings.string(for: "speedtest", language: languageManager.currentLanguage),
//                                subtitle: LocalizedStrings.string(for: "speedtest_desc", language: languageManager.currentLanguage),
//                                appId: "id1635139320",
//                                appStoreUrl: "https://apps.apple.com/bj/app/speedtest-%D8%B3%D8%B1%D8%B9%D8%A9-%D8%A7%D9%84%D9%86%D8%AA/id1635139320"
//                            )
//                            
//                            AppRow(
//                                iconName: "finder",
//                                title: LocalizedStrings.string(for: "product_finder", language: languageManager.currentLanguage),
//                                subtitle: LocalizedStrings.string(for: "product_finder_desc", language: languageManager.currentLanguage),
//                                appId: "id6737802621",
//                                appStoreUrl: "https://apps.apple.com/bj/app/product-finder-price-compare/id6737802621"
//                            )
//                            
//                            AppRow(
//                                iconName: "kitaba",
//                                title: LocalizedStrings.string(for: "kitaba", language: languageManager.currentLanguage),
//                                subtitle: LocalizedStrings.string(for: "kitaba_desc", language: languageManager.currentLanguage),
//                                appId: "id958075714",
//                                appStoreUrl: "https://apps.apple.com/us/app/%D9%83%D8%AA%D8%A7%D8%A8%D8%A9-%D8%B9%D9%84%D9%89-%D8%A7%D9%84%D8%B5%D9%88%D8%B1-%D8%AA%D8%B5%D9%85%D9%8A%D9%85-%D8%B5%D9%88%D8%B1/id958075714"
//                            )
//                            
//                            AppRow(
//                                iconName: "currency",
//                                title: LocalizedStrings.string(for: "currency_converter", language: languageManager.currentLanguage),
//                                subtitle: LocalizedStrings.string(for: "currency_converter_desc", language: languageManager.currentLanguage),
//                                appId: "id1492580244",
//                                appStoreUrl: "https://apps.apple.com/us/app/currency-currency-converter/id1492580244"
//                            )
//                            
//                            AppRow(
//                                iconName: "zaghrafalogo",
//                                title: LocalizedStrings.string(for: "zakhrafa", language: languageManager.currentLanguage),
//                                subtitle: LocalizedStrings.string(for: "zakhrafa_desc", language: languageManager.currentLanguage),
//                                appId: "id6476085334",
//                                appStoreUrl: "https://apps.apple.com/eg/app/%D8%B2%D8%AE%D8%B1%D9%81%D8%A9-%D8%B2%D8%AE%D8%B1%D9%81%D8%A9-%D9%83%D8%AA%D8%A7%D8%A8%D9%87/id6476085334"
//                            )
//                            
//                            AppRow(
//                                iconName: "zatawaty",
//                                title: LocalizedStrings.string(for: "steps", language: languageManager.currentLanguage),
//                                subtitle: LocalizedStrings.string(for: "steps_desc", language: languageManager.currentLanguage),
//                                appId: "id6502876950",
//                                appStoreUrl: "https://apps.apple.com/us/app/%D8%AE%D8%B7%D9%88%D8%A7%D8%AA/id6502876950"
//                            )
//                            
//                            // New apps
//                            AppRow(
//                                iconName: "aboserwal",
//                                title: "ابوسروال",
//                                subtitle: "وفنيلة المهمة مستحيلة",
//                                appId: "id1034718473",
//                                appStoreUrl: "https://apps.apple.com/ua/app/%D8%A7%D8%A8%D9%88%D8%B3%D8%B1%D9%88%D8%A7%D9%84-%D9%88%D9%81%D9%86%D9%8A%D9%84%D8%A9-%D8%A7%D9%84%D9%85%D9%87%D9%85%D8%A9-%D9%85%D8%B3%D8%AA%D8%AD%D9%8A%D9%84%D8%A9/id1034718473"
//                            )
//                            
//                            AppRow(
//                                iconName: "hegry",
//                                title: "التقويم الهجري",
//                                subtitle: "تقويم هجري وميلادي",
//                                appId: "id6670756504",
//                                appStoreUrl: "https://apps.apple.com/ua/app/%D8%A7%D9%84%D8%AA%D9%82%D9%88%D9%8A%D9%85-%D8%A7%D9%84%D9%87%D8%AC%D8%B1%D9%8A/id6670756504"
//                            )
//                            
//                            AppRow(
//                                iconName: "kaf",
//                                title: "Kaaf Nastaliq",
//                                subtitle: "Fonts Keyboard",
//                                appId: "id1644543252",
//                                appStoreUrl: "https://apps.apple.com/ua/app/kaaf-nastaliq-fonts-keyboard/id1644543252"
//                            )
//                            
//                            AppRow(
//                                iconName: "maany",
//                                title: "معاني الاسماء",
//                                subtitle: "بدون نت",
//                                appId: "id1452205878",
//                                appStoreUrl: "https://apps.apple.com/ua/app/%D9%85%D8%B9%D8%A7%D9%86%D9%8A-%D8%A7%D9%84%D8%A7%D8%B3%D9%85%D8%A7%D8%A1-%D8%A8%D8%AF%D9%88%D9%86-%D9%86%D8%AA/id1452205878"
//                            )
//                            
//                            AppRow(
//                                iconName: "moderelhesabat",
//                                title: "مدير الحسابات",
//                                subtitle: "تطبيق ادارة كلمات السر و تخزينها",
//                                appId: "id1197888469",
//                                appStoreUrl: "https://apps.apple.com/ua/app/%D9%85%D8%AF%D9%8A%D8%B1-%D8%A7%D9%84%D8%AD%D8%B3%D8%A7%D8%A8%D8%A7%D8%AA-%D8%AA%D8%B7%D8%A8%D9%8A%D9%82-%D8%A7%D8%AF%D8%A7%D8%B1%D8%A9-%D9%83%D9%84%D9%85%D8%A7%D8%AA-%D8%A7%D9%84%D8%B3%D8%B1-%D9%88-%D8%AA%D8%AE%D8%B2%D9%8A%D9%86-%D9%87%D8%A7/id1197888469"
//                            )
//                            
//                            AppRow(
//                                iconName: "rasm",
//                                title: "رسم على الصور",
//                                subtitle: "الكتابة والرسم على صور و تلوين",
//                                appId: "id1139476816",
//                                appStoreUrl: "https://apps.apple.com/ua/app/%D8%B1%D8%B3%D9%85-%D8%B9%D9%84%D9%89-%D8%A7%D9%84%D8%B5%D9%88%D8%B1-%D8%A7%D9%84%D9%83%D8%AA%D8%A7%D8%A8%D8%A9-%D9%88%D8%A7%D9%84%D8%B1%D8%B3%D9%85-%D8%B9%D9%84%D9%89-%D8%B5%D9%88%D8%B1-%D9%88-%D8%AA%D9%84%D9%88%D9%8A%D9%86/id1139476816"
//                            )
//                            
//                            AppRow(
//                                iconName: "rawateb",
//                                title: "وقت الراتب",
//                                subtitle: "رواتب السعودية",
//                                appId: "id885010081",
//                                appStoreUrl: "https://apps.apple.com/ua/app/%D9%88%D9%82%D8%AA-%D8%A7%D9%84%D8%B1%D8%A7%D8%AA%D8%A8-%D8%B1%D9%88%D8%A7%D8%AA%D8%A8-%D8%A7%D9%84%D8%B3%D8%B9%D9%88%D8%AF%D9%8A%D8%A9/id885010081"
//                            )
//                            
//                            AppRow(
//                                iconName: "tahwel",
//                                title: "تحويل الصور الى PDF",
//                                subtitle: "محول الصور",
//                                appId: "id6608976846",
//                                appStoreUrl: "https://apps.apple.com/ua/app/%D8%AA%D8%AD%D9%88%D9%8A%D9%84-%D8%A7%D9%84%D8%B5%D9%88%D8%B1-%D8%A7%D9%84%D9%89-pdf/id6608976846"
//                            )
//                            
//                            AppRow(
//                                iconName: "weather",
//                                title: "Weather Forecast",
//                                subtitle: "Sun App",
//                                appId: "id1492430426",
//                                appStoreUrl: "https://apps.apple.com/ua/app/weather-forecast-sun-app/id1492430426"
//                            )
//                            
//                            AppRow(
//                                iconName: "budget",
//                                title: "Wallet Budget",
//                                subtitle: "Daily Wallet",
//                                appId: "id6741729309",
//                                appStoreUrl: "https://apps.apple.com/ua/app/wallet-budget-daily-wallet/id6741729309"
//                            )
//                        }
//                        .padding(.horizontal)
//                        
//                        // Footer Links
//                        HStack(spacing: 16) {
//                            FooterLink(
//                                title: LocalizedStrings.string(for: "terms_of_use", language: languageManager.currentLanguage),
//                                url: "https://3rabapp.com/legal/term_of_use.html"
//                            )
//                            Text("|").foregroundColor(.gray)
//                            FooterLink(
//                                title: LocalizedStrings.string(for: "privacy_policy", language: languageManager.currentLanguage),
//                                url: "https://3rabapp.com/legal/privacy_policy.html"
//                            )
//                        }
//                        .frame(maxWidth: .infinity)
//                        .padding(.top, 20)
//                        .padding(.bottom, 100)
//                    }
//                }
//                .background(Color(UIColor.systemGray6))
//            }
//            .navigationBarHidden(true)
//            .sheet(isPresented: $showLanguageSheet) {
//                LanguageSelectionSheet(
//                    selectedLanguage: $selectedLanguage,
//                    languageManager: languageManager
//                )
//            }
//        }
//        .environment(\.layoutDirection, languageManager.isArabic ? .rightToLeft : .leftToRight)
//        .onAppear {
//            selectedLanguage = languageManager.currentLanguage
//        }
//    }
//    
//    private func rateApp() {
//        if let writeReviewURL = URL(string: "itms-apps://itunes.apple.com/app/\(currentAppId)?action=write-review") {
//            openURL(writeReviewURL)
//        }
//    }
//    
//    private func sendEmail() {
//        let subject = "I have a probleme Clean Guru"
//        let systemVersion = UIDevice.current.systemVersion
//        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
//        
//        let body = """
//        Hello There
//        Details of the problem:
//        
//        System version: \(systemVersion)
//        App version : \(appVersion)
//        """
//        
//        let encodedSubject = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
//        let encodedBody = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
//        
//        if let emailURL = URL(string: "mailto:\(supportEmail)?subject=\(encodedSubject)&body=\(encodedBody)") {
//            UIApplication.shared.open(emailURL)
//        }
//    }
//    
//    private func shareApp() {
//        let appURL = "https://apps.apple.com/app/id\(currentAppId)"
//        
//        let activityVC = UIActivityViewController(
//            activityItems: [appURL],
//            applicationActivities: nil
//        )
//        
//        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//           let window = windowScene.windows.first,
//           let rootVC = window.rootViewController {
//            rootVC.present(activityVC, animated: true)
//        }
//    }
//}
//
//struct SettingRow: View {
//    let icon: String
//    let title: String
//    var value: String? = nil
//    var showChevron: Bool = false
//    var showShareIcon: Bool = false
//    let action: () -> Void
//    @EnvironmentObject var languageManager: LanguageManager
//    
//    var body: some View {
//        Button(action: action) {
//            HStack(spacing: 16) {
//                Image(icon)
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 40, height: 40)
//                    .foregroundColor(.blue)
//                
//                Text(title)
//                    .font(.system(size: 16))
//                    .foregroundColor(.black)
//                
//                Spacer()
//                
//                if let value = value {
//                    Text(value)
//                        .font(.system(size: 15))
//                        .foregroundColor(.gray)
//                }
//                
//                if showChevron {
//                    Image(systemName: languageManager.isArabic ? "chevron.left" : "chevron.right")
//                        .font(.system(size: 14))
//                        .foregroundColor(.gray)
//                }
//                
//                if showShareIcon {
//                    Image(systemName: "square.and.arrow.up")
//                        .font(.system(size: 18))
//                        .foregroundColor(.blue)
//                }
//            }
//            .padding(.horizontal)
//            .padding(.vertical, 12)
//        }
//    }
//}
//
//struct AppRow: View {
//    let iconName: String
//    let title: String
//    let subtitle: String
//    let appId: String
//    let appStoreUrl: String
//    @Environment(\.openURL) var openURL
//    
//    var body: some View {
//        HStack(spacing: 12) {
//            Image(iconName)
//                .resizable()
//                .scaledToFit()
//                .frame(width: 50, height: 50)
//                .cornerRadius(12)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 12)
//                        .stroke(Color.gray.opacity(0.2), lineWidth: 0.5)
//                )
//            
//            VStack(alignment: .leading, spacing: 2) {
//                Text(title)
//                    .font(.system(size: 16, weight: .medium))
//                    .foregroundColor(.black)
//                
//                Text(subtitle)
//                    .font(.system(size: 13))
//                    .foregroundColor(.gray)
//                    .lineLimit(1)
//            }
//            
//            Spacer()
//            
//            Button(action: {
//                if let url = URL(string: appStoreUrl) {
//                    openURL(url)
//                }
//            }) {
//                LocalizedText("get")
//                    .font(.system(size: 15, weight: .semibold))
//                    .foregroundColor(.white)
//                    .padding(.horizontal, 20)
//                    .padding(.vertical, 6)
//                    .background(Color.blue)
//                    .cornerRadius(16)
//            }
//        }
//        .padding(.horizontal)
//        .padding(.vertical, 8)
//        .background(Color.white)
//        .cornerRadius(12)
//    }
//}
//
//struct LanguageSelectionSheet: View {
//    @Binding var selectedLanguage: String
//    @Environment(\.dismiss) var dismiss
//    let languageManager: LanguageManager
//    
//    private let availableLanguages = ["English", "العربية"]
//    
//    var body: some View {
//        NavigationView {
//            List {
//                ForEach(availableLanguages, id: \.self) { language in
//                    HStack {
//                        Text(language)
//                            .font(.system(size: 16))
//                        
//                        Spacer()
//                        
//                        if selectedLanguage == language {
//                            Image(systemName: "checkmark")
//                                .foregroundColor(.blue)
//                                .font(.system(size: 16, weight: .semibold))
//                        }
//                    }
//                    .contentShape(Rectangle())
//                    .onTapGesture {
//                        selectedLanguage = language
//                        languageManager.setLanguage(language)
//                        dismiss()
//                    }
//                }
//            }
//            .navigationTitle(LocalizedStrings.string(for: "language", language: languageManager.currentLanguage))
//            .navigationBarTitleDisplayMode(.inline)
//            .navigationBarItems(
//                trailing: Button(LocalizedStrings.string(for: "done", language: languageManager.currentLanguage)) {
//                    dismiss()
//                }
//                .foregroundColor(.blue)
//            )
//        }
//        .presentationDetents([.medium])
//        .environment(\.layoutDirection, languageManager.isArabic ? .rightToLeft : .leftToRight)
//    }
//}
//
//struct FooterLink: View {
//    let title: String
//    let url: String
//    @Environment(\.openURL) var openURL
//    
//    var body: some View {
//        Button(title) {
//            openURL(URL(string: url)!)
//        }
//        .font(.system(size: 14))
//        .foregroundColor(.gray)
//    }
//}
//
//// Color Extension
//extension Color {
//    init(hex: String) {
//        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
//        var int: UInt64 = 0
//        Scanner(string: hex).scanHexInt64(&int)
//        let a, r, g, b: UInt64
//        switch hex.count {
//        case 3: (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
//        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
//        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
//        default: (a, r, g, b) = (255, 0, 0, 0)
//        }
//        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
//    }
//}

struct SettinappView: View {
    @Binding var togglefullscreen: Bool
    @Environment(\.openURL) var openURL
    @EnvironmentObject var languageManager: LanguageManager
    @State private var selectedLanguage = "English"
    @State private var showLanguageSheet = false
    @State private var allowNotifications = true
    
    private let supportEmail = "support@3rabapp.com"
    private let currentAppId = "6743487109"
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Navigation Bar
                HStack {
                    Button(action: {
                        // Handle back action - you can add your navigation logic here
                        togglefullscreen = false
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20))
                            .foregroundColor(.blue)
                    }
                    
                    Spacer()
                    
                    LocalizedText("main_settings")
                        .font(.system(size: 20, weight: .semibold))
                    
                    Spacer()
                    
                    // Empty space for balance
                    Color.clear
                        .frame(width: 24, height: 24)
                }
                .padding(.horizontal)
                .padding(.vertical, 12)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        // In app section
                        Text(LocalizedStrings.string(for: "in_app", language: languageManager.currentLanguage))
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                            .padding(.top, 8)
                        
                        VStack(spacing: 0) {
                            // Language
                            SettingRow(
                                icon: "language",
                                title: LocalizedStrings.string(for: "language", language: languageManager.currentLanguage),
                                value: selectedLanguage,
                                showChevron: false,
                                action: {
                                    showLanguageSheet = true
                                }
                            )
                            
                            Divider()
                            
                            // Rate us
                            SettingRow(
                                icon: "rate",
                                title: LocalizedStrings.string(for: "rate_our_app", language: languageManager.currentLanguage),
                                showChevron: true,
                                action: rateApp
                            )
                            
                            Divider()
                                .padding(.leading, 60)
                            
                            // Have a problem? contact us
                            SettingRow(
                                icon: "problem",
                                title: LocalizedStrings.string(for: "have a problem? contact us", language: languageManager.currentLanguage),
                                showChevron: true,
                                action: sendEmail
                            )
                            
                            Divider()
                                .padding(.leading, 60)
                            
                            // Allow Notifications
                            HStack(spacing: 16) {
                                Image("notification")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.blue)
                                
                                Text("Allow Notifications")
                                    .font(.system(size: 16))
                                    .foregroundColor(.black)
                                
                                Spacer()
                                
                                Toggle("", isOn: $allowNotifications)
                                    .labelsHidden()
                                    .tint(.green)
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 12)
                            
                            Divider()
                                .padding(.leading, 60)
                            
                            // Share with friends
                            SettingRow(
                                icon: "share",
                                title: LocalizedStrings.string(for: "share_app_with_friends", language: languageManager.currentLanguage),
                                showChevron: false,
                                showShareIcon: true,
                                action: shareApp
                            )
                        }
                        .background(Color.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                        
                        // Check out apps on app store
                        Text(LocalizedStrings.string(for: "check_our_apps", language: languageManager.currentLanguage))
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                            .padding(.top, 4)
                        
                        VStack(spacing: 8) {
                            AppRow(
                                iconName: "qibla",
                                title: LocalizedStrings.string(for: "muslim_qibla", language: languageManager.currentLanguage),
                                subtitle: LocalizedStrings.string(for: "muslim_qibla_desc", language: languageManager.currentLanguage),
                                appId: "id6736939515",
                                appStoreUrl: "https://apps.apple.com/bj/app/muslim-%D8%A7%D8%AA%D8%AC%D8%A7%D9%87-%D8%A7%D9%84%D9%82%D8%A8%D9%84%D9%87-%D8%A7%D9%84%D8%AF%D9%82%D9%8A%D9%82/id6736939515"
                            )
                            
                            AppRow(
                                iconName: "speedtest",
                                title: LocalizedStrings.string(for: "speedtest", language: languageManager.currentLanguage),
                                subtitle: LocalizedStrings.string(for: "speedtest_desc", language: languageManager.currentLanguage),
                                appId: "id1635139320",
                                appStoreUrl: "https://apps.apple.com/bj/app/speedtest-%D8%B3%D8%B1%D8%B9%D8%A9-%D8%A7%D9%84%D9%86%D8%AA/id1635139320"
                            )
                            
                            AppRow(
                                iconName: "finder",
                                title: LocalizedStrings.string(for: "product_finder", language: languageManager.currentLanguage),
                                subtitle: LocalizedStrings.string(for: "product_finder_desc", language: languageManager.currentLanguage),
                                appId: "id6737802621",
                                appStoreUrl: "https://apps.apple.com/bj/app/product-finder-price-compare/id6737802621"
                            )
                            
                            AppRow(
                                iconName: "kitaba",
                                title: LocalizedStrings.string(for: "kitaba", language: languageManager.currentLanguage),
                                subtitle: LocalizedStrings.string(for: "kitaba_desc", language: languageManager.currentLanguage),
                                appId: "id958075714",
                                appStoreUrl: "https://apps.apple.com/us/app/%D9%83%D8%AA%D8%A7%D8%A8%D8%A9-%D8%B9%D9%84%D9%89-%D8%A7%D9%84%D8%B5%D9%88%D8%B1-%D8%AA%D8%B5%D9%85%D9%8A%D9%85-%D8%B5%D9%88%D8%B1/id958075714"
                            )
                            
                            AppRow(
                                iconName: "currency",
                                title: LocalizedStrings.string(for: "currency_converter", language: languageManager.currentLanguage),
                                subtitle: LocalizedStrings.string(for: "currency_converter_desc", language: languageManager.currentLanguage),
                                appId: "id1492580244",
                                appStoreUrl: "https://apps.apple.com/us/app/currency-currency-converter/id1492580244"
                            )
                            
                            AppRow(
                                iconName: "zaghrafalogo",
                                title: LocalizedStrings.string(for: "zakhrafa", language: languageManager.currentLanguage),
                                subtitle: LocalizedStrings.string(for: "zakhrafa_desc", language: languageManager.currentLanguage),
                                appId: "id6476085334",
                                appStoreUrl: "https://apps.apple.com/eg/app/%D8%B2%D8%AE%D8%B1%D9%81%D8%A9-%D8%B2%D8%AE%D8%B1%D9%81%D8%A9-%D9%83%D8%AA%D8%A7%D8%A8%D9%87/id6476085334"
                            )
                            
                            AppRow(
                                iconName: "zatawaty",
                                title: LocalizedStrings.string(for: "steps", language: languageManager.currentLanguage),
                                subtitle: LocalizedStrings.string(for: "steps_desc", language: languageManager.currentLanguage),
                                appId: "id6502876950",
                                appStoreUrl: "https://apps.apple.com/us/app/%D8%AE%D8%B7%D9%88%D8%A7%D8%AA/id6502876950"
                            )
                            
                            // New apps
                            AppRow(
                                iconName: "aboserwal",
                                title: LocalizedStrings.string(for: "aboserwal", language: languageManager.currentLanguage),
                                subtitle: LocalizedStrings.string(for: "aboserwal_desc", language: languageManager.currentLanguage),
                                appId: "id1034718473",
                                appStoreUrl: "https://apps.apple.com/ua/app/%D8%A7%D8%A8%D9%88%D8%B3%D8%B1%D9%88%D8%A7%D9%84-%D9%88%D9%81%D9%86%D9%8A%D9%84%D8%A9-%D8%A7%D9%84%D9%85%D9%87%D9%85%D8%A9-%D9%85%D8%B3%D8%AA%D8%AD%D9%8A%D9%84%D8%A9/id1034718473"
                            )
                            
                            AppRow(
                                iconName: "hegry",
                                title: LocalizedStrings.string(for: "hegry", language: languageManager.currentLanguage),
                                subtitle: LocalizedStrings.string(for: "hegry_desc", language: languageManager.currentLanguage),
                                appId: "id6670756504",
                                appStoreUrl: "https://apps.apple.com/ua/app/%D8%A7%D9%84%D8%AA%D9%82%D9%88%D9%8A%D9%85-%D8%A7%D9%84%D9%87%D8%AC%D8%B1%D9%8A/id6670756504"
                            )
                            
                            AppRow(
                                iconName: "kaf",
                                title: LocalizedStrings.string(for: "kaf", language: languageManager.currentLanguage),
                                subtitle: LocalizedStrings.string(for: "kaf_desc", language: languageManager.currentLanguage),
                                appId: "id1644543252",
                                appStoreUrl: "https://apps.apple.com/ua/app/kaaf-nastaliq-fonts-keyboard/id1644543252"
                            )
                            
                            AppRow(
                                iconName: "maany",
                                title: LocalizedStrings.string(for: "maany", language: languageManager.currentLanguage),
                                subtitle: LocalizedStrings.string(for: "maany_desc", language: languageManager.currentLanguage),
                                appId: "id1452205878",
                                appStoreUrl: "https://apps.apple.com/ua/app/%D9%85%D8%B9%D8%A7%D9%86%D9%8A-%D8%A7%D9%84%D8%A7%D8%B3%D9%85%D8%A7%D8%A1-%D8%A8%D8%AF%D9%88%D9%86-%D9%86%D8%AA/id1452205878"
                            )
                            
                            AppRow(
                                iconName: "moderelhesabat",
                                title: LocalizedStrings.string(for: "moderelhesabat", language: languageManager.currentLanguage),
                                subtitle: LocalizedStrings.string(for: "moderelhesabat_desc", language: languageManager.currentLanguage),
                                appId: "id1197888469",
                                appStoreUrl: "https://apps.apple.com/ua/app/%D9%85%D8%AF%D9%8A%D8%B1-%D8%A7%D9%84%D8%AD%D8%B3%D8%A7%D8%A8%D8%A7%D8%AA-%D8%AA%D8%B7%D8%A8%D9%8A%D9%82-%D8%A7%D8%AF%D8%A7%D8%B1%D8%A9-%D9%83%D9%84%D9%85%D8%A7%D8%AA-%D8%A7%D9%84%D8%B3%D8%B1-%D9%88-%D8%AA%D8%AE%D8%B2%D9%8A%D9%86-%D9%87%D8%A7/id1197888469"
                            )
                            
                            AppRow(
                                iconName: "rasm",
                                title: LocalizedStrings.string(for: "rasm", language: languageManager.currentLanguage),
                                subtitle: LocalizedStrings.string(for: "rasm_desc", language: languageManager.currentLanguage),
                                appId: "id1139476816",
                                appStoreUrl: "https://apps.apple.com/ua/app/%D8%B1%D8%B3%D9%85-%D8%B9%D9%84%D9%89-%D8%A7%D9%84%D8%B5%D9%88%D8%B1-%D8%A7%D9%84%D9%83%D8%AA%D8%A7%D8%A8%D8%A9-%D9%88%D8%A7%D9%84%D8%B1%D8%B3%D9%85-%D8%B9%D9%84%D9%89-%D8%B5%D9%88%D8%B1-%D9%88-%D8%AA%D9%84%D9%88%D9%8A%D9%86/id1139476816"
                            )
                            
                            AppRow(
                                iconName: "rawateb",
                                title: LocalizedStrings.string(for: "rawateb", language: languageManager.currentLanguage),
                                subtitle: LocalizedStrings.string(for: "rawateb_desc", language: languageManager.currentLanguage),
                                appId: "id885010081",
                                appStoreUrl: "https://apps.apple.com/ua/app/%D9%88%D9%82%D8%AA-%D8%A7%D9%84%D8%B1%D8%A7%D8%AA%D8%A8-%D8%B1%D9%88%D8%A7%D8%AA%D8%A8-%D8%A7%D9%84%D8%B3%D8%B9%D9%88%D8%AF%D9%8A%D8%A9/id885010081"
                            )
                            
                            AppRow(
                                iconName: "tahwel",
                                title: LocalizedStrings.string(for: "tahwel", language: languageManager.currentLanguage),
                                subtitle: LocalizedStrings.string(for: "tahwel_desc", language: languageManager.currentLanguage),
                                appId: "id6608976846",
                                appStoreUrl: "https://apps.apple.com/ua/app/%D8%AA%D8%AD%D9%88%D9%8A%D9%84-%D8%A7%D9%84%D8%B5%D9%88%D8%B1-%D8%A7%D9%84%D9%89-pdf/id6608976846"
                            )
                            
                            AppRow(
                                iconName: "weather",
                                title: LocalizedStrings.string(for: "weather", language: languageManager.currentLanguage),
                                subtitle: LocalizedStrings.string(for: "weather_desc", language: languageManager.currentLanguage),
                                appId: "id1492430426",
                                appStoreUrl: "https://apps.apple.com/ua/app/weather-forecast-sun-app/id1492430426"
                            )
                            
                            AppRow(
                                iconName: "budget",
                                title: LocalizedStrings.string(for: "budget", language: languageManager.currentLanguage),
                                subtitle: LocalizedStrings.string(for: "budget_desc", language: languageManager.currentLanguage),
                                appId: "id6741729309",
                                appStoreUrl: "https://apps.apple.com/ua/app/wallet-budget-daily-wallet/id6741729309"
                            )
                        }
                        .padding(.horizontal)
                        
                        // Footer Links
                        HStack(spacing: 16) {
                            FooterLink(
                                title: LocalizedStrings.string(for: "terms_of_use", language: languageManager.currentLanguage),
                                url: "https://3rabapp.com/legal/term_of_use.html"
                            )
                            Text("|").foregroundColor(.gray)
                            FooterLink(
                                title: LocalizedStrings.string(for: "privacy_policy", language: languageManager.currentLanguage),
                                url: "https://3rabapp.com/legal/privacy_policy.html"
                            )
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 20)
                        .padding(.bottom, 100)
                    }
                }
                .background(Color(UIColor.systemGray6))
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showLanguageSheet) {
                LanguageSelectionSheet(
                    selectedLanguage: $selectedLanguage,
                    languageManager: languageManager
                )
            }
        }
        .environment(\.layoutDirection, languageManager.isArabic ? .rightToLeft : .leftToRight)
        .onAppear {
            selectedLanguage = languageManager.currentLanguage
        }
    }
    
    private func rateApp() {
        if let writeReviewURL = URL(string: "itms-apps://itunes.apple.com/app/\(currentAppId)?action=write-review") {
            openURL(writeReviewURL)
        }
    }
    
    private func sendEmail() {
        let subject = "I have a probleme Clean Guru"
        let systemVersion = UIDevice.current.systemVersion
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
        
        let body = """
        Hello There
        Details of the problem:
        
        System version: \(systemVersion)
        App version : \(appVersion)
        """
        
        let encodedSubject = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let encodedBody = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        if let emailURL = URL(string: "mailto:\(supportEmail)?subject=\(encodedSubject)&body=\(encodedBody)") {
            UIApplication.shared.open(emailURL)
        }
    }
    
    private func shareApp() {
        let appURL = "https://apps.apple.com/app/id\(currentAppId)"
        
        let activityVC = UIActivityViewController(
            activityItems: [appURL],
            applicationActivities: nil
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let rootVC = window.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }
}

struct SettingRow: View {
    let icon: String
    let title: String
    var value: String? = nil
    var showChevron: Bool = false
    var showShareIcon: Bool = false
    let action: () -> Void
    @EnvironmentObject var languageManager: LanguageManager
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.blue)
                
                Text(title)
                    .font(.system(size: 16))
                    .foregroundColor(.black)
                
                Spacer()
                
                if let value = value {
                    Text(value)
                        .font(.system(size: 15))
                        .foregroundColor(.gray)
                }
                
                if showChevron {
                    Image(systemName: languageManager.isArabic ? "chevron.left" : "chevron.right")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                
                if showShareIcon {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 18))
                        .foregroundColor(.blue)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
        }
    }
}

struct AppRow: View {
    let iconName: String
    let title: String
    let subtitle: String
    let appId: String
    let appStoreUrl: String
    @Environment(\.openURL) var openURL
    
    var body: some View {
        HStack(spacing: 12) {
            Image(iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 0.5)
                )
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.black)
                
                Text(subtitle)
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            
            Spacer()
            
            Button(action: {
                if let url = URL(string: appStoreUrl) {
                    openURL(url)
                }
            }) {
                LocalizedText("get")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 6)
                    .background(Color.blue)
                    .cornerRadius(16)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color.white)
        .cornerRadius(12)
    }
}

struct LanguageSelectionSheet: View {
    @Binding var selectedLanguage: String
    @Environment(\.dismiss) var dismiss
    let languageManager: LanguageManager
    
    private let availableLanguages = ["English", "العربية"]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(availableLanguages, id: \.self) { language in
                    HStack {
                        Text(language)
                            .font(.system(size: 16))
                        
                        Spacer()
                        
                        if selectedLanguage == language {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                                .font(.system(size: 16, weight: .semibold))
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedLanguage = language
                        languageManager.setLanguage(language)
                        dismiss()
                    }
                }
            }
            .navigationTitle(LocalizedStrings.string(for: "language", language: languageManager.currentLanguage))
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Button(LocalizedStrings.string(for: "done", language: languageManager.currentLanguage)) {
                    dismiss()
                }
                .foregroundColor(.blue)
            )
        }
        .presentationDetents([.medium])
        .environment(\.layoutDirection, languageManager.isArabic ? .rightToLeft : .leftToRight)
    }
}

struct FooterLink: View {
    let title: String
    let url: String
    @Environment(\.openURL) var openURL
    
    var body: some View {
        Button(title) {
            openURL(URL(string: url)!)
        }
        .font(.system(size: 14))
        .foregroundColor(.gray)
    }
}

// Color Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}

// Helper for localized text
// Helper for localized text
//struct LocalizedText: View {
//    let key: String
//    @EnvironmentObject var languageManager: LanguageManager
//    
//    init(_ key: String) {
//        self.key = key
//    }
//    
//    var body: some View {
//        Text(LocalizedStrings.string(for: key, language: languageManager.currentLanguage))
//    }
//}
