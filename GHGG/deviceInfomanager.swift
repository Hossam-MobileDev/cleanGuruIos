//
//  deviceInfomanager.swift
//  GHGG
//
//  Created by test on 11/05/2025.
//

import Foundation
import UIKit

class DeviceInfoManager: ObservableObject {
    @Published var totalStorage: (Int, String) = (0, "")
    @Published var availableStorage: (Int, String) = (0, "")
    @Published var usedStorage: (Int, String) = (0, "")
    @Published var totalRAM: (Int, String) = (0, "")
    @Published var cpuCores: Int = 0
    @Published var architecture: String = ""
    @Published var batteryPercentage: Int = 0
    @Published var chargingState: String = ""
    @Published var deviceModel: String = ""
    @Published var osVersion: String = ""
    
    init() {
        fetchStorageInfo()
        fetchRAMInfo()
        fetchCPUInfo()
        fetchBatteryInfo()
        fetchDeviceInfo()
    }
    
    // Get storage information
    private func fetchStorageInfo() {
        let fileManager = FileManager.default
        do {
            if let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
                let attributes = try fileManager.attributesOfFileSystem(forPath: documentDirectory.path)
                
                if let totalSize = attributes[.systemSize] as? NSNumber,
                   let freeSize = attributes[.systemFreeSize] as? NSNumber {
                    
                    let total = totalSize.int64Value
                    let free = freeSize.int64Value
                    let used = total - free
                    
                    totalStorage = formatByteSize(total)
                    availableStorage = formatByteSize(free)
                    usedStorage = formatByteSize(used)
                }
            }
        } catch {
            print("Error getting storage info: \(error)")
        }
    }
    
    // Format byte size to human-readable format
    private func formatByteSize(_ bytes: Int64) -> (Int, String) {
        let gigabyte = Int64(1000 * 1000 * 1000)
        let gigabyteInt = Int(bytes / gigabyte)
        let unit = "GB"
        return (gigabyteInt, unit)
    }
    
    // Get RAM information
    private func fetchRAMInfo() {
        let totalMemory = ProcessInfo.processInfo.physicalMemory
        totalRAM = (Int(totalMemory / UInt64(1024 * 1024 * 1024)), "GB")
    }
    
    // Get CPU information
    private func fetchCPUInfo() {
        cpuCores = ProcessInfo.processInfo.processorCount
        
        #if arch(arm64)
        architecture = "ARM64"
        #elseif arch(x86_64)
        architecture = "x86_64"
        #else
        architecture = "Unknown"
        #endif
    }
    
    // Get battery information
    private func fetchBatteryInfo() {
        // Enable battery monitoring
        UIDevice.current.isBatteryMonitoringEnabled = true
        
        // Get battery level
        batteryPercentage = Int(UIDevice.current.batteryLevel * 100)
        
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
        
        // Map common identifiers to marketing names
        switch identifier {
        case "iPhone14,2": return "iPhone 13 Pro"
        case "iPhone14,3": return "iPhone 13 Pro Max"
        case "iPhone14,4": return "iPhone 13 mini"
        case "iPhone14,5": return "iPhone 13"
        case "iPhone14,6": return "iPhone SE (3rd gen)"
        case "iPhone14,7": return "iPhone 14"
        case "iPhone14,8": return "iPhone 14 Plus"
        case "iPhone15,2": return "iPhone 14 Pro"
        case "iPhone15,3": return "iPhone 14 Pro Max"
        case "iPhone15,4": return "iPhone 15"
        case "iPhone15,5": return "iPhone 15 Plus"
        case "iPhone16,1": return "iPhone 15 Pro"
        case "iPhone16,2": return "iPhone 15 Pro Max"
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
    
    
    
    
}
