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
    
//    private var mainContent: some View {
//        VStack {
//            // Header with title and upgrade button
//           // Color(hex: "F2F9FF")
//            HStack {
//                HStack(spacing: 0) {
//                    Text("Clean ")
//                        .font(.title2)
//                        .fontWeight(.bold)
//                        .foregroundColor(.black)
//                    Text("GURU")
//                        .font(.title2)
//                        .fontWeight(.bold)
//                        .foregroundColor(.blue)
//                }
//                Spacer()
//                // Upgrade button commented out but can be uncommented if needed
//                // Button(LocalizedStrings.string(for: "upgrade", language: languageManager.currentLanguage)) {
//                //     showSubscription = true
//                // }
//                // .foregroundColor(.orange)
//            }
//            
//            .padding()
//            .background(Color(hex: "F2F9FF"))
//            storageAnalyticsHeader
//            infoCardsSection
//            deviceInfoSection
//           // Spacer(minLength: 80)
//        }
//        //.padding(.top)
//        .background(Color(.systemGroupedBackground))
//        .sheet(isPresented: $showSubscription) {
//            SubscriptionView()
//        }
//    }
//    
    private var mainContent: some View {
        VStack(spacing: 5) { // spacing: 0 removes vertical space
            // Header with title and upgrade button
            HStack(spacing: 0) {
                Text("Clean ")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                Text("GURU")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
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
//
//                HStack(spacing: 0) {
////                    Text("\(storagePercentage)")
////                        .font(.system(size: 36, weight: .bold))
////                    Text("/100")
////                        .font(.system(size: 20))
////                        .foregroundColor(.gray)
//                    Text(verbatim: "\(storagePercentage)/100")
//                        .font(.system(size: 36, weight: .bold))
//                        .foregroundStyle(
//                            Text("\(storagePercentage)", style: .init(size: 36, weight: .bold)) +
//                            Text("/100", style: .init(size: 20, weight: .regular)).foregroundColor(.gray)
//                        )
//                }
                HStack(alignment: .firstTextBaseline, spacing: 2) {
                    Text("\(storagePercentage)")
                        .font(.system(size: 36, weight: .bold))
                    
                    Text("/100")
                        .font(.system(size: 20))
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

//struct GaugeView: View {
//    let percentage: CGFloat
//    
//    var body: some View {
//        ZStack {
//            backgroundTrack
//            progressArc
//            tickMarks
//            redPointer
//        }
//        .background(Color.clear)
//    }
//    
//    // MARK: - Background Track
//    private var backgroundTrack: some View {
//        Circle()
//            .trim(from: 0, to: 0.8)
//            .stroke(Color.gray.opacity(0.3), style: StrokeStyle(lineWidth: 15, lineCap: .round))
//            .rotationEffect(.degrees(126))
//    }
//    
//    private var progressArc: some View {
//        Circle()
//            .trim(from: 0, to: (percentage / 100) * 0.8)
//            .stroke(progressGradient, style: StrokeStyle(lineWidth: 15, lineCap: .round))
//            .rotationEffect(.degrees(126))
//    }
//    
//    // Fixed gradient implementation
//    private var progressGradient: AngularGradient {
//        let colors = cumulativeColors
//        let endAngle = 126 + (288 * Double(percentage) / 100)
//        
//        return AngularGradient(
//            gradient: Gradient(colors: colors),
//            center: .center,
//            startAngle: .degrees(126),
//            endAngle: .degrees(endAngle)
//        )
//    }
//    
//    private var cumulativeColors: [Color] {
//        var colors: [Color] = []
//        
//        // 0-10%: Green only
//        if percentage > 0 {
//            colors.append(Color(red: 0.2, green: 0.8, blue: 0.3)) // 🟢 Green
//        }
//        
//        // 10-20%: Green + Light Green
//        if percentage >= 10 {
//            colors.append(Color(red: 0.5, green: 0.9, blue: 0.4)) // 🟢 Light Green
//        }
//        
//        // 20-30%: Green + Light Green + Yellow
//        if percentage >= 20 {
//            colors.append(Color(red: 0.9, green: 0.9, blue: 0.2)) // 🟡 Yellow
//        }
//        
//        // 30-40%: Green + Light Green + Yellow + Light Orange
//        if percentage >= 30 {
//            colors.append(Color(red: 1.0, green: 0.7, blue: 0.2)) // 🟠 Light Orange
//        }
//        
//        // 40-50%: Green + Light Green + Yellow + Light Orange + Dark Orange
//        if percentage >= 40 {
//            let hexStrings = [
//                    "#33CC66", // Green
//                    "#FFA61A", // Dark Orange
//                    "#EAEA33", // Yellow
//                    "#FFB733", // Light Orange
//                    "#FF3322"  // Red
//                ]
//
//                for hex in hexStrings {
//                    colors.append(Color.fromHex(hex))
//                }
//            
//        }
//        
//        // 50-60%: Green + Light Green + Yellow + Light Orange + Dark Orange + Red
//        if percentage >= 50 {
//            colors.append(Color(red: 1.0, green: 0.2, blue: 0.1)) // 🔴 Red
//        }
//        
//        // Ensure we have at least one color
//        if colors.isEmpty {
//            colors.append(Color.gray.opacity(0.3))
//        }
//        
//        return colors
//    }
//    
//    private var tickMarks: some View {
//        ForEach(0..<12, id: \.self) { i in
//            if shouldShowTickMark(at: i) {
//                tickMark(at: i)
//            }
//        }
//    }
//    
//    private func shouldShowTickMark(at index: Int) -> Bool {
//        let angle = Double(index) * 30
//        return !(angle >= 144 && angle <= 216)
//    }
//    
//    private func tickMark(at index: Int) -> some View {
//        Rectangle()
//            .fill(Color.gray.opacity(0.5))
//            .frame(width: 2, height: index % 3 == 0 ? 10 : 5)
//            .offset(y: -80)
//            .rotationEffect(.degrees(Double(index) * 30))
//    }
//    
//    private var redPointer: some View {
//        ZStack {
//            Rectangle()
//                .fill(Color.red)
//                .frame(width: 3, height: 60)
//                .offset(y: -30)
//                .rotationEffect(.degrees(pointerAngle))
//            
//            Circle()
//                .fill(Color.red)
//                .frame(width: 12, height: 12)
//        }
//    }
//    
//    private var pointerAngle: Double {
//        126 + (Double(percentage) / 100.0) * 288
//    }
//}
//
//extension Color {
//    static func fromHex(_ hex: String) -> Color {
//        let hex = hex.trimmingCharacters(in: .alphanumerics.inverted)
//        var int: UInt64 = 0
//        Scanner(string: hex).scanHexInt64(&int)
//
//        let r = Double((int >> 16) & 0xFF) / 255
//        let g = Double((int >> 8) & 0xFF) / 255
//        let b = Double(int & 0xFF) / 255
//
//        return Color(.sRGB, red: r, green: g, blue: b)
//    }
//}
//// MARK: - Preview
//struct GaugeView_Previews: PreviewProvider {
//    static var previews: some View {
//        VStack(spacing: 30) {
//            GaugeView(percentage: 10)
//                .frame(width: 200, height: 200)
//            
//            GaugeView(percentage: 35)
//                .frame(width: 200, height: 200)
//            
//            GaugeView(percentage: 65)
//                .frame(width: 200, height: 200)
//        }
//        .padding()
//    }
//}


//struct GaugeView: View {
//    let percentage: CGFloat
//
//    var body: some View {
//        ZStack {
//            backgroundTrack
//            progressArc
//            tickMarks
//            redPointer
//        }
//        .background(Color.clear)
//    }
//
//    // MARK: - Background Track (gray base arc)
//    private var backgroundTrack: some View {
//        Circle()
//            .trim(from: 0, to: 0.8)
//            .stroke(Color.gray.opacity(0.3), style: StrokeStyle(lineWidth: 15, lineCap: .butt))
//            .rotationEffect(.degrees(126))
//    }
//
//    // MARK: - Colored Arc Segments
//    private var progressArc: some View {
//        let segmentTrimSize: CGFloat = 0.2
//        let totalTrim = (percentage / 100) * 0.8
//        let totalSegments = Int(ceil(totalTrim / segmentTrimSize))
//
//        return ZStack {
//            ForEach(0..<totalSegments, id: \.self) { index in
//                let startTrim = CGFloat(index) * segmentTrimSize
//                let endTrim = min(startTrim + segmentTrimSize, totalTrim)
//
//                Circle()
//                    .trim(from: startTrim, to: endTrim)
//                    .stroke(segmentColor(for: index), style: StrokeStyle(lineWidth: 15, lineCap: .butt))
//                    .rotationEffect(.degrees(126))
//            }
//        }
//    }
//
//    // MARK: - Segment Colors by Index
//    private func segmentColor(for index: Int) -> Color {
//        let colors = [
//            Color.fromHex("#33CC66"), // Green
//            Color.fromHex("#99CC33"), // Light Green
//            Color.fromHex("#EAEA33"), // Yellow
//            Color.fromHex("#FFA61A"), // Orange
//            Color.fromHex("#FF3322")  // Red
//        ]
//        return colors[safe: index] ?? .gray
//    }
//
//    // MARK: - Red Pointer
//    private var redPointer: some View {
//        ZStack {
//            Rectangle()
//                .fill(Color.red)
//                .frame(width: 4, height: 70)
//                .offset(y: -35)
//                .rotationEffect(.degrees(pointerAngle))
//
//            Circle()
//                .fill(Color.red)
//                .frame(width: 12, height: 12)
//        }
//    }
//
//    private var pointerAngle: Double {
//        126 + (Double(percentage) / 100.0) * 288
//    }
//
//    // MARK: - Tick Marks
//    private var tickMarks: some View {
//        ForEach(0..<12, id: \.self) { i in
//            if shouldShowTickMark(at: i) {
//                tickMark(at: i)
//            }
//        }
//    }
//
//    private func shouldShowTickMark(at index: Int) -> Bool {
//        let angle = Double(index) * 30
//        return !(angle >= 144 && angle <= 216)
//    }
//
//    private func tickMark(at index: Int) -> some View {
//        Rectangle()
//            .fill(Color.gray.opacity(0.5))
//            .frame(width: 2, height: index % 3 == 0 ? 10 : 5)
//            .offset(y: -80)
//            .rotationEffect(.degrees(Double(index) * 30))
//    }
//}

//struct GaugeView: View {
//    let percentage: CGFloat
//
//    var body: some View {
//        ZStack {
//            backgroundTrack
//            progressArc
//            tickMarks
//            redPointer
//        }
//        .background(Color.clear)
//    }
//
//    // MARK: - Background Track
//    private var backgroundTrack: some View {
//        Circle()
//            .trim(from: 0, to: 0.8)
//            .stroke(Color.gray.opacity(0.3), style: StrokeStyle(lineWidth: 15, lineCap: .butt))
//            .rotationEffect(.degrees(126))
//    }
//
//    // MARK: - Progress Arc with Colored Segments
//    private var progressArc: some View {
//        let segmentTrimSize: CGFloat = 0.2
//        let totalTrim = (percentage / 100) * 0.8
//        let totalSegments = Int(ceil(totalTrim / segmentTrimSize))
//
//        return ZStack {
//            ForEach(0..<totalSegments, id: \.self) { index in
//                let startTrim = CGFloat(index) * segmentTrimSize
//                let endTrim = min(startTrim + segmentTrimSize, totalTrim)
//
//                Circle()
//                    .trim(from: startTrim, to: endTrim)
//                    .stroke(segmentColor(for: index), style: StrokeStyle(lineWidth: 15, lineCap: .butt))
//                    .rotationEffect(.degrees(126))
//            }
//        }
//    }
//
//    // MARK: - Segment Colors
//    private func segmentColor(for index: Int) -> Color {
//        let colors = [
//            Color.fromHex("#33CC66"), // Green
//            Color.fromHex("#99CC33"), // Light Green
//            Color.fromHex("#EAEA33"), // Yellow
//            Color.fromHex("#FFA61A"), // Orange
//            Color.fromHex("#FF3322")  // Red
//        ]
//        return colors[safe: index] ?? .gray
//    }
//
//    // MARK: - Red Pointer
//    private var redPointer: some View {
//        ZStack {
//            Rectangle()
//                .fill(Color.red)
//                .frame(width: 4, height: 70)
//                .offset(y: -35)
//                .rotationEffect(.degrees(pointerToLastSegmentAngle))
//
//            Circle()
//                .fill(Color.red)
//                .frame(width: 12, height: 12)
//        }
//    }
//
//    private var pointerToLastSegmentAngle: Double {
//        let segmentTrimSize: CGFloat = 0.2
//        let totalTrim = (percentage / 100) * 0.8
//        let totalSegments = Int(ceil(totalTrim / segmentTrimSize))
//
//        if totalSegments == 0 {
//            return 126 // default
//        }
//
//        let lastIndex = totalSegments - 1
//        let startTrim = CGFloat(lastIndex) * segmentTrimSize
//        let endTrim = min(startTrim + segmentTrimSize, totalTrim)
//        let centerTrim = (startTrim + endTrim) / 2
//
//        let degrees = centerTrim * 360
//        return 126 + Double(degrees)
//    }
//
//    // MARK: - Tick Marks
//    private var tickMarks: some View {
//        ForEach(0..<12, id: \.self) { i in
//            if shouldShowTickMark(at: i) {
//                tickMark(at: i)
//            }
//        }
//    }
//
//    private func shouldShowTickMark(at index: Int) -> Bool {
//        let angle = Double(index) * 30
//        return !(angle >= 144 && angle <= 216)
//    }
//
//    private func tickMark(at index: Int) -> some View {
//        Rectangle()
//            .fill(Color.gray.opacity(0.5))
//            .frame(width: 2, height: index % 3 == 0 ? 10 : 5)
//            .offset(y: -80)
//            .rotationEffect(.degrees(Double(index) * 30))
//    }
//}
//struct GaugeView: View {
//    let percentage: CGFloat
//
//    var body: some View {
//        ZStack {
//            backgroundTrack
//            progressArc
//            tickMarks
//            redPointer
//        }
//        .background(Color.clear)
//    }
//
//    // MARK: - Background Track (gray base arc)
//    private var backgroundTrack: some View {
//        Circle()
//            .trim(from: 0, to: 0.8)
//            .stroke(Color.gray.opacity(0.3), style: StrokeStyle(lineWidth: 15, lineCap: .butt))
//            .rotationEffect(.degrees(126))
//    }
//
//    // MARK: - Colored Arc Segments
//    private var progressArc: some View {
//        let segmentTrimSize: CGFloat = 0.2
//        let totalTrim = (percentage / 100) * 0.8
//        let totalSegments = Int(ceil(totalTrim / segmentTrimSize))
//
//        return ZStack {
//            ForEach(0..<totalSegments, id: \.self) { index in
//                let startTrim = CGFloat(index) * segmentTrimSize
//                let endTrim = min(startTrim + segmentTrimSize, totalTrim)
//
//                Circle()
//                    .trim(from: startTrim, to: endTrim)
//                    .stroke(segmentColor(for: index), style: StrokeStyle(lineWidth: 15, lineCap: .butt))
//                    .rotationEffect(.degrees(126))
//            }
//        }
//    }
//
//    // MARK: - Segment Colors by Index
//    private func segmentColor(for index: Int) -> Color {
//        let colors = [
//            Color.fromHex("#33CC66"), // Green
//            Color.fromHex("#99CC33"), // Light Green
//            Color.fromHex("#EAEA33"), // Yellow
//            Color.fromHex("#FFA61A"), // Orange
//            Color.fromHex("#FF3322")  // Red
//        ]
//        return colors[safe: index] ?? .gray
//    }
//
//    // MARK: - Red Pointer
//    private var redPointer: some View {
//        ZStack {
//            Rectangle()
//                .fill(Color.red)
//                .frame(width: 4, height: 70)
//                .offset(y: -35)
//                .rotationEffect(.degrees(pointerAngleForRange))
//
//            Circle()
//                .fill(Color.red)
//                .frame(width: 12, height: 12)
//        }
//    }
//
//    /// MARK: - Fixed Range Angles
//    private var pointerAngleForRange: Double {
//        // Define center angle for each range segment
//        switch percentage {
//        case 0..<20:
//            return centerAngle(forTrimMid: 0.1) // Green
//        case 20..<40:
//            return centerAngle(forTrimMid: 0.3) // Light Green
//        case 40..<60:
//            return centerAngle(forTrimMid: 0.5) // Yellow
//        case 60..<80:
//            return centerAngle(forTrimMid: 0.7) // Orange
//        default:
//            return centerAngle(forTrimMid: 0.8) // Red or default to end
//        }
//    }
//
//    private func centerAngle(forTrimMid trim: CGFloat) -> Double {
//        return 126 + (Double(trim) * 360)
//    }
//
//    // MARK: - Tick Marks
//    private var tickMarks: some View {
//        ForEach(0..<12, id: \.self) { i in
//            if shouldShowTickMark(at: i) {
//                tickMark(at: i)
//            }
//        }
//    }
//
//    private func shouldShowTickMark(at index: Int) -> Bool {
//        let angle = Double(index) * 30
//        return !(angle >= 144 && angle <= 216)
//    }
//
//    private func tickMark(at index: Int) -> some View {
//        Rectangle()
//            .fill(Color.gray.opacity(0.5))
//            .frame(width: 2, height: index % 3 == 0 ? 10 : 5)
//            .offset(y: -80)
//            .rotationEffect(.degrees(Double(index) * 30))
//    }
//}
struct GaugeView: View {
    let percentage: CGFloat

    var body: some View {
        ZStack {
           // Color(hex: "#F2F9FF")

            backgroundTrack
            progressArc
            tickMarks
            redPointer
        }
        .background(Color.clear)
       
     

    }

    // MARK: - Background Track (gray base arc)
    private var backgroundTrack: some View {
        Circle()
            .trim(from: 0, to: 0.8)
            .stroke(Color.gray.opacity(0.3), style: StrokeStyle(lineWidth: 10, lineCap: .butt))
            .rotationEffect(.degrees(126))
    }

    // MARK: - Colored Arc Segments
    private var progressArc: some View {
        let segmentTrimSize: CGFloat = 0.2
        let totalTrim = (percentage / 100) * 0.8
        let totalSegments = Int(ceil(totalTrim / segmentTrimSize))

        return ZStack {
            ForEach(0..<totalSegments, id: \.self) { index in
                let startTrim = CGFloat(index) * segmentTrimSize
                let endTrim = min(startTrim + segmentTrimSize, totalTrim)

                Circle()
                    .trim(from: startTrim, to: endTrim)
                    .stroke(segmentColor(for: index), style: StrokeStyle(lineWidth: 10, lineCap: .butt))
                    .rotationEffect(.degrees(126))
            }
        }
    }

    // MARK: - Segment Colors by Index
    private func segmentColor(for index: Int) -> Color {
        let colors = [
            Color.fromHex("#33CC66"), // Green
            Color.fromHex("#99CC33"), // Light Green
            Color.fromHex("#EAEA33"), // Yellow
            Color.fromHex("#FFA61A"), // Orange
            Color.fromHex("#FF3322")  // Red
        ]
        return colors[safe: index] ?? .gray
    }

    // MARK: - Red Pointer (shorter and black base circle)
    private var redPointer: some View {
        ZStack {
            Rectangle()
                .fill(Color.red)
                .frame(width: 3, height: 50) // shorter needle
                .offset(y: -25)
                .rotationEffect(.degrees(pointerAngleForRange))

            Circle()
                .fill(Color.black) // changed to black
                .frame(width: 12, height: 12)
        }
    }

    /// MARK: - Fixed Range Angles for Pointer
//    private var pointerAngleForRange: Double {
//        switch percentage {
//        case 0..<20:
//            return centerAngle(forTrimMid: 0.1) // Green
//        case 20..<40:
//            return centerAngle(forTrimMid: 0.3) // Light Green
//        case 40..<60:
//            return centerAngle(forTrimMid: 0.5) // Yellow
//        case 60..<80:
//            return centerAngle(forTrimMid: 0.7) // Orange
//        default:
//            return centerAngle(forTrimMid: 0.9) // Red
//        }
//    }

    private var pointerAngleForRange: Double {
        let gaugeStartAngle = 126.0
          let gaugeSweepAngle = 400.0 // 0.8 * 360
          return gaugeStartAngle + (gaugeSweepAngle * Double(percentage / 100))
    }
    
    private func centerAngle(forTrimMid trim: CGFloat) -> Double {
        return 126 + (Double(trim) * 360)
    }

    // MARK: - Tick Marks
    private var tickMarks: some View {
        ForEach(0..<12, id: \.self) { i in
            if shouldShowTickMark(at: i) {
                tickMark(at: i)
            }
        }
    }

    private func shouldShowTickMark(at index: Int) -> Bool {
        let angle = Double(index) * 30
        return !(angle >= 144 && angle <= 216)
    }

    private func tickMark(at index: Int) -> some View {
        Rectangle()
            .fill(Color.gray.opacity(0.5))
            .frame(width: 2, height: index % 3 == 0 ? 10 : 5)
            .offset(y: -80)
            .rotationEffect(.degrees(Double(index) * 30))
    }
}

//struct GaugeView: View {
//    let percentage: CGFloat
//    let isArabic: Bool
//    
//    var body: some View {
//        ZStack {
//            backgroundTrack
//            progressArc
//            tickMarks
//            redPointer
//        }
//        .background(Color.clear)
//        .environment(\.layoutDirection, isArabic ? .rightToLeft : .leftToRight)
//    }
//
//    // MARK: - Background Track (gray base arc)
//    private var backgroundTrack: some View {
//        Circle()
//            .trim(from: 0, to: 0.8)
//            .stroke(Color.gray.opacity(0.3), style: StrokeStyle(lineWidth: 10, lineCap: .butt))
//            .rotationEffect(.degrees(isArabic ? 126 : 126)) // Mirror for Arabic
//    }
//
//    // MARK: - Colored Arc Segments
//    private var progressArc: some View {
//        let segmentTrimSize: CGFloat = 0.2
//        let totalTrim = (percentage / 100) * 0.8
//        let totalSegments = Int(ceil(totalTrim / segmentTrimSize))
//
//        return ZStack {
//            ForEach(0..<totalSegments, id: \.self) { index in
//                let startTrim = CGFloat(index) * segmentTrimSize
//                let endTrim = min(startTrim + segmentTrimSize, totalTrim)
//
//                Circle()
//                    .trim(from: startTrim, to: endTrim)
//                    .stroke(segmentColor(for: index), style: StrokeStyle(lineWidth: 10, lineCap: .butt))
//                    .rotationEffect(.degrees(isArabic ? 126 : 126)) // Mirror for Arabic
//            }
//        }
//    }
//
//    // MARK: - Segment Colors by Index
//    private func segmentColor(for index: Int) -> Color {
//        let colors = [
//            Color.fromHex("#33CC66"), // Green
//            Color.fromHex("#99CC33"), // Light Green
//            Color.fromHex("#EAEA33"), // Yellow
//            Color.fromHex("#FFA61A"), // Orange
//            Color.fromHex("#FF3322")  // Red
//        ]
//        return colors[safe: index] ?? .gray
//    }
//
//    // MARK: - Red Pointer (adjusts for Arabic)
//    private var redPointer: some View {
//        ZStack {
//            Rectangle()
//                .fill(Color.red)
//                .frame(width: 3, height: 50)
//                .offset(y: -25)
//                .rotationEffect(.degrees(pointerAngleForRange))
//
//            Circle()
//                .fill(Color.black)
//                .frame(width: 12, height: 12)
//        }
//    }
//
//    // MARK: - Fixed Range Angles for Pointer
//    private var pointerAngleForRange: Double {
//        let baseAngle: Double
//        
//        switch percentage {
//        case 0..<20:
//            baseAngle = centerAngle(forTrimMid: 0.1) // Green
//        case 20..<40:
//            baseAngle = centerAngle(forTrimMid: 0.3) // Light Green
//        case 40..<60:
//            baseAngle = centerAngle(forTrimMid: 0.5) // Yellow
//        case 60..<80:
//            baseAngle = centerAngle(forTrimMid: 0.7) // Orange
//        default:
//            baseAngle = centerAngle(forTrimMid: 0.9) // Red
//        }
//        
//        return baseAngle
//    }
//
//    private func centerAngle(forTrimMid trim: CGFloat) -> Double {
//        let baseRotation = isArabic ? 54.0 : 126.0 // Different base for Arabic
//        return baseRotation + (Double(trim) * 360)
//    }
//
//    // MARK: - Tick Marks
//    private var tickMarks: some View {
//        ForEach(0..<12, id: \.self) { i in
//            if shouldShowTickMark(at: i) {
//                tickMark(at: i)
//            }
//        }
//    }
//
//    private func shouldShowTickMark(at index: Int) -> Bool {
//        let angle = Double(index) * 30
//        return !(angle >= 144 && angle <= 216)
//    }
//
//    private func tickMark(at index: Int) -> some View {
//        Rectangle()
//            .fill(Color.gray.opacity(0.5))
//            .frame(width: 2, height: index % 3 == 0 ? 10 : 5)
//            .offset(y: -80)
//            .rotationEffect(.degrees(Double(index) * 30))
//    }
//}
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

