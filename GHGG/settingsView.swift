//
//  settingsView.swift
//  GHGG
//
//  Created by test on 11/05/2025.
//

import Foundation
import SwiftUI

struct SettinappView: View {
    @Binding var togglefullscreen: Bool
    @Environment(\.openURL) var openURL
    
    private let supportEmail = "support@3rabapp.com"
    
    private let colors = SettingsColors(
        background: .white,
        cardBackground: Color(hex: "F5F5F5"),
        accent: Color(hex: "007AFF"),
        divider: Color(hex: "E0E0E0"),
        text: .black,
        secondaryText: Color.black.opacity(0.6)
    )
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                // Header with close button
                HStack {
                  
                }
                
                // Title
                Text("Main Settings")
                    .font(.custom("System", size: 24))
                    .foregroundColor(colors.text)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 8)
                
                // Feedback Section
                SectionView(title: "Help Us Improve") {
                    VStack(spacing: 12) {
                        FeedbackButton(
                            icon: "star.fill",
                            text: "Rate Our App",
                            iconColor: Color(hex: "FFD700"),
                            action: rateApp
                        )
                        DividerLine(color: colors.divider)
                        
                        FeedbackButton(
                            icon: "envelope.fill",
                            text: "Share Your Feedback",
                            iconColor: Color(hex: "4CD964"),
                            action: sendEmail
                        )
                        DividerLine(color: colors.divider)
                        
                        FeedbackButton(
                            icon: "exclamationmark.triangle.fill",
                            text: "Having Issues?",
                            iconColor: Color(hex: "FF9500"),
                            action: sendEmail
                        )
                        DividerLine(color: colors.divider)
                        
                        FeedbackButton(
                            icon: "heart.slash.fill",
                            text: "Not Enjoying the App?",
                            iconColor: Color(hex: "FF3B30"),
                            action: sendEmail
                        )
                        DividerLine(color: colors.divider)
                        
                        FeedbackButton(
                            icon: "square.and.arrow.up",
                            text: "Share App with Friends",
                            iconColor: Color(hex: "007AFF"),
                            action: shareApp
                        )
                    }
                    .padding(.vertical, 8)
                }
                
                // Our Apps Section
                SectionView(title: "Check Our Apps") {
                    VStack(spacing: 16) {
                        AppListItem(
                            title: "Muslim Qibla",
                            subtitle: "Accurate Qibla Direction",
                            iconName: "qibla",
                            appId: "id6736939515",
                            colors: colors
                        )
                        AppListItem(
                            title: "Speedtest",
                            subtitle: "Internet Speed Test",
                            iconName: "speedtest",
                            appId: "id1635139320",
                            colors: colors
                        )
                        AppListItem(
                            title: "Product Finder",
                            subtitle: "Price Comparison",
                            iconName: "finder",
                            appId: "id6737802621",
                            colors: colors
                        )
                        AppListItem(
                            title: "Kitaba",
                            subtitle: "Design Photos & Arabic Fonts",
                            iconName: "kitaba",
                            appId: "id958075714",
                            colors: colors
                        )
                        AppListItem(
                            title: "Currency Converter",
                            subtitle: "Global Currency Exchange",
                            iconName: "currency",
                            appId: "id1492580244",
                            colors: colors
                        )
                        AppListItem(
                            title: "Zakhrafa",
                            subtitle: "Arabic Text Decoration",
                            iconName: "zaghrafalogo",
                            appId: "id6476085334",
                            colors: colors
                        )
                        AppListItem(
                            title: "Steps",
                            subtitle: "Daily Step Counter",
                            iconName: "zatawaty",
                            appId: "id6502876950",
                            colors: colors
                        )
                    }
                }
                
                // Footer Links
                HStack(spacing: 16) {
                    FooterLink(
                        title: "Terms of Use",
                        url: "https://3rabapp.com/legal/term_of_use.html"
                    )
                    Text("|").foregroundColor(colors.secondaryText)
                    FooterLink(
                        title: "Privacy Policy",
                        url: "https://3rabapp.com/legal/privacy_policy.html"
                    )
                }
                .padding(.top, 32)
                .padding(.bottom, 16)
            }
            .padding(.horizontal)
        }
        .background(colors.background.ignoresSafeArea())
    }
    
    private func rateApp() {
        guard let writeReviewURL = URL(string: "itms-apps://itunes.apple.com/app/1635139320?action=write-review") else { return }
        openURL(writeReviewURL)
    }
    
    private func sendEmail() {
        guard let emailURL = URL(string: "mailto:\(supportEmail)") else { return }
        openURL(emailURL)
    }
    
    private func shareApp() {
        let activityVC = UIActivityViewController(
            activityItems: ["Check out this amazing app!"],
            applicationActivities: nil
        )
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let rootVC = window.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }
}

struct SettingsColors {
    let background: Color
    let cardBackground: Color
    let accent: Color
    let divider: Color
    let text: Color
    let secondaryText: Color
}

struct SectionView<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.custom("AlmaraiBold", size: 17))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            content
                .background(Color(hex: "F5F5F5"))
                .cornerRadius(12)
        }
    }
}

struct FeedbackButton: View {
    let icon: String
    let text: String
    let iconColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .foregroundColor(iconColor)
                    .font(.system(size: 20))
                
                Text(text)
                    .font(.custom("AlmaraiBold", size: 15))
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color(hex: "787880"))
            }
            .foregroundColor(.black)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(hex: "F5F5F5"))
            .cornerRadius(10)
        }
        .buttonStyle(ScaleButtonStyle())
        .padding(.horizontal)
    }
}

struct AppListItem: View {
   let title: String
   let subtitle: String
   let iconName: String
   let appId: String
   let colors: SettingsColors
   @Environment(\.openURL) var openURL
   
   var body: some View {
       HStack(spacing: 16) {
           // App icon
           Image(iconName)
               .resizable()
               .scaledToFit()
               .frame(width: 48, height: 48)
               .cornerRadius(10)
               .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
           
           // App details
           VStack(alignment: .leading, spacing: 4) {
               Text(title)
                   .font(.custom("AlmaraiBold", size: 15))
                   .foregroundColor(.black)
               
               Text(subtitle)
                   .font(.custom("Almarai", size: 13))
                   .foregroundColor(.black.opacity(0.6))
           }
           
           Spacer()
           
           // Get button
           Button {
               let appURLs = [
                   "Muslim Qibla": "https://apps.apple.com/bj/app/muslim-%D8%A7%D8%AA%D8%AC%D8%A7%D9%87-%D8%A7%D9%84%D9%82%D8%A8%D9%84%D9%87-%D8%A7%D9%84%D8%AF%D9%82%D9%8A%D9%82/id6736939515",
                   "Speedtest": "https://apps.apple.com/bj/app/speedtest-%D8%B3%D8%B1%D8%B9%D8%A9-%D8%A7%D9%84%D9%86%D8%AA/id1635139320",
                   "Product Finder": "https://apps.apple.com/bj/app/product-finder-price-compare/id6737802621",
                   "Kitaba": "https://apps.apple.com/us/app/%D9%83%D8%AA%D8%A7%D8%A8%D8%A9-%D8%B9%D9%84%D9%89-%D8%A7%D9%84%D8%B5%D9%88%D8%B1-%D8%AA%D8%B5%D9%85%D9%8A%D9%85-%D8%B5%D9%88%D8%B1/id958075714",
                   "Currency Converter": "https://apps.apple.com/us/app/currency-currency-converter/id1492580244",
                   "Zakhrafa": "https://apps.apple.com/eg/app/%D8%B2%D8%AE%D8%B1%D9%81%D8%A9-%D8%B2%D8%AE%D8%B1%D9%81%D8%A9-%D9%83%D8%AA%D8%A7%D8%A8%D9%87/id6476085334",
                   "Steps": "https://apps.apple.com/us/app/%D8%AE%D8%B7%D9%88%D8%A7%D8%AA/id6502876950"
               ]
               
               if let url = URL(string: appURLs[title] ?? "https://apps.apple.com/app/\(appId)") {
                   openURL(url)
               }
           } label: {
               Text("Get")
                   .fontWeight(.medium)
                   .font(.system(size: 14))
                   .foregroundColor(.white)
                   .frame(width: 70, height: 32)
                   .background(Color.blue)
                   .cornerRadius(16)
           }
       }
       .padding(.horizontal, 16)
       .padding(.vertical, 12)
       .background(colors.cardBackground)
       .cornerRadius(12)
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
        .font(.custom("Almarai", size: 14))
        .foregroundColor(.black)
    }
}

struct DividerLine: View {
    let color: Color
    
    var body: some View {
        color
            .frame(height: 1)
            .opacity(0.2)
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

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
