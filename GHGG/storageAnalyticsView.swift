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
    
    // Breaking down the view into smaller components
    private var mainContent: some View {
        VStack(spacing: 20) {
            // Header with title and upgrade button
            HStack {
                Text("Clean GURU")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                // Upgrade button commented out but can be uncommented if needed
                // Button(LocalizedStrings.string(for: "upgrade", language: languageManager.currentLanguage)) {
                //     showSubscription = true
                // }
                // .foregroundColor(.orange)
            }
            .padding(.horizontal)
            
            storageAnalyticsHeader
            infoCardsSection
            deviceInfoSection
            Spacer(minLength: 80)
        }
        .padding(.top)
        .background(Color(.systemGroupedBackground))
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
            
            ZStack {
                // Custom gauge
                GaugeView(percentage: CGFloat(storagePercentage))
                    .frame(width: 200, height: 200)
                
                // Percentage text in the middle
                VStack {
                    Text("\(storagePercentage)")
                        .font(.system(size: 36, weight: .bold))
                    Text("/100")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
            }
            .padding()
        }
    }
    
    private var infoCardsSection: some View {
        VStack(spacing: 16) {
            // Total Storage
            InfoCard(
                icon: "doc.fill",
                title: LocalizedStrings.string(for: "total_storage", language: languageManager.currentLanguage),
                value: "\(deviceInfo.totalStorage.0)\(deviceInfo.totalStorage.1)",
                languageManager: languageManager
            ) {
                VStack(alignment: languageManager.isArabic ? .trailing : .leading, spacing: 4) {
                    InfoRow(
                        title: LocalizedStrings.string(for: "available_space", language: languageManager.currentLanguage),
                        value: "\(deviceInfo.availableStorage.0)\(deviceInfo.availableStorage.1)",
                        languageManager: languageManager
                    )
                    InfoRow(
                        title: LocalizedStrings.string(for: "used_space", language: languageManager.currentLanguage),
                        value: "\(deviceInfo.usedStorage.0)\(deviceInfo.usedStorage.1)",
                        languageManager: languageManager
                    )
                }
            }
            
            // Total RAM
            InfoCard(
                icon: "memorychip",
                title: LocalizedStrings.string(for: "total_ram", language: languageManager.currentLanguage),
                value: "\(deviceInfo.totalRAM.0)\(deviceInfo.totalRAM.1)",
                languageManager: languageManager
            ) {
                EmptyView()
            }
            
            // CPU Information
            InfoCard(
                icon: "cpu",
                title: LocalizedStrings.string(for: "cpu_information", language: languageManager.currentLanguage),
                value: "",
                languageManager: languageManager
            ) {
                VStack(alignment: languageManager.isArabic ? .trailing : .leading, spacing: 4) {
                    InfoRow(
                        title: LocalizedStrings.string(for: "core_count", language: languageManager.currentLanguage),
                        value: "\(deviceInfo.cpuCores) \(LocalizedStrings.string(for: "cores", language: languageManager.currentLanguage))",
                        languageManager: languageManager
                    )
                    InfoRow(
                        title: LocalizedStrings.string(for: "architecture", language: languageManager.currentLanguage),
                        value: deviceInfo.architecture,
                        languageManager: languageManager
                    )
                }
            }
            
            // Battery Information
            InfoCard(
                icon: "battery.75",
                title: LocalizedStrings.string(for: "battery_information", language: languageManager.currentLanguage),
                value: "",
                languageManager: languageManager
            ) {
                VStack(alignment: languageManager.isArabic ? .trailing : .leading, spacing: 4) {
                    InfoRow(
                        title: LocalizedStrings.string(for: "battery_percentage", language: languageManager.currentLanguage),
                        value: "\(deviceInfo.batteryPercentage)%",
                        languageManager: languageManager
                    )
                    InfoRow(
                        title: LocalizedStrings.string(for: "charging_state", language: languageManager.currentLanguage),
                        value: getLocalizedChargingState(deviceInfo.chargingState),
                        languageManager: languageManager
                    )
                }
            }
        }
        .padding(.horizontal)
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

// Custom Gauge View - Updated with RTL support
struct GaugeView: View {
    let percentage: CGFloat
    
    var body: some View {
        ZStack {
            backgroundTrack
            progressArc
            tickMarks
        }
    }
    
    // MARK: - Component Views
    
    private var backgroundTrack: some View {
        Circle()
            .stroke(Color.gray.opacity(0.2), style: StrokeStyle(lineWidth: 15, lineCap: .round))
    }
    
    private var progressArc: some View {
        Circle()
            .trim(from: 0, to: percentage / 100)
            .stroke(progressGradient, style: StrokeStyle(lineWidth: 15, lineCap: .round))
            .rotationEffect(.degrees(-90))
    }
    
    private var progressGradient: AngularGradient {
        AngularGradient(
            gradient: Gradient(colors: [.green, .yellow, .orange, .red]),
            center: .center,
            startAngle: .degrees(0),
            endAngle: .degrees(360)
        )
    }
    
    private var tickMarks: some View {
        ForEach(0..<12, id: \.self) { i in
            tickMark(at: i)
        }
    }
    
    private func tickMark(at index: Int) -> some View {
        Rectangle()
            .fill(Color.gray.opacity(0.5))
            .frame(width: 2, height: index % 3 == 0 ? 10 : 5)
            .offset(y: -80)
            .rotationEffect(.degrees(Double(index) * 30))
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
                Text(value)
                    .fontWeight(.medium)
                Spacer()
                Text(title)
                    .foregroundColor(.gray)
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
