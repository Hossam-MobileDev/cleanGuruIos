//
//  storageAnalyticsView.swift
//  GHGG
//
//  Created by test on 11/05/2025.
//

import Foundation
import SwiftUI

struct StorageAnalyticsView: View {
    @State private var showSubscription = false
    @StateObject private var deviceInfo = DeviceInfoManager()
    @EnvironmentObject var languageManager: LanguageManager // Changed from @StateObject to @EnvironmentObject

    // Calculate storage usage percentage
    var storagePercentage: Int {
        let total = deviceInfo.totalStorage.0
        let used = deviceInfo.usedStorage.0
        if let totalValue = Double(total), totalValue > 0,
           let usedValue = Double(used) {
            return Int((usedValue / totalValue) * 100)
        }
        return 0
    }
    
    var body: some View {
        ScrollView {
            mainContent
                .onAppear {
                    deviceInfo.refreshData()
                }
        }
        .environment(\.layoutDirection, languageManager.isArabic ? .rightToLeft : .leftToRight)
        .onReceive(NotificationCenter.default.publisher(for: .languageChanged)) { _ in
            // Force view refresh when language changes
        }
    }
    

    private var mainContent: some View {
        VStack(spacing: 5) { // spacing: 0 removes vertical space
            // Header with title and upgrade button
            HStack(spacing: 0) {
//                Text("Clean ")
//                    .font(.title2)
//                    .fontWeight(.bold)
//                    .foregroundColor(.black)
//                Text("GURU")
//                    .font(.title2)
//                    .fontWeight(.bold)
//                    .foregroundColor(.blue)
                if languageManager.isArabic {
                               // Arabic: "كلين" (black) + "جورو" (blue)
                               Text("كلين ")
                                   .font(.title2)
                                   .fontWeight(.bold)
                                   .foregroundColor(.black)
                               Text("جورو")
                                   .font(.title2)
                                   .fontWeight(.bold)
                                   .foregroundColor(.blue)
                           } else {
                               // English: "Clean" (black) + "GURU" (blue)
                               Text("Clean ")
                                   .font(.title2)
                                   .fontWeight(.bold)
                                   .foregroundColor(.black)
                               Text("GURU")
                                   .font(.title2)
                                   .fontWeight(.bold)
                                   .foregroundColor(.blue)
                           }
                       }
            
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            
                   .padding(.top, 20)
            .background(Color(hex: "#F2F9FF"))

            // Now this will directly follow the header with no space
            storageAnalyticsHeader

            infoCardsSection
            deviceInfoSection
        }
        .background(Color(.systemGroupedBackground))
        .safeAreaInset(edge: .top, spacing: 0) {
                // This creates proper top spacing
                Color.clear.frame(height: 0)
            }
        .sheet(isPresented: $showSubscription) {
            SubscriptionView()
        }
    }
    
    private var storageAnalyticsHeader: some View {

        VStack {
            LocalizedText("storage_analytics")
                      .font(.title2)
                      .fontWeight(.semibold)
                      .padding(.top)
            VStack {
                GaugeView(
                    percentage: CGFloat(storagePercentage)
                                //isArabic: languageManager.isArabic
                            )
                    .frame(width: 200, height: 200)
                    .environment(\.layoutDirection, .leftToRight)

                HStack(alignment: .firstTextBaseline, spacing: 2) {
                    Text("\(storagePercentage)")
                        .font(.system(size: 25, weight: .bold))
                    
                    Text("/100")
                        .font(.system(size: 15))
                        .foregroundColor(.gray)
                }
                .environment(\.layoutDirection, .leftToRight) 
                .offset(y: -40) // Move up by 20 points
            }                        .padding()
                    
                       // .padding()
                    }
        .frame(maxWidth: .infinity) // 👈 Makes the VStack take full width

        .background(Color(hex: "#F2F9FF")) // ✅ This is the correct place

    }
    
   

    struct CustomInfoCard<Content: View>: View {
        let iconName: String
        let title: String
        let value: String
        let languageManager: LanguageManager
        let content: () -> Content
        
        init(
            iconName: String,
            title: String,
            value: String,
            languageManager: LanguageManager,
            @ViewBuilder content: @escaping () -> Content
        ) {
            self.iconName = iconName
            self.title = title
            self.value = value
            self.languageManager = languageManager
            self.content = content
        }
        
        var body: some View {
            VStack(spacing: 0) {
                // Main row with icon, title, and value
                HStack(spacing: 12) {
                    // Icon without background
                    // Try custom asset first, fallback to SF Symbol
                    if UIImage(named: iconName) != nil {
                        Image(iconName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 26, height: 26)
                    } else {
                        Image(systemName: iconName)
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(.blue)
                            .frame(width: 26, height: 26)
                    }
                    
                    // Title
                    Text(title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    // Value (right-aligned)
                    if !value.isEmpty {
                        Text(value)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.primary)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                
                // Additional content (like Available Space, Used Space, etc.)
                let additionalContent = content()
                if !(additionalContent is EmptyView) {
                    VStack(spacing: 8) {
                        additionalContent
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 12)
                }
            }
        }
    }

    private var infoCardsSection: some View {
        VStack(spacing: 0) {
            // Total Storage
            CustomInfoCard(
                iconName: "storage",
                title: LocalizedStrings.string(for: "total_storage", language: languageManager.currentLanguage),
                value: "\(deviceInfo.totalStorage.0)\(deviceInfo.totalStorage.1)",
                languageManager: languageManager
            ) {
                VStack(alignment: languageManager.isArabic ? .trailing : .leading, spacing: 6) {
                    EnhancedInfoRow(
                        title: LocalizedStrings.string(for: "available_space", language: languageManager.currentLanguage),
                        value: "\(deviceInfo.availableStorage.0)\(deviceInfo.availableStorage.1)",
                        languageManager: languageManager
                    )
                    EnhancedInfoRow(
                        title: LocalizedStrings.string(for: "used_space", language: languageManager.currentLanguage),
                        value: "\(deviceInfo.usedStorage.0)\(deviceInfo.usedStorage.1)",
                        languageManager: languageManager
                    )
                }
            }
            
            Divider()
                .padding(.horizontal, 16)
            
            // Total RAM
            CustomInfoCard(
                iconName: "ram",
                title: LocalizedStrings.string(for: "total_ram", language: languageManager.currentLanguage),
                value: "\(deviceInfo.totalRAM.0)\(deviceInfo.totalRAM.1)",
                languageManager: languageManager
            ) {
                EmptyView()
            }
            
            Divider()
                .padding(.horizontal, 16)
            
            // CPU Information
            CustomInfoCard(
                iconName: "cpu",
                title: LocalizedStrings.string(for: "cpu_information", language: languageManager.currentLanguage),
                value: "",
                languageManager: languageManager
            ) {
                VStack(alignment: languageManager.isArabic ? .trailing : .leading, spacing: 6) {
                    EnhancedInfoRow(
                        title: LocalizedStrings.string(for: "core_count", language: languageManager.currentLanguage),
                        value: "\(deviceInfo.cpuCores) \(LocalizedStrings.string(for: "cores", language: languageManager.currentLanguage))",
                        languageManager: languageManager
                    )
                    EnhancedInfoRow(
                        title: LocalizedStrings.string(for: "architecture", language: languageManager.currentLanguage),
                        value: deviceInfo.architecture,
                        languageManager: languageManager
                    )
                }
            }
            
            Divider()
                .padding(.horizontal, 16)
            
            // Battery Information
            CustomInfoCard(
                iconName: "battery",
                title: LocalizedStrings.string(for: "battery_information", language: languageManager.currentLanguage),
                value: "",
                languageManager: languageManager
            ) {
                VStack(alignment: languageManager.isArabic ? .trailing : .leading, spacing: 6) {
                    EnhancedInfoRow(
                        title: LocalizedStrings.string(for: "battery_percentage", language: languageManager.currentLanguage),
                        value: "\(deviceInfo.batteryPercentage)%",
                        languageManager: languageManager
                    )
                    EnhancedInfoRow(
                        title: LocalizedStrings.string(for: "charging_state", language: languageManager.currentLanguage),
                        value: getLocalizedChargingState(deviceInfo.chargingState),
                        languageManager: languageManager
                    )
                }
            }
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .padding(.horizontal)
        .environment(\.layoutDirection, languageManager.isArabic ? .rightToLeft : .leftToRight)

    }
    
    struct EnhancedInfoRow: View {
        let title: String
        let value: String
        let languageManager: LanguageManager
        
        var body: some View {
            HStack {
                if languageManager.isArabic {
                    // RTL layout
                    Text(title)
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(value)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.primary)
                 
                  
                } else {
                    // LTR layout
                    Text(title)
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(value)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.primary)
                }
            }
        }
    }


    private func getCustomIcon(for type: String) -> String {
        switch type {
        case "storage":
            return "storage"
        case "ram":
            return "ram"
        case "cpu":
            return "cpu"
        case "battery":
            return "battery"
        default:
            return type
        }
    }
    private var deviceInfoSection: some View {
        VStack {
            HStack {
                LocalizedText("device_info")
                    .font(.headline)
                if languageManager.isArabic {
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity, alignment: languageManager.isArabic ? .trailing : .leading)
            .padding(.horizontal)
            
            VStack(spacing: 12) {
                InfoRow(
                    title: LocalizedStrings.string(for: "model", language: languageManager.currentLanguage),
                    value: deviceInfo.deviceModel,
                    languageManager: languageManager
                )
                InfoRow(
                    title: LocalizedStrings.string(for: "os_version", language: languageManager.currentLanguage),
                    value: deviceInfo.osVersion,
                    languageManager: languageManager
                )
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            .padding(.horizontal)
        }
    }
    
    // Helper function to localize charging state
    private func getLocalizedChargingState(_ state: String) -> String {
        switch state.lowercased() {
        case "charging":
            return LocalizedStrings.string(for: "charging", language: languageManager.currentLanguage)
        case "fully charged":
            return LocalizedStrings.string(for: "fully_charged", language: languageManager.currentLanguage)
        case "not charging":
            return LocalizedStrings.string(for: "not_charging", language: languageManager.currentLanguage)
        case "unknown":
            return LocalizedStrings.string(for: "unknown", language: languageManager.currentLanguage)
        default:
            return state
        }
    }
}


struct GaugeView: View {
    let percentage: CGFloat
    
    var body: some View {
        ZStack {
            // Background gray arc
            Circle()
                .trim(from: 0, to: 0.75)
                .stroke(
                    Color.gray.opacity(0.2),
                    style: StrokeStyle(lineWidth: 10, lineCap: .round)
                )
                .rotationEffect(.degrees(135))
            
            // Gradient arc based on percentage
            gradientArc
            
            // Curved tick marks
            tickMarks
            
            // Pointer needle
            pointer
            
            // Center knob
            Circle()
                .fill(Color.black)
                .frame(width: 15, height: 15)
            
            // Value label
//            VStack {
//                Spacer()
//                Text("\(Int(percentage))/100")
//                    .font(.system(size: 24, weight: .bold))
//                    .foregroundColor(colorForPercentage(percentage))
//                    .padding(.top, 160)
//            }
        }
        .frame(width: 200, height: 200)
    }
    
    // MARK: - Gradient Arc
    private var gradientArc: some View {
        Circle()
            .trim(from: 0, to: percentage / 100 * 0.75)
            .stroke(
                AngularGradient(
                    gradient: Gradient(stops: [
                        .init(color: Color.fromHex("#4CAF50"), location: 0.0),     // Green (0-13%)
                        .init(color: Color.fromHex("#8BC34A"), location: 0.125),   // Light Green (13-25%)
                        .init(color: Color.fromHex("#CDDC39"), location: 0.25),    // Lime (25-37%)
                        .init(color: Color.fromHex("#FFEB3B"), location: 0.375),   // Yellow (37-50%)
                        .init(color: Color.fromHex("#FFC107"), location: 0.5),     // Amber (50-62%)
                        .init(color: Color.fromHex("#FF9800"), location: 0.625),   // Orange (62-75%)
                        .init(color: Color.fromHex("#FF5722"), location: 0.7),     // Deep Orange (75-87%)
                        .init(color: Color.fromHex("#F44336"), location: 0.75),    // Red (87-100%)
                        .init(color: Color.fromHex("#4CAF50"), location: 1.0),     // Green (complete circle)
                    ]),
                    center: .center
                ),
                style: StrokeStyle(lineWidth: 10, lineCap: .round)
            )
            .rotationEffect(.degrees(135))
    }
    
    // MARK: - Curved Tick Marks
    private var tickMarks: some View {
        ZStack {
            ForEach(0...20, id: \.self) { i in
                tickMark(at: i)
            }
        }
    }
    
    private func tickMark(at index: Int) -> some View {
        let tickCount = 20
        let angleStart = 135.0
        let angleEnd = 405.0
        let angleStep = (angleEnd - angleStart) / Double(tickCount)
        
        let angle = angleStart + angleStep * Double(index)
        
        let isMajor = index % 5 == 0
        let tickLength: CGFloat = isMajor ? 15 : 10
        let tickWidth: CGFloat = isMajor ? 2 : 1
        
        return Rectangle()
            .fill(Color.black.opacity(0.38))
            .frame(width: tickWidth, height: tickLength)
            .offset(y: -85 + tickLength / 2)
            .rotationEffect(.degrees(90))        // tilt tick rightward along tangent
            .rotationEffect(.degrees(angle))     // position around circle
    }
    private var pointer: some View {
        let angle = 135 + (270 * Double(percentage) / 100) - 270

        return ZStack {
            // Red rectangle pointer
            Rectangle()
                .fill(Color.fromHex("#F44336")) // Fixed red
                .frame(width: 2.5, height: 55)
                .cornerRadius(1.25)
                .offset(y: -27.5) // adjust center due to shorter needle
                .rotationEffect(.degrees(angle))

            // Small black center circle
            Circle()
                .fill(Color.black)
                .frame(width: 14, height: 14)
        }
    }
    // MARK: - Pointer Needle
//    private var pointer: some View {
//        // Nudge angle slightly for better visual alignment
//        let angle = 135 + (270 * Double(percentage) / 100) - 270
//
//        return ZStack {
//            Rectangle()
//                .fill(colorForPercentage(percentage))
//                .frame(width: 2.5, height: 55)
//                .cornerRadius(1.25)
//                .offset(y: -37.5)
//                .rotationEffect(.degrees(angle))
//
//            Circle()
//                .fill(Color.black)
//                .frame(width: 14, height: 14)
//
//            Circle()
//                .fill(colorForPercentage(percentage).opacity(0.8))
//                .frame(width: 6, height: 6)
//        }
//    }
    
    // MARK: - Color based on percentage zones
    private func colorForPercentage(_ percent: CGFloat) -> Color {
        switch percent {
        case 0..<13:
            return Color.fromHex("#4CAF50") // Green
        case 13..<37:
            return Color.fromHex("#8BC34A") // Light Green to Lime
        case 37..<50:
            return Color.fromHex("#FFEB3B") // Yellow
        case 50..<62:
            return Color.fromHex("#FFC107") // Amber
        case 62..<75:
            return Color.fromHex("#FF9800") // Orange
        case 75..<87:
            return Color.fromHex("#FF5722") // Deep Orange
        default:
            return Color.fromHex("#F44336") // Red
        }
    }
}

// MARK: - Color Extension
extension Color {
    static func fromHex(_ hex: String) -> Color {
        let hex = hex.trimmingCharacters(in: .alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8) & 0xFF) / 255
        let b = Double(int & 0xFF) / 255
        
        return Color(.sRGB, red: r, green: g, blue: b)
    }
}


extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
// Updated Info Card Component with Language Support
struct InfoCard<Content: View>: View {
    let icon: String
    let title: String
    let value: String
    let languageManager: LanguageManager
    let content: Content
    
    init(icon: String, title: String, value: String, languageManager: LanguageManager, @ViewBuilder content: () -> Content) {
        self.icon = icon
        self.title = title
        self.value = value
        self.languageManager = languageManager
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: languageManager.isArabic ? .trailing : .leading, spacing: 12) {
            HStack {
                if languageManager.isArabic {
                    // RTL layout
                    if !value.isEmpty {
                        Text(value)
                            .fontWeight(.semibold)
                    }
                    
                    Spacer()
                    
                    Text(title)
                        .fontWeight(.medium)
                    
                    Image(systemName: icon)
                        .foregroundColor(.blue)
                        .frame(width: 24, height: 24)
                } else {
                    // LTR layout
                    Image(systemName: icon)
                        .foregroundColor(.blue)
                        .frame(width: 24, height: 24)
                    
                    Text(title)
                        .fontWeight(.medium)
                    
                    Spacer()
                    
                    if !value.isEmpty {
                        Text(value)
                            .fontWeight(.semibold)
                    }
                }
            }
            
            content
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

// Updated Info Row Component with Language Support
struct InfoRow: View {
    let title: String
    let value: String
    let languageManager: LanguageManager
    
    var body: some View {
        HStack {
            if languageManager.isArabic {
                // RTL layout
//                Text(value)
//                    .fontWeight(.medium)
//                Spacer()
//                Text(title)
//                    .foregroundColor(.gray)
                Text(title)
                    .foregroundColor(.gray)
                Spacer()
                Text(value)
                    .fontWeight(.medium)
            } else {
                // LTR layout
                Text(title)
                    .foregroundColor(.gray)
                Spacer()
                Text(value)
                    .fontWeight(.medium)
            }
        }
    }
}



struct StorageAnalyticsView_Previews: PreviewProvider {
    static var previews: some View {
        StorageAnalyticsView()
    }
}

