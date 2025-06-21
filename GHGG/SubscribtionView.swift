//
//  SubscribtionView.swift
//  GHGG
//
//  Created by test on 14/06/2025.
//

import SwiftUI

struct SubscriptionView: View {
    @State private var selectedPlan = "yearly"
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [Color(hex: "5B7FB9"), Color(hex: "4A6FA5")],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // Circuit board pattern overlay
            CircuitBoardPattern()
                .opacity(0.1)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Navigation Header
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .font(.system(size: 20, weight: .medium))
                    }
                    .padding(.leading, 16)
                    
                    Spacer()
                    
                    Text("Subscription")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                        .offset(x: -20) // Center the title accounting for back button
                    
                    Spacer()
                }
                .padding(.top, 50)
                .padding(.bottom, 10)
                
                ScrollView {
                    VStack(spacing: 0) {
                        // Device illustration
                        DeviceIllustration()
                            .frame(height: 180)
                            .padding(.vertical, 20)
                        
                        // Features list
                        VStack(alignment: .leading, spacing: 14) {
                            FeatureRow(text: "Remove Ads")
                            FeatureRow(text: "Unlimited usage")
                            FeatureRow(text: "Access all features")
                            FeatureRow(text: "Access all features")
                        }
                        .padding(.horizontal, 30)
                        .padding(.bottom, 30)
                        
                        // Subscription options
                        VStack(spacing: 12) {
                            // Yearly plan (recommended)
                            SubscriptionOption(
                                title: "Yearly 9.99 $/year",
                                subtitle: "auto-renewing subscription",
                                isSelected: selectedPlan == "yearly",
                                isRecommended: true,
                                action: { selectedPlan = "yearly" }
                            )
                            
                            // Monthly plans
                            SubscriptionOption(
                                title: "Monthly 9.99 $/year",
                                subtitle: "auto-renewing subscription",
                                isSelected: selectedPlan == "monthly1",
                                action: { selectedPlan = "monthly1" }
                            )
                            
                            SubscriptionOption(
                                title: "Monthly 9.99 $/year",
                                subtitle: "auto-renewing subscription",
                                isSelected: selectedPlan == "monthly2",
                                action: { selectedPlan = "monthly2" }
                            )
                        }
                        .padding(.horizontal, 16)
                        
                        // Upgrade button
                        Button(action: {
                            // Handle upgrade action
                        }) {
                            Text("Upgrade")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.blue)
                                .cornerRadius(12)
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                        
                        // Bottom indicator
                        RoundedRectangle(cornerRadius: 2.5)
                            .fill(Color.black)
                            .frame(width: 134, height: 5)
                            .padding(.top, 12)
                            .padding(.bottom, 20)
                    }
                }
            }
        }
        .statusBar(hidden: false)
    }
}

struct FeatureRow: View {
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(Color(hex: "4CD964"))
                .font(.system(size: 24))
            
            Text(text)
                .font(.system(size: 16))
                .foregroundColor(.white)
            
            Spacer()
        }
    }
}

struct SubscriptionOption: View {
    let title: String
    let subtitle: String
    let isSelected: Bool
    var isRecommended: Bool = false
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack(alignment: .topTrailing) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.black)
                    
                    Text(subtitle)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 16)
                .padding(.horizontal, 20)
                .background(Color.white)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
                )
                
                if isRecommended {
                    Text("Recommended")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.blue)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(Color(hex: "E6F2FF"))
                        .cornerRadius(12)
                        .offset(y: -10)
                }
            }
        }
    }
}

struct DeviceIllustration: View {
    var body: some View {
        ZStack {
            // Device shape
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [Color(hex: "6B8BC4"), Color(hex: "5B7FB9")],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: 120, height: 200)
                .overlay(
                    // Circuit patterns
                    VStack(spacing: 0) {
                        ForEach(0..<8) { _ in
                            HStack(spacing: 2) {
                                ForEach(0..<4) { _ in
                                    Circle()
                                        .fill(Color.white.opacity(0.1))
                                        .frame(width: 4, height: 4)
                                }
                            }
                            .padding(.vertical, 2)
                        }
                    }
                )
                .overlay(
                    // Screen area
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(hex: "4A6FA5"))
                        .frame(width: 90, height: 120)
                        .overlay(
                            Image(systemName: "cpu")
                                .font(.system(size: 40))
                                .foregroundColor(.white.opacity(0.3))
                        )
                )
                .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
            
            // Circuit lines around device
            CircuitLines()
        }
    }
}

struct CircuitBoardPattern: View {
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let spacing: CGFloat = 40
                let lineCount = Int(geometry.size.width / spacing)
                
                for i in 0...lineCount {
                    let x = CGFloat(i) * spacing
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: x, y: geometry.size.height))
                }
                
                let horizontalCount = Int(geometry.size.height / spacing)
                for i in 0...horizontalCount {
                    let y = CGFloat(i) * spacing
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: y))
                }
            }
            .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
        }
    }
}

struct CircuitLines: View {
    var body: some View {
        ZStack {
            // Add decorative circuit lines around the device
            Path { path in
                path.move(to: CGPoint(x: -50, y: 0))
                path.addLine(to: CGPoint(x: -20, y: 0))
                path.addLine(to: CGPoint(x: -20, y: 30))
                
                path.move(to: CGPoint(x: 50, y: 0))
                path.addLine(to: CGPoint(x: 20, y: 0))
                path.addLine(to: CGPoint(x: 20, y: -30))
            }
            .stroke(Color.white.opacity(0.3), lineWidth: 1)
            
            // Circuit dots
            Circle()
                .fill(Color.white.opacity(0.4))
                .frame(width: 6, height: 6)
                .offset(x: -50, y: 0)
            
            Circle()
                .fill(Color.white.opacity(0.4))
                .frame(width: 6, height: 6)
                .offset(x: 50, y: 0)
        }
    }
}

// Note: This code assumes you have a Color extension with init(hex:) defined elsewhere in your project
// If not, uncomment the extension below:
/*
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
*/

// Preview
struct SubscriptionView_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionView()
    }
}
