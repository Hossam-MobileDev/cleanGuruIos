//
//  storageAnalyticsView.swift
//  GHGG
//
//  Created by test on 11/05/2025.
//

import Foundation
import SwiftUI


struct StorageAnalyticsView: View {
    
    @StateObject private var deviceInfo = DeviceInfoManager()
    
    // Calculate storage usage percentage
    var storagePercentage: Int {
        let total = deviceInfo.totalStorage.0
        let used = deviceInfo.usedStorage.0
        if total > 0 {
            return Int(Double(used) / Double(total) * 100)
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
//                Button("Upgrade") {
//                    // Upgrade action
//                }
                .foregroundColor(.orange)
            }
            .padding(.horizontal)
            
            storageAnalyticsHeader
            infoCardsSection
            deviceInfoSection
            Spacer(minLength: 80)
        }
        .padding(.top)
        .background(Color(.systemGroupedBackground))
    }
    
    private var storageAnalyticsHeader: some View {
        VStack {
            Text("Storage Analytics")
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
            InfoCard(icon: "doc.fill", title: "Total Storage", value: "\(deviceInfo.totalStorage.0)\(deviceInfo.totalStorage.1)") {
                VStack(alignment: .leading, spacing: 4) {
                    InfoRow(title: "Available Space", value: "\(deviceInfo.availableStorage.0)\(deviceInfo.availableStorage.1)")
                    InfoRow(title: "Used Space", value: "\(deviceInfo.usedStorage.0)\(deviceInfo.usedStorage.1)")
                }
            }
            
            // Total RAM
            InfoCard(icon: "memorychip", title: "Total RAM", value: "\(deviceInfo.totalRAM.0)\(deviceInfo.totalRAM.1)") {
                EmptyView()
            }
            
            // CPU Information
            InfoCard(icon: "cpu", title: "CPU Information", value: "") {
                VStack(alignment: .leading, spacing: 4) {
                    InfoRow(title: "Core Count", value: "\(deviceInfo.cpuCores) cores")
                    InfoRow(title: "Architecture", value: deviceInfo.architecture)
                }
            }
            
            // Battery Information
            InfoCard(icon: "battery.75", title: "Battery Information", value: "") {
                VStack(alignment: .leading, spacing: 4) {
                    InfoRow(title: "Battery Percentage", value: "\(deviceInfo.batteryPercentage)%")
                    InfoRow(title: "Charging State", value: deviceInfo.chargingState)
                }
            }
        }
        .padding(.horizontal)
    }
    
    private var deviceInfoSection: some View {
        VStack {
            Text("Device Info")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            VStack(spacing: 12) {
                InfoRow(title: "Model", value: deviceInfo.deviceModel)
                InfoRow(title: "OS Version", value: deviceInfo.osVersion)
            }
            
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            .padding(.horizontal)
        }
    }
    
}

// Custom Gauge View
//struct GaugeView: View {
//    let percentage: CGFloat
//    
//    var body: some View {
//        ZStack {
//            backgroundTrack
//            progressArc
//            tickMarks
//            needle
//            centerCircle
//        }
//    }
//    
//    // MARK: - Component Views
//    
//    private var backgroundTrack: some View {
//        Circle()
//            .stroke(Color.gray.opacity(0.2), style: StrokeStyle(lineWidth: 15, lineCap: .round))
//    }
//    
//    private var progressArc: some View {
//        Circle()
//            .trim(from: 0, to: percentage / 100)
//            .stroke(progressGradient, style: StrokeStyle(lineWidth: 15, lineCap: .round))
//            .rotationEffect(.degrees(-90))
//    }
//    
//    private var progressGradient: AngularGradient {
//        AngularGradient(
//            gradient: Gradient(colors: [.green, .yellow, .orange, .red]),
//            center: .center,
//            startAngle: .degrees(0),
//            endAngle: .degrees(360)
//        )
//    }
//    
//    private var tickMarks: some View {
//        ForEach(0..<12, id: \.self) { i in
//            tickMark(at: i)
//        }
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
//    private var needle: some View {
//        Rectangle()
//            .fill(Color.black)
//            .frame(width: 2, height: 70)
//            .offset(y: -35)
//            .rotationEffect(.degrees(Double(percentage) * 3.6 - 90.0))
//    }
//    
//    private var centerCircle: some View {
//        Circle()
//            .fill(Color.black)
//            .frame(width: 15, height: 15)
//    }
//}

struct GaugeView: View {
    let percentage: CGFloat
    
    var body: some View {
        ZStack {
            backgroundTrack
            progressArc
            tickMarks
            // needle and centerCircle removed
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
    
    // needle property removed
    // centerCircle property removed
}
// Reusable Info Card Component
struct InfoCard<Content: View>: View {
    let icon: String
    let title: String
    let value: String
    let content: Content
    
    init(icon: String, title: String, value: String, @ViewBuilder content: () -> Content) {
        self.icon = icon
        self.title = title
        self.value = value
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
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
            
            content
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

// Reusable Info Row Component
struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
    }
}

struct StorageAnalyticsView_Previews: PreviewProvider {
    static var previews: some View {
        StorageAnalyticsView()
    }
}
