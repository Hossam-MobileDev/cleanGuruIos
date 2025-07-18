//
//  deviceInfomanager.swift
//  GHGG
//
//  Created by test on 11/05/2025.
//

import Foundation
import UIKit



//class DeviceInfoManager: ObservableObject {
//    @Published var totalStorage: (Int, String) = (0, "")
//    @Published var availableStorage: (Int, String) = (0, "")
//    @Published var usedStorage: (Int, String) = (0, "")
//    @Published var totalRAM: (Int, String) = (0, "")
//    @Published var cpuCores: Int = 0
//    @Published var architecture: String = ""
//    @Published var batteryPercentage: Int = 0
//    @Published var chargingState: String = ""
//    @Published var deviceModel: String = ""
//    @Published var osVersion: String = ""
//    
//    init() {
//        fetchStorageInfo()
//        fetchRAMInfo()
//        fetchCPUInfo()
//        fetchBatteryInfo()
//        fetchDeviceInfo()
//    }
//    
//    // Get storage information
//    private func fetchStorageInfo() {
//        let fileManager = FileManager.default
//        do {
//            if let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
//                let attributes = try fileManager.attributesOfFileSystem(forPath: documentDirectory.path)
//                
//                if let totalSize = attributes[.systemSize] as? NSNumber,
//                   let freeSize = attributes[.systemFreeSize] as? NSNumber {
//                    
//                    let total = totalSize.int64Value
//                    let free = freeSize.int64Value
//                    let used = total - free
//                    
//                    totalStorage = formatByteSize(total)
//                    availableStorage = formatByteSize(free)
//                    usedStorage = formatByteSize(used)
//                }
//            }
//        } catch {
//            print("Error getting storage info: \(error)")
//        }
//    }
//    
//    // Format byte size to human-readable format using decimal calculation to match manufacturer specs
//    private func formatByteSize(_ bytes: Int64) -> (Int, String) {
//        // Use decimal calculation (1000^3) to match manufacturer specifications (64GB, 128GB, etc.)
//        let gigabyte = Int64(1000 * 1000 * 1000) // Decimal calculation (1000^3)
//        let gigabyteValue = Double(bytes) / Double(gigabyte)
//        
//        // Round to nearest integer for display
//        let roundedGB = Int(round(gigabyteValue))
//        let unit = "GB"
//        
//        return (roundedGB, unit)
//    }
//    
//    // Alternative method that shows more precise storage calculation
//    private func formatByteSizePrecise(_ bytes: Int64) -> (Int, String) {
//        let gigabyte = Int64(1024 * 1024 * 1024) // Binary calculation
//        
//        // For devices like 64GB, manufacturers use decimal (1000^3) but OS uses binary (1024^3)
//        // To match the marketed capacity, you might want to use decimal for display
//        let decimalGigabyte = Int64(1000 * 1000 * 1000)
//        
//        // Use decimal calculation to match manufacturer specs
//        let gigabyteValue = Double(bytes) / Double(decimalGigabyte)
//        let roundedGB = Int(round(gigabyteValue))
//        
//        return (roundedGB, "GB")
//    }
//    
//    // Get RAM information
//    private func fetchRAMInfo() {
//        let totalMemory = ProcessInfo.processInfo.physicalMemory
//        // Use binary calculation for RAM as well
//        totalRAM = (Int(totalMemory / UInt64(1024 * 1024 * 1024)), "GB")
//    }
//    
//    // Get CPU information
//    private func fetchCPUInfo() {
//        cpuCores = ProcessInfo.processInfo.processorCount
//        
//        #if arch(arm64)
//        architecture = "ARM64"
//        #elseif arch(x86_64)
//        architecture = "x86_64"
//        #else
//        architecture = "Unknown"
//        #endif
//    }
//    
//    // Get battery information
//    private func fetchBatteryInfo() {
//        // Enable battery monitoring
//        UIDevice.current.isBatteryMonitoringEnabled = true
//        
//        // Get battery level
//        let batteryLevel = UIDevice.current.batteryLevel
//        batteryPercentage = batteryLevel < 0 ? 0 : Int(batteryLevel * 100)
//        
//        // Get charging state
//        switch UIDevice.current.batteryState {
//        case .charging:
//            chargingState = "Charging"
//        case .full:
//            chargingState = "Fully Charged"
//        case .unplugged:
//            chargingState = "Not Charging"
//        case .unknown:
//            chargingState = "Unknown"
//        @unknown default:
//            chargingState = "Unknown"
//        }
//    }
//    
//    // Get device information
//    private func fetchDeviceInfo() {
//        let device = UIDevice.current
//        deviceModel = getDeviceModel()
//        osVersion = "\(device.systemName) \(device.systemVersion)"
//    }
//    
//    // Get detailed device model
//    private func getDeviceModel() -> String {
//        var systemInfo = utsname()
//        uname(&systemInfo)
//        let machineMirror = Mirror(reflecting: systemInfo.machine)
//        let identifier = machineMirror.children.reduce("") { identifier, element in
//            guard let value = element.value as? Int8, value != 0 else { return identifier }
//            return identifier + String(UnicodeScalar(UInt8(value)))
//        }
//        
//        // Map common identifiers to marketing names (verified mappings)
//        switch identifier {
//        // iPhone 8 series
//        case "iPhone10,1", "iPhone10,4": return "iPhone 8"
//        case "iPhone10,2", "iPhone10,5": return "iPhone 8 Plus"
//        case "iPhone10,3", "iPhone10,6": return "iPhone X"
//        
//        // iPhone XR, XS series
//        case "iPhone11,2": return "iPhone XS"
//        case "iPhone11,4", "iPhone11,6": return "iPhone XS Max"
//        case "iPhone11,8": return "iPhone XR"
//        
//        // iPhone 11 series
//        case "iPhone12,1": return "iPhone 11"
//        case "iPhone12,3": return "iPhone 11 Pro"
//        case "iPhone12,5": return "iPhone 11 Pro Max"
//        case "iPhone12,8": return "iPhone SE (2nd gen)"
//        
//        // iPhone 12 series
//        case "iPhone13,1": return "iPhone 12 mini"
//        case "iPhone13,2": return "iPhone 12"
//        case "iPhone13,3": return "iPhone 12 Pro"
//        case "iPhone13,4": return "iPhone 12 Pro Max"
//        
//        // iPhone 13 series
//        case "iPhone14,4": return "iPhone 13 mini"
//        case "iPhone14,5": return "iPhone 13"
//        case "iPhone14,2": return "iPhone 13 Pro"
//        case "iPhone14,3": return "iPhone 13 Pro Max"
//        case "iPhone14,6": return "iPhone SE (3rd gen)"
//        
//        // iPhone 14 series
//        case "iPhone14,7": return "iPhone 14"
//        case "iPhone14,8": return "iPhone 14 Plus"
//        case "iPhone15,2": return "iPhone 14 Pro"
//        case "iPhone15,3": return "iPhone 14 Pro Max"
//        
//        // iPhone 15 series
//        case "iPhone15,4": return "iPhone 15"
//        case "iPhone15,5": return "iPhone 15 Plus"
//        case "iPhone16,1": return "iPhone 15 Pro"
//        case "iPhone16,2": return "iPhone 15 Pro Max"
//        
//        // iPhone 16 series
//        case "iPhone17,1": return "iPhone 16 Pro"
//        case "iPhone17,2": return "iPhone 16 Pro Max"
//        case "iPhone17,3": return "iPhone 16"
//        case "iPhone17,4": return "iPhone 16 Plus"
//        
//        // Simulator check
//        case "i386", "x86_64", "arm64":
//            return "iPhone Simulator"
//        default:
//            return identifier
//        }
//    }
//    
//    // Function to refresh all data
//    func refreshData() {
//        fetchStorageInfo()
//        fetchRAMInfo()
//        fetchCPUInfo()
//        fetchBatteryInfo()
//        fetchDeviceInfo()
//    }
//    
//    // Helper method to get storage in different formats
//    func getStorageInFormat(_ bytes: Int64, useDecimal: Bool = true) -> (Int, String) {
//        if useDecimal {
//            // Use decimal (1000^3) to match manufacturer specifications
//            let gigabyte = Int64(1000 * 1000 * 1000)
//            let gigabyteValue = Double(bytes) / Double(gigabyte)
//            return (Int(round(gigabyteValue)), "GB")
//        } else {
//            // Use binary (1024^3) for technical accuracy
//            let gigabyte = Int64(1024 * 1024 * 1024)
//            let gigabyteValue = Double(bytes) / Double(gigabyte)
//            return (Int(round(gigabyteValue)), "GB")
//        }
//    }
//}

class DeviceInfoManager: ObservableObject {
    
    @Published var totalRAM: (Int, String) = (0, "")
    @Published var cpuCores: Int = 0
    @Published var architecture: String = ""
    @Published var batteryPercentage: Int = 0
    @Published var chargingState: String = ""
    @Published var deviceModel: String = ""
    @Published var osVersion: String = ""
    @Published var totalStorage: (String, String) = ("0", "GB")
        @Published var usedStorage: (String, String) = ("0", "GB")
        @Published var availableStorage: (String, String) = ("0", "GB")
    init() {
//        fetchStorageInfo()
//        fetchRAMInfo()
//        fetchCPUInfo()
//        fetchBatteryInfo()
//        fetchDeviceInfo()
        fetchStorageInfo()
            fetchRAMInfo()
            fetchCPUInfo()
            fetchBatteryInfo()
            fetchDeviceInfo()
            
            UIDevice.current.isBatteryMonitoringEnabled = true

            NotificationCenter.default.addObserver(
                self,
                selector: #selector(batteryLevelDidChange),
                name: UIDevice.batteryLevelDidChangeNotification,
                object: nil
            )

            NotificationCenter.default.addObserver(
                self,
                selector: #selector(batteryStateDidChange),
                name: UIDevice.batteryStateDidChangeNotification,
                object: nil
            )
    }
    @objc private func batteryLevelDidChange(_ notification: Notification) {
        let batteryLevel = UIDevice.current.batteryLevel
        batteryPercentage = batteryLevel < 0 ? 0 : Int(batteryLevel * 100)
    }

    @objc private func batteryStateDidChange(_ notification: Notification) {
        switch UIDevice.current.batteryState {
        case .charging:
            chargingState = "Charging"
        case .full:
            chargingState = "Fully Charged"
        case .unplugged:
            chargingState = "Not Charging"
        default:
            chargingState = "Unknown"
        }
    }
    // Get storage information
//    func fetchStorageInfo() {
//            if let homeDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
//                do {
//                    let values = try homeDirectory.resourceValues(forKeys: [.volumeAvailableCapacityForImportantUsageKey, .volumeTotalCapacityKey])
//
//                    if let total = values.volumeTotalCapacity,
//                       let free = values.volumeAvailableCapacityForImportantUsage {
//                        
//                        let used = Int64(total) - free
//
//                        
//                        totalStorage = formatByteSize(Int64(total))
//                        availableStorage = formatByteSize(Int64(free))
//                        usedStorage = formatByteSize(Int64(used))
//                    }
//                } catch {
//                    print("Error fetching storage info: \(error.localizedDescription)")
//                }
//            }
//        }
    
    func fetchStorageInfo() {
        if let homeDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            do {
                let values = try homeDirectory.resourceValues(forKeys: [.volumeAvailableCapacityForImportantUsageKey, .volumeTotalCapacityKey])

                if let total = values.volumeTotalCapacity,
                   let free = values.volumeAvailableCapacityForImportantUsage {

                    let used = Int64(total) - free

                    // Convert to GB manually and round
                    let totalInGB = Double(total) / 1_000_000_000
                    let roundedTotal = Int(round(totalInGB))
                    totalStorage = ("\(roundedTotal)", "GB")

                    availableStorage = formatByteSize(Int64(free))
                    usedStorage = formatByteSize(Int64(used))
                }
            } catch {
                print("Error fetching storage info: \(error.localizedDescription)")
            }
        }
    }
    // Format byte size to human-readable format using decimal calculation to match manufacturer specs
//    private func formatByteSize(_ bytes: Int64) -> (Int, String) {
//        // Use decimal calculation (1000^3) to match manufacturer specifications (64GB, 128GB, etc.)
//        let gigabyte = Int64(1000 * 1000 * 1000) // Decimal calculation (1000^3)
//        let gigabyteValue = Double(bytes) / Double(gigabyte)
//        
//        // Round to nearest integer for display
//        let roundedGB = Int(round(gigabyteValue))
//        let unit = "GB"
//        
//        return (roundedGB, unit)
//    }
    
//    private func formatByteSize(_ bytes: Int64) -> (String, String) {
//           let gb = 1_000_000_000.0
//           let value = Double(bytes) / gb
//           let formatted = String(format: "%.1f", value)
//           return (formatted, "GB")
//       }
    
    func formatByteSize(_ bytes: Int64) -> (String, String) {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useGB]
        formatter.countStyle = .decimal
        formatter.includesUnit = false
        let gb = Double(bytes) / 1_000_000_000
        return (String(Int(round(gb))), "GB") // التقريب لأقرب عدد صحيح
    }
    
    // Alternative method that shows more precise storage calculation
    private func formatByteSizePrecise(_ bytes: Int64) -> (Int, String) {
        let gigabyte = Int64(1024 * 1024 * 1024) // Binary calculation
        
        // For devices like 64GB, manufacturers use decimal (1000^3) but OS uses binary (1024^3)
        // To match the marketed capacity, you might want to use decimal for display
        let decimalGigabyte = Int64(1000 * 1000 * 1000)
        
        // Use decimal calculation to match manufacturer specs
        let gigabyteValue = Double(bytes) / Double(decimalGigabyte)
        let roundedGB = Int(round(gigabyteValue))
        
        return (roundedGB, "GB")
    }
    
    // Get RAM information
    private func fetchRAMInfo() {
        let totalMemory = ProcessInfo.processInfo.physicalMemory
        // Use binary calculation for RAM as well
        let gb = Double(totalMemory) / Double(1024 * 1024 * 1024)
        let rounded = Int(round(gb))
        totalRAM = (rounded, "GB")
        
        //totalRAM = (Int(totalMemory / UInt64(1024 * 1024 * 1024)), "GB")
    }
    
    // Get CPU information with proper chip names
    private func fetchCPUInfo() {
        cpuCores = ProcessInfo.processInfo.processorCount
        architecture = getChipName()
    }
    
    // Get the actual Apple chip name based on device model
    private func getChipName() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        // Map device identifiers to their actual chip names
        switch identifier {
        // A8 Chip
        case "iPhone7,1", "iPhone7,2": return "A8 Bionic"
        
        // A9 Chip
        case "iPhone8,1", "iPhone8,2", "iPhone8,4": return "A9 Bionic"
        
        // A10 Chip
        case "iPhone9,1", "iPhone9,2", "iPhone9,3", "iPhone9,4": return "A10 Fusion"
        
        // A11 Chip
        case "iPhone10,1", "iPhone10,2", "iPhone10,3", "iPhone10,4", "iPhone10,5", "iPhone10,6": return "A11 Bionic"
        
        // A12 Chip
        case "iPhone11,2", "iPhone11,4", "iPhone11,6", "iPhone11,8": return "A12 Bionic"
        
        // A13 Chip (iPhone 11 series)
        case "iPhone12,1", "iPhone12,3", "iPhone12,5", "iPhone12,8": return "A13 Bionic"
        
        // A14 Chip (iPhone 12 series)
        case "iPhone13,1", "iPhone13,2", "iPhone13,3", "iPhone13,4": return "A14 Bionic"
        
        // A15 Chip (iPhone 13 series)
        case "iPhone14,2", "iPhone14,3", "iPhone14,4", "iPhone14,5", "iPhone14,6": return "A15 Bionic"
        
        // A16 Chip (iPhone 14 Pro series)
        case "iPhone15,2", "iPhone15,3": return "A16 Bionic"
        // A15 Chip (iPhone 14 base series)
        case "iPhone14,7", "iPhone14,8": return "A15 Bionic"
        
        // A17 Pro Chip (iPhone 15 Pro series)
        case "iPhone16,1", "iPhone16,2": return "A17 Pro"
        // A16 Chip (iPhone 15 base series)
        case "iPhone15,4", "iPhone15,5": return "A16 Bionic"
        
        // A18 Chip (iPhone 16 series)
        case "iPhone17,1", "iPhone17,2": return "A18 Pro"
        case "iPhone17,3", "iPhone17,4": return "A18"
        
        // iPad chips (if you want to support iPads)
        case let identifier where identifier.contains("iPad"):
            return getIPadChipName(identifier)
        
        // Simulator
        case "i386", "x86_64", "arm64":
            return "Simulator"
        
        // Fallback to architecture
        default:
            #if arch(arm64)
            return "ARM64"
            #elseif arch(x86_64)
            return "x86_64"
            #else
            return "Unknown"
            #endif
        }
    }
    
    // Helper function for iPad chip names (optional)
    private func getIPadChipName(_ identifier: String) -> String {
        switch identifier {
        case let id where id.contains("iPad13"):
            return "M1"
        case let id where id.contains("iPad14"):
            return "M2"
        case let id where id.contains("iPad16"):
            return "M4"
        case let id where id.contains("iPad11"):
            return "A12Z Bionic"
        case let id where id.contains("iPad8"):
            return "A12 Bionic"
        default:
            return "iPad Chip"
        }
    }
    
    // Get battery information
    private func fetchBatteryInfo() {
        // Enable battery monitoring
        UIDevice.current.isBatteryMonitoringEnabled = true
        
        // Get battery level
        let batteryLevel = UIDevice.current.batteryLevel
        batteryPercentage = batteryLevel < 0 ? 0 : Int(batteryLevel * 100)
        
        // Get charging state
        switch UIDevice.current.batteryState {
        case .charging:
            chargingState = "Charging"
        case .full:
            chargingState = "Fully Charged"
        case .unplugged:
            chargingState = "Not Charging"
        case .unknown:
            chargingState = "Unknown"
        @unknown default:
            chargingState = "Unknown"
        }
    }
    
    // Get device information
    private func fetchDeviceInfo() {
        let device = UIDevice.current
        deviceModel = getDeviceModel()
        osVersion = "\(device.systemName) \(device.systemVersion)"
    }
    
    // Get detailed device model
    private func getDeviceModel() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        // Map common identifiers to marketing names (verified mappings)
        switch identifier {
        // iPhone 8 series
        case "iPhone10,1", "iPhone10,4": return "iPhone 8"
        case "iPhone10,2", "iPhone10,5": return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6": return "iPhone X"
        
        // iPhone XR, XS series
        case "iPhone11,2": return "iPhone XS"
        case "iPhone11,4", "iPhone11,6": return "iPhone XS Max"
        case "iPhone11,8": return "iPhone XR"
        
        // iPhone 11 series
        case "iPhone12,1": return "iPhone 11"
        case "iPhone12,3": return "iPhone 11 Pro"
        case "iPhone12,5": return "iPhone 11 Pro Max"
        case "iPhone12,8": return "iPhone SE (2nd gen)"
        
        // iPhone 12 series
        case "iPhone13,1": return "iPhone 12 mini"
        case "iPhone13,2": return "iPhone 12"
        case "iPhone13,3": return "iPhone 12 Pro"
        case "iPhone13,4": return "iPhone 12 Pro Max"
        
        // iPhone 13 series
        case "iPhone14,4": return "iPhone 13 mini"
        case "iPhone14,5": return "iPhone 13"
        case "iPhone14,2": return "iPhone 13 Pro"
        case "iPhone14,3": return "iPhone 13 Pro Max"
        case "iPhone14,6": return "iPhone SE (3rd gen)"
        
        // iPhone 14 series
        case "iPhone14,7": return "iPhone 14"
        case "iPhone14,8": return "iPhone 14 Plus"
        case "iPhone15,2": return "iPhone 14 Pro"
        case "iPhone15,3": return "iPhone 14 Pro Max"
        
        // iPhone 15 series
        case "iPhone15,4": return "iPhone 15"
        case "iPhone15,5": return "iPhone 15 Plus"
        case "iPhone16,1": return "iPhone 15 Pro"
        case "iPhone16,2": return "iPhone 15 Pro Max"
        
        // iPhone 16 series
        case "iPhone17,1": return "iPhone 16 Pro"
        case "iPhone17,2": return "iPhone 16 Pro Max"
        case "iPhone17,3": return "iPhone 16"
        case "iPhone17,4": return "iPhone 16 Plus"
        
        // Simulator check
        case "i386", "x86_64", "arm64":
            return "iPhone Simulator"
        default:
            return identifier
        }
    }
    
    // Function to refresh all data
    func refreshData() {
        fetchStorageInfo()
        fetchRAMInfo()
        fetchCPUInfo()
        fetchBatteryInfo()
        fetchDeviceInfo()
    }
    
    // Helper method to get storage in different formats
    func getStorageInFormat(_ bytes: Int64, useDecimal: Bool = true) -> (Int, String) {
        if useDecimal {
            // Use decimal (1000^3) to match manufacturer specifications
            let gigabyte = Int64(1000 * 1000 * 1000)
            let gigabyteValue = Double(bytes) / Double(gigabyte)
            return (Int(round(gigabyteValue)), "GB")
        } else {
            // Use binary (1024^3) for technical accuracy
            let gigabyte = Int64(1024 * 1024 * 1024)
            let gigabyteValue = Double(bytes) / Double(gigabyte)
            return (Int(round(gigabyteValue)), "GB")
        }
    }
}
