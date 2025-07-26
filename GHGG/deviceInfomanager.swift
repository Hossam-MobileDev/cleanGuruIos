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

//class DeviceInfoManager: ObservableObject {
//    
//    @Published var totalRAM: (Int, String) = (0, "")
//    @Published var cpuCores: Int = 0
//    @Published var architecture: String = ""
//    @Published var batteryPercentage: Int = 0
//    @Published var chargingState: String = ""
//    @Published var deviceModel: String = ""
//    @Published var osVersion: String = ""
//    @Published var totalStorage: (String, String) = ("0", "GB")
//        @Published var usedStorage: (String, String) = ("0", "GB")
//        @Published var availableStorage: (String, String) = ("0", "GB")
//    init() {
////        fetchStorageInfo()
////        fetchRAMInfo()
////        fetchCPUInfo()
////        fetchBatteryInfo()
////        fetchDeviceInfo()
//        fetchStorageInfo()
//            fetchRAMInfo()
//            fetchCPUInfo()
//            fetchBatteryInfo()
//            fetchDeviceInfo()
//            
//            UIDevice.current.isBatteryMonitoringEnabled = true
//
//            NotificationCenter.default.addObserver(
//                self,
//                selector: #selector(batteryLevelDidChange),
//                name: UIDevice.batteryLevelDidChangeNotification,
//                object: nil
//            )
//
//            NotificationCenter.default.addObserver(
//                self,
//                selector: #selector(batteryStateDidChange),
//                name: UIDevice.batteryStateDidChangeNotification,
//                object: nil
//            )
//    }
//    @objc private func batteryLevelDidChange(_ notification: Notification) {
//        let batteryLevel = UIDevice.current.batteryLevel
//        batteryPercentage = batteryLevel < 0 ? 0 : Int(batteryLevel * 100)
//    }
//
//    @objc private func batteryStateDidChange(_ notification: Notification) {
//        switch UIDevice.current.batteryState {
//        case .charging:
//            chargingState = "Charging"
//        case .full:
//            chargingState = "Fully Charged"
//        case .unplugged:
//            chargingState = "Not Charging"
//        default:
//            chargingState = "Unknown"
//        }
//    }
//    // Get storage information
////    func fetchStorageInfo() {
////            if let homeDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
////                do {
////                    let values = try homeDirectory.resourceValues(forKeys: [.volumeAvailableCapacityForImportantUsageKey, .volumeTotalCapacityKey])
////
////                    if let total = values.volumeTotalCapacity,
////                       let free = values.volumeAvailableCapacityForImportantUsage {
////                        
////                        let used = Int64(total) - free
////
////                        
////                        totalStorage = formatByteSize(Int64(total))
////                        availableStorage = formatByteSize(Int64(free))
////                        usedStorage = formatByteSize(Int64(used))
////                    }
////                } catch {
////                    print("Error fetching storage info: \(error.localizedDescription)")
////                }
////            }
////        }
//    
//    func fetchStorageInfo() {
//        if let homeDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
//            do {
//                let values = try homeDirectory.resourceValues(forKeys: [.volumeAvailableCapacityForImportantUsageKey, .volumeTotalCapacityKey])
//
//                if let total = values.volumeTotalCapacity,
//                   let free = values.volumeAvailableCapacityForImportantUsage {
//
//                    let used = Int64(total) - free
//
//                    // Convert to GB manually and round
//                    let totalInGB = Double(total) / 1_000_000_000
//                    let roundedTotal = Int(round(totalInGB))
//                    totalStorage = ("\(roundedTotal)", "GB")
//
//                    availableStorage = formatByteSize(Int64(free))
//                    usedStorage = formatByteSize(Int64(used))
//                }
//            } catch {
//                print("Error fetching storage info: \(error.localizedDescription)")
//            }
//        }
//    }
//    // Format byte size to human-readable format using decimal calculation to match manufacturer specs
////    private func formatByteSize(_ bytes: Int64) -> (Int, String) {
////        // Use decimal calculation (1000^3) to match manufacturer specifications (64GB, 128GB, etc.)
////        let gigabyte = Int64(1000 * 1000 * 1000) // Decimal calculation (1000^3)
////        let gigabyteValue = Double(bytes) / Double(gigabyte)
////        
////        // Round to nearest integer for display
////        let roundedGB = Int(round(gigabyteValue))
////        let unit = "GB"
////        
////        return (roundedGB, unit)
////    }
//    
////    private func formatByteSize(_ bytes: Int64) -> (String, String) {
////           let gb = 1_000_000_000.0
////           let value = Double(bytes) / gb
////           let formatted = String(format: "%.1f", value)
////           return (formatted, "GB")
////       }
//    
//    func formatByteSize(_ bytes: Int64) -> (String, String) {
//        let formatter = ByteCountFormatter()
//        formatter.allowedUnits = [.useGB]
//        formatter.countStyle = .decimal
//        formatter.includesUnit = false
//        let gb = Double(bytes) / 1_000_000_000
//        return (String(Int(round(gb))), "GB") // التقريب لأقرب عدد صحيح
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
//        let gb = Double(totalMemory) / Double(1024 * 1024 * 1024)
//        let rounded = Int(round(gb))
//        totalRAM = (rounded, "GB")
//        
//        //totalRAM = (Int(totalMemory / UInt64(1024 * 1024 * 1024)), "GB")
//    }
//    
//    // Get CPU information with proper chip names
//    private func fetchCPUInfo() {
//        cpuCores = ProcessInfo.processInfo.processorCount
//        architecture = getChipName()
//    }
//    
//    // Get the actual Apple chip name based on device model
//    private func getChipName() -> String {
//        var systemInfo = utsname()
//        uname(&systemInfo)
//        let machineMirror = Mirror(reflecting: systemInfo.machine)
//        let identifier = machineMirror.children.reduce("") { identifier, element in
//            guard let value = element.value as? Int8, value != 0 else { return identifier }
//            return identifier + String(UnicodeScalar(UInt8(value)))
//        }
//        
//        // Map device identifiers to their actual chip names
//        switch identifier {
//        // A8 Chip
//        case "iPhone7,1", "iPhone7,2": return "A8 Bionic"
//        
//        // A9 Chip
//        case "iPhone8,1", "iPhone8,2", "iPhone8,4": return "A9 Bionic"
//        
//        // A10 Chip
//        case "iPhone9,1", "iPhone9,2", "iPhone9,3", "iPhone9,4": return "A10 Fusion"
//        
//        // A11 Chip
//        case "iPhone10,1", "iPhone10,2", "iPhone10,3", "iPhone10,4", "iPhone10,5", "iPhone10,6": return "A11 Bionic"
//        
//        // A12 Chip
//        case "iPhone11,2", "iPhone11,4", "iPhone11,6", "iPhone11,8": return "A12 Bionic"
//        
//        // A13 Chip (iPhone 11 series)
//        case "iPhone12,1", "iPhone12,3", "iPhone12,5", "iPhone12,8": return "A13 Bionic"
//        
//        // A14 Chip (iPhone 12 series)
//        case "iPhone13,1", "iPhone13,2", "iPhone13,3", "iPhone13,4": return "A14 Bionic"
//        
//        // A15 Chip (iPhone 13 series)
//        case "iPhone14,2", "iPhone14,3", "iPhone14,4", "iPhone14,5", "iPhone14,6": return "A15 Bionic"
//        
//        // A16 Chip (iPhone 14 Pro series)
//        case "iPhone15,2", "iPhone15,3": return "A16 Bionic"
//        // A15 Chip (iPhone 14 base series)
//        case "iPhone14,7", "iPhone14,8": return "A15 Bionic"
//        
//        // A17 Pro Chip (iPhone 15 Pro series)
//        case "iPhone16,1", "iPhone16,2": return "A17 Pro"
//        // A16 Chip (iPhone 15 base series)
//        case "iPhone15,4", "iPhone15,5": return "A16 Bionic"
//        
//        // A18 Chip (iPhone 16 series)
//        case "iPhone17,1", "iPhone17,2": return "A18 Pro"
//        case "iPhone17,3", "iPhone17,4": return "A18"
//        
//        // iPad chips (if you want to support iPads)
//        case let identifier where identifier.contains("iPad"):
//            return getIPadChipName(identifier)
//        
//        // Simulator
//        case "i386", "x86_64", "arm64":
//            return "Simulator"
//        
//        // Fallback to architecture
//        default:
//            #if arch(arm64)
//            return "ARM64"
//            #elseif arch(x86_64)
//            return "x86_64"
//            #else
//            return "Unknown"
//            #endif
//        }
//    }
//    
//    // Helper function for iPad chip names (optional)
//    private func getIPadChipName(_ identifier: String) -> String {
//        switch identifier {
//        case let id where id.contains("iPad13"):
//            return "M1"
//        case let id where id.contains("iPad14"):
//            return "M2"
//        case let id where id.contains("iPad16"):
//            return "M4"
//        case let id where id.contains("iPad11"):
//            return "A12Z Bionic"
//        case let id where id.contains("iPad8"):
//            return "A12 Bionic"
//        default:
//            return "iPad Chip"
//        }
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

//class DeviceInfoManager: ObservableObject {
//    
//    @Published var totalRAM: (Int, String) = (0, "")
//    @Published var cpuCores: Int = 0
//    @Published var architecture: String = ""
//    @Published var batteryPercentage: Int = 0
//    @Published var chargingState: String = ""
//    @Published var deviceModel: String = ""
//    @Published var osVersion: String = ""
//    @Published var totalStorage: (String, String) = ("0", "GB")
//    @Published var usedStorage: (String, String) = ("0", "GB")
//    @Published var availableStorage: (String, String) = ("0", "GB")
//    
//    init() {
//        // Enable battery monitoring FIRST with verification
//        UIDevice.current.isBatteryMonitoringEnabled = true
//        
//        // Verify it's actually enabled
//        if !UIDevice.current.isBatteryMonitoringEnabled {
//            print("⚠️ Battery monitoring failed to enable immediately")
//            // Force enable again
//            DispatchQueue.main.async {
//                UIDevice.current.isBatteryMonitoringEnabled = true
//            }
//        }
//        
//        // Set up observers BEFORE fetching data
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(batteryLevelDidChange),
//            name: UIDevice.batteryLevelDidChangeNotification,
//            object: nil
//        )
//
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(batteryStateDidChange),
//            name: UIDevice.batteryStateDidChangeNotification,
//            object: nil
//        )
//        
//        // Add observer for app becoming active (important for some devices)
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(appDidBecomeActive),
//            name: UIApplication.didBecomeActiveNotification,
//            object: nil
//        )
//        
//        // Fetch other data first
//        fetchStorageInfo()
//        fetchRAMInfo()
//        fetchCPUInfo()
//        fetchDeviceInfo()
//        
//        // Multiple delayed attempts to ensure battery monitoring works
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
//            self?.fetchBatteryInfo()
//        }
//        
//        // Second attempt after a longer delay for stubborn devices
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
//            if self?.batteryPercentage == 0 {
//                print("🔋 Retrying battery fetch...")
//                self?.fetchBatteryInfo()
//            }
//        }
//    }
//    
//    deinit {
//        NotificationCenter.default.removeObserver(self)
//    }
//    
//    @objc private func appDidBecomeActive() {
//        // Re-enable battery monitoring when app becomes active
//        UIDevice.current.isBatteryMonitoringEnabled = true
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
//            self?.fetchBatteryInfo()
//        }
//    }
//    
//    @objc private func batteryLevelDidChange(_ notification: Notification) {
//        DispatchQueue.main.async { [weak self] in
//            self?.updateBatteryLevel()
//        }
//    }
//
//    @objc private func batteryStateDidChange(_ notification: Notification) {
//        DispatchQueue.main.async { [weak self] in
//            self?.updateBatteryState()
//        }
//    }
//    
//    private func updateBatteryLevel() {
//        // Ensure monitoring is still enabled
//        if !UIDevice.current.isBatteryMonitoringEnabled {
//            UIDevice.current.isBatteryMonitoringEnabled = true
//            // Wait and retry
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
//                self?.updateBatteryLevel()
//            }
//            return
//        }
//        
//        let batteryLevel = UIDevice.current.batteryLevel
//        print("📱 Battery level raw value: \(batteryLevel)")
//        
//        if batteryLevel < 0 {
//            // Battery level unavailable, try different approach
//            print("⚠️ Battery level unavailable, attempting alternate method...")
//            
//            // Try to trigger a battery state change
//            let currentState = UIDevice.current.batteryState
//            print("🔋 Current battery state: \(currentState.rawValue)")
//            
//            // Retry with longer delay
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
//                let retryLevel = UIDevice.current.batteryLevel
//                if retryLevel >= 0 {
//                    self?.batteryPercentage = Int(round(retryLevel * 100))
//                    print("✅ Battery percentage (retry): \(self?.batteryPercentage ?? 0)%")
//                } else {
//                    // Use a default or last known value
//                    print("❌ Battery level still unavailable")
//                }
//            }
//        } else {
//            batteryPercentage = Int(round(batteryLevel * 100))
//            print("✅ Battery percentage: \(batteryPercentage)%")
//        }
//    }
//    
//    private func updateBatteryState() {
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
//        print("🔋 Battery state: \(chargingState)")
//    }
//    
//    // Get battery information with retry logic
//    private func fetchBatteryInfo() {
//        // Ensure battery monitoring is enabled
//        if !UIDevice.current.isBatteryMonitoringEnabled {
//            UIDevice.current.isBatteryMonitoringEnabled = true
//            // Wait a bit and try again
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
//                self?.fetchBatteryInfo()
//            }
//            return
//        }
//        
//        updateBatteryLevel()
//        updateBatteryState()
//    }
//    
//    // Get storage information
//    func fetchStorageInfo() {
//        if let homeDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
//            do {
//                let values = try homeDirectory.resourceValues(forKeys: [.volumeAvailableCapacityForImportantUsageKey, .volumeTotalCapacityKey])
//
//                if let total = values.volumeTotalCapacity,
//                   let free = values.volumeAvailableCapacityForImportantUsage {
//
//                    let used = Int64(total) - free
//
//                    // Convert to GB manually and round
//                    let totalInGB = Double(total) / 1_000_000_000
//                    let roundedTotal = Int(round(totalInGB))
//                    totalStorage = ("\(roundedTotal)", "GB")
//
//                    availableStorage = formatByteSize(Int64(free))
//                    usedStorage = formatByteSize(Int64(used))
//                }
//            } catch {
//                print("Error fetching storage info: \(error.localizedDescription)")
//            }
//        }
//    }
//    
//    func formatByteSize(_ bytes: Int64) -> (String, String) {
//        let formatter = ByteCountFormatter()
//        formatter.allowedUnits = [.useGB]
//        formatter.countStyle = .decimal
//        formatter.includesUnit = false
//        let gb = Double(bytes) / 1_000_000_000
//        return (String(Int(round(gb))), "GB")
//    }
//    
//    // Get RAM information
//    private func fetchRAMInfo() {
//        let totalMemory = ProcessInfo.processInfo.physicalMemory
//        let gb = Double(totalMemory) / Double(1024 * 1024 * 1024)
//        let rounded = Int(round(gb))
//        totalRAM = (rounded, "GB")
//    }
//    
//    // Get CPU information with proper chip names
//    private func fetchCPUInfo() {
//        cpuCores = ProcessInfo.processInfo.processorCount
//        architecture = getChipName()
//    }
//    
//    // Get the actual Apple chip name based on device model
//    private func getChipName() -> String {
//        var systemInfo = utsname()
//        uname(&systemInfo)
//        let machineMirror = Mirror(reflecting: systemInfo.machine)
//        let identifier = machineMirror.children.reduce("") { identifier, element in
//            guard let value = element.value as? Int8, value != 0 else { return identifier }
//            return identifier + String(UnicodeScalar(UInt8(value)))
//        }
//        
//        // Map device identifiers to their actual chip names
//        switch identifier {
//        // A8 Chip
//        case "iPhone7,1", "iPhone7,2": return "A8 Bionic"
//        
//        // A9 Chip
//        case "iPhone8,1", "iPhone8,2", "iPhone8,4": return "A9 Bionic"
//        
//        // A10 Chip
//        case "iPhone9,1", "iPhone9,2", "iPhone9,3", "iPhone9,4": return "A10 Fusion"
//        
//        // A11 Chip
//        case "iPhone10,1", "iPhone10,2", "iPhone10,3", "iPhone10,4", "iPhone10,5", "iPhone10,6": return "A11 Bionic"
//        
//        // A12 Chip
//        case "iPhone11,2", "iPhone11,4", "iPhone11,6", "iPhone11,8": return "A12 Bionic"
//        
//        // A13 Chip (iPhone 11 series)
//        case "iPhone12,1", "iPhone12,3", "iPhone12,5", "iPhone12,8": return "A13 Bionic"
//        
//        // A14 Chip (iPhone 12 series)
//        case "iPhone13,1", "iPhone13,2", "iPhone13,3", "iPhone13,4": return "A14 Bionic"
//        
//        // A15 Chip (iPhone 13 series)
//        case "iPhone14,2", "iPhone14,3", "iPhone14,4", "iPhone14,5", "iPhone14,6": return "A15 Bionic"
//        
//        // A16 Chip (iPhone 14 Pro series)
//        case "iPhone15,2", "iPhone15,3": return "A16 Bionic"
//        // A15 Chip (iPhone 14 base series)
//        case "iPhone14,7", "iPhone14,8": return "A15 Bionic"
//        
//        // A17 Pro Chip (iPhone 15 Pro series)
//        case "iPhone16,1", "iPhone16,2": return "A17 Pro"
//        // A16 Chip (iPhone 15 base series)
//        case "iPhone15,4", "iPhone15,5": return "A16 Bionic"
//        
//        // A18 Chip (iPhone 16 series)
//        case "iPhone17,1", "iPhone17,2": return "A18 Pro"
//        case "iPhone17,3", "iPhone17,4": return "A18"
//        
//        // iPad chips (if you want to support iPads)
//        case let identifier where identifier.contains("iPad"):
//            return getIPadChipName(identifier)
//        
//        // Simulator
//        case "i386", "x86_64", "arm64":
//            return "Simulator"
//        
//        // Fallback to architecture
//        default:
//            #if arch(arm64)
//            return "ARM64"
//            #elseif arch(x86_64)
//            return "x86_64"
//            #else
//            return "Unknown"
//            #endif
//        }
//    }
//    
//    // Helper function for iPad chip names
//    private func getIPadChipName(_ identifier: String) -> String {
//        switch identifier {
//        case let id where id.contains("iPad13"):
//            return "M1"
//        case let id where id.contains("iPad14"):
//            return "M2"
//        case let id where id.contains("iPad16"):
//            return "M4"
//        case let id where id.contains("iPad11"):
//            return "A12Z Bionic"
//        case let id where id.contains("iPad8"):
//            return "A12 Bionic"
//        default:
//            return "iPad Chip"
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
//        // Map common identifiers to marketing names
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
//        fetchDeviceInfo()
//        // Re-fetch battery info with proper timing
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
//            self?.fetchBatteryInfo()
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
        // Fetch other data first
        fetchStorageInfo()
        fetchRAMInfo()
        fetchCPUInfo()
        fetchDeviceInfo()
        
        // Setup battery monitoring based on device
        setupBatteryMonitoring()
        
        // Set up observers AFTER initial setup
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
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // NEW: Device-specific battery monitoring setup
    private func setupBatteryMonitoring() {
        let device = getDeviceModel()
        print("📱 Setting up battery monitoring for: \(device)")
        
        if requiresEnhancedBatteryHandling() {
            print("🔧 Using enhanced battery monitoring for newer device")
            setupEnhancedBatteryMonitoring()
        } else {
            print("📊 Using standard battery monitoring")
            setupStandardBatteryMonitoring()
        }
    }
    
    // NEW: Check if device needs enhanced battery handling
    private func requiresEnhancedBatteryHandling() -> Bool {
        let deviceModel = getDeviceModel()
        let problematicDevices = ["iPhone 11", "iPhone 12", "iPhone 13", "iPhone 14", "iPhone 15", "iPhone 16"]
        
        return problematicDevices.contains { deviceModel.contains($0) }
    }
    
    // NEW: Enhanced battery monitoring for newer devices
    private func setupEnhancedBatteryMonitoring() {
        // Reset battery monitoring state
        UIDevice.current.isBatteryMonitoringEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            UIDevice.current.isBatteryMonitoringEnabled = true
            
            // Multiple enable attempts with increasing delays
            for i in 1...5 {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.3) {
                    UIDevice.current.isBatteryMonitoringEnabled = true
                }
            }
            
            // Start battery reading with retries
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.fetchBatteryInfoWithRetries()
            }
        }
    }
    
    // NEW: Standard battery monitoring for older devices (iPhone 8, etc.)
    private func setupStandardBatteryMonitoring() {
        UIDevice.current.isBatteryMonitoringEnabled = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.fetchBatteryInfo()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if self.batteryPercentage == 0 {
                self.fetchBatteryInfo()
            }
        }
    }
    
    // NEW: Enhanced battery reading with retries for problematic devices
    private func fetchBatteryInfoWithRetries() {
        var retryCount = 0
        let maxRetries = 8
        
        func attemptBatteryRead() {
            // Force enable monitoring before each attempt
            UIDevice.current.isBatteryMonitoringEnabled = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(retryCount) * 0.4) {
                let level = UIDevice.current.batteryLevel
                print("🔋 Battery read attempt \(retryCount + 1): level = \(level)")
                
                if level >= 0 {
                    self.batteryPercentage = Int(round(level * 100))
                    self.updateBatteryState()
                    print("✅ Battery read successful: \(self.batteryPercentage)%")
                } else if retryCount < maxRetries {
                    retryCount += 1
                    print("🔄 Retrying battery read...")
                    attemptBatteryRead()
                } else {
                    print("❌ Battery read failed after \(maxRetries) attempts")
                    self.handleBatteryReadFailure()
                }
            }
        }
        
        attemptBatteryRead()
    }
    
    // NEW: Handle battery read failure
    private func handleBatteryReadFailure() {
        print("⚠️ Battery reading failed on \(getDeviceModel())")
        batteryPercentage = -1 // Indicate unavailable
        chargingState = "Battery Info Unavailable"
    }
    
    @objc private func appDidBecomeActive() {
        // Use appropriate monitoring setup based on device
        if requiresEnhancedBatteryHandling() {
            setupEnhancedBatteryMonitoring()
        } else {
            UIDevice.current.isBatteryMonitoringEnabled = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                self?.fetchBatteryInfo()
            }
        }
    }
    
    @objc private func batteryLevelDidChange(_ notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            self?.updateBatteryLevel()
        }
    }

    @objc private func batteryStateDidChange(_ notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            self?.updateBatteryState()
        }
    }
    
    private func updateBatteryLevel() {
        if !UIDevice.current.isBatteryMonitoringEnabled {
            UIDevice.current.isBatteryMonitoringEnabled = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                self?.updateBatteryLevel()
            }
            return
        }
        
        let batteryLevel = UIDevice.current.batteryLevel
        print("📱 Battery level raw value: \(batteryLevel)")
        
        if batteryLevel < 0 {
            print("⚠️ Battery level unavailable, attempting alternate method...")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                let retryLevel = UIDevice.current.batteryLevel
                if retryLevel >= 0 {
                    self?.batteryPercentage = Int(round(retryLevel * 100))
                    print("✅ Battery percentage (retry): \(self?.batteryPercentage ?? 0)%")
                } else {
                    print("❌ Battery level still unavailable")
                }
            }
        } else {
            batteryPercentage = Int(round(batteryLevel * 100))
            print("✅ Battery percentage: \(batteryPercentage)%")
        }
    }
    
    private func updateBatteryState() {
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
        print("🔋 Battery state: \(chargingState)")
    }
    
    // UPDATED: Use device-specific approach
    private func fetchBatteryInfo() {
        if requiresEnhancedBatteryHandling() {
            fetchBatteryInfoWithRetries()
        } else {
            // Standard approach for iPhone 8 and other working devices
            if !UIDevice.current.isBatteryMonitoringEnabled {
                UIDevice.current.isBatteryMonitoringEnabled = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                    self?.fetchBatteryInfo()
                }
                return
            }
            
            updateBatteryLevel()
            updateBatteryState()
        }
    }
    
    // Get storage information
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
    
    func formatByteSize(_ bytes: Int64) -> (String, String) {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useGB]
        formatter.countStyle = .decimal
        formatter.includesUnit = false
        let gb = Double(bytes) / 1_000_000_000
        return (String(Int(round(gb))), "GB")
    }
    
    // Get RAM information
    private func fetchRAMInfo() {
        let totalMemory = ProcessInfo.processInfo.physicalMemory
        let gb = Double(totalMemory) / Double(1024 * 1024 * 1024)
        let rounded = Int(round(gb))
        totalRAM = (rounded, "GB")
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
    
    // Helper function for iPad chip names
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
        
        // Map common identifiers to marketing names
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
    
    // UPDATED: Function to refresh all data with device-specific battery handling
    func refreshData() {
        fetchStorageInfo()
        fetchRAMInfo()
        fetchCPUInfo()
        fetchDeviceInfo()
        
        // Use appropriate battery refresh based on device
        if requiresEnhancedBatteryHandling() {
            setupEnhancedBatteryMonitoring()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                self?.fetchBatteryInfo()
            }
        }
    }
}
