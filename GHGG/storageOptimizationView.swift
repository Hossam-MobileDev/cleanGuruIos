//
//  storageOptimizationView.swift
//  GHGG
//
//  Created by test on 11/05/2025.
//

import Foundation
import SwiftUI
import Photos
import CryptoKit
import Contacts
import EventKit



struct DuplicatePhotoGroup: Identifiable {
    let id = UUID()
    let hash: String
    var assets: [PHAsset]
    var bestAsset: PHAsset? // The one to keep
    
    var totalSize: Int64 {
        assets.reduce(0) { sum, asset in
            sum + getAssetSize(asset)
        }
    }
    
    var potentialSavings: Int64 {
        // Size of all duplicates except the best one
        guard let best = bestAsset else { return totalSize }
        return assets.reduce(0) { sum, asset in
            asset == best ? sum : sum + getAssetSize(asset)
        }
    }
    
    private func getAssetSize(_ asset: PHAsset) -> Int64 {
        // Estimate based on dimensions
        if asset.mediaType == .image {
            return Int64(Double(asset.pixelWidth * asset.pixelHeight) * 0.1)
        }
        return 0
    }
}

// MARK: - Main View
struct StorageOptimizationView: View {
    // Use @State for dynamic storage values
    @State private var totalStorage: Int64 = 0
    @State private var usedStorage: Int64 = 0
    @State private var freeStorage: Int64 = 0
    
    @State private var selectedContacts: Set<String> = []
    @EnvironmentObject var storageState: StorageOptimizationState

    @State private var selectedTab = "Duplicates"
    @State private var selectedPhotos: Set<Int> = []
    @State private var selectedVideos: Set<Int> = []
    @State private var selectedMediaItems: Set<String> = [] // Using localIdentifiers
    @State private var selectedMediaCategory = "Photos" // Default category
    
    // Photos access states
    @State private var photoAssets: PHFetchResult<PHAsset>?
    @State private var photoAccessGranted = false
    @State private var isLoading = true
    
    @EnvironmentObject var languageManager: LanguageManager // Add this line

    // Duplicate detection states
    @State private var duplicateGroups: [DuplicatePhotoGroup] = []
    @State private var selectedDuplicates: Set<String> = [] // localIdentifiers
    @State private var isAnalyzingDuplicates = false
    @State private var duplicatesAccessGranted = false
    @State private var hasCheckedDuplicatesAccess = false
    @State private var hasAnalyzedDuplicates = false
    @State private var analyzedPhotosCount = 0
    @State private var totalPhotosCount = 0
    
    let tabs = ["Duplicates", "media_compression",  "Clean Media", "Contacts Cleanup", "Calendar Cleaner"]
    
    var localizedTabs: [String] {
            [
                LocalizedStrings.string(for: "duplicates", language: languageManager.currentLanguage),
                LocalizedStrings.string(for: "media_compression", language: languageManager.currentLanguage),
                LocalizedStrings.string(for: "clean_media", language: languageManager.currentLanguage),
                LocalizedStrings.string(for: "contacts_cleanup", language: languageManager.currentLanguage),
                LocalizedStrings.string(for: "calendar_cleaner", language: languageManager.currentLanguage)
            ]
        }
    
    private func getOriginalTabKey(for localizedTab: String) -> String {
          let tabs = ["Duplicates", "media_compression", "Clean Media", "Contacts Cleanup", "Calendar Cleaner"]
          let keys = ["duplicates", "media_compression", "clean_media", "contacts_cleanup", "calendar_cleaner"]
          
          for (index, key) in keys.enumerated() {
              if LocalizedStrings.string(for: key, language: languageManager.currentLanguage) == localizedTab {
                  return tabs[index]
              }
          }
          return "Duplicates"
      }
    
    let mediaCategories = ["Photos", "Videos", "Audio"]
    
    
   
    
    // Photo and video data
    let photoItems = [0, 1, 2, 3]
    let videoItems = [0, 1, 2, 3]
    

    var body: some View {
            VStack(spacing: 0) {
                // Navigation bar
                VStack(spacing: 20) {
                    HStack {
                        Spacer()
                        LocalizedText("storage_optimization")
                            .font(.headline)
                        Spacer()
                        Spacer().frame(width: 20)
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    // Storage analysis section
                //    storageAnalysisSection
                    
                    // Tab selection with localized names
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(localizedTabs, id: \.self) { localizedTab in
                                let originalTab = getOriginalTabKey(for: localizedTab)
                                
                                Text(localizedTab)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 10)
                                    .font(.subheadline)
                                    .foregroundColor(storageState.selectedTab == originalTab ? .black : .gray)
                                    .background(
                                        storageState.selectedTab == originalTab ?
                                        Rectangle()
                                            .fill(Color.white)
                                            .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                                        : nil
                                    )
                                    .cornerRadius(4)
                                    .onTapGesture {
                                        storageState.selectedTab = originalTab
                                        
                                        if originalTab == "Duplicates" {
                                            if !storageState.hasCheckedDuplicatesAccess && !storageState.duplicatesAccessGranted {
                                                requestPhotoAccessForDuplicates()
                                            }
                                        }
                                        else if originalTab == "Clean Media" && storageState.photoAssets == nil {
                                            requestPhotoAccess()
                                        }
                                    }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .background(Color.gray.opacity(0.1))
                }
                
                // Content area with proper layout
                if storageState.selectedTab == "Duplicates" {
                    duplicatesContentViewFixed
                }
                else if storageState.selectedTab == "media_compression" {
                    MediaCompressionView()
                }
                else if storageState.selectedTab == "Clean Media" {
                    cleanMediaViewFixed
                } else if storageState.selectedTab == "Contacts Cleanup" {
                    ContactsCleanupView()
                }
                else if storageState.selectedTab == "Calendar Cleaner" {
                    CalendarCleanerView()
                }
            }
            .background(Color(.systemBackground))
            .environment(\.layoutDirection, languageManager.isArabic ? .rightToLeft : .leftToRight)
            .onAppear {
                updateStorageInfo()
            }
        }
        
    private var duplicatesContentViewFixed: some View {
            VStack(spacing: 0) {
                if storageState.isAnalyzingDuplicates {
                    // Analyzing progress view
                    VStack(spacing: 20) {
                        ProgressView()
                            .scaleEffect(1.5)
                        
                        LocalizedText("analyzing_photos")
                            .font(.headline)
                        
                        Text("\(storageState.analyzedPhotosCount) \(LocalizedStrings.string(for: "of", language: languageManager.currentLanguage)) \(storageState.totalPhotosCount) \(LocalizedStrings.string(for: "photos_analyzed", language: languageManager.currentLanguage))")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        // Progress bar
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(height: 4)
                                    .cornerRadius(2)
                                
                                Rectangle()
                                    .fill(Color.blue)
                                    .frame(width: geometry.size.width * CGFloat(storageState.analyzedPhotosCount) / CGFloat(max(storageState.totalPhotosCount, 1)), height: 4)
                                    .cornerRadius(2)
                            }
                        }
                        .frame(height: 4)
                        .padding(.horizontal, 40)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
                }
                else if !storageState.duplicatesAccessGranted {
                    // Permission view
                    VStack(spacing: 20) {
                        Image(systemName: "photo.stack")
                            .font(.system(size: 48))
                            .foregroundColor(.gray)
                        
                        LocalizedText("photo_access_required")
                            .font(.headline)
                        
                        LocalizedText("please_allow_access_analyze")
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        Button(action: {
                            storageState.hasCheckedDuplicatesAccess = false
                            requestPhotoAccessForDuplicates()
                        }) {
                            LocalizedText("grant_access")
                                .foregroundColor(.white)
                                .padding(.horizontal, 30)
                                .padding(.vertical, 12)
                                .background(Color.blue)
                                .cornerRadius(8)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
                }
                else if storageState.duplicateGroups.isEmpty && !storageState.hasAnalyzedDuplicates {
                    // Initial state - show analyze button
                    VStack(spacing: 20) {
                        Image(systemName: "photo.stack")
                            .font(.system(size: 48))
                            .foregroundColor(.blue)
                        
                        LocalizedText("find_duplicate_photos")
                            .font(.headline)
                        
                        LocalizedText("scan_photo_library_description")
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .foregroundColor(.gray)
                        
                        Button(action: {
                            analyzeDuplicates()
                        }) {
                            LocalizedText("start_scanning")
                                .foregroundColor(.white)
                                .padding(.horizontal, 30)
                                .padding(.vertical, 12)
                                .background(Color.blue)
                                .cornerRadius(8)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
                }
                else if storageState.duplicateGroups.isEmpty && storageState.hasAnalyzedDuplicates {
                    // No duplicates found
                    VStack(spacing: 20) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 48))
                            .foregroundColor(.green)
                        
                        LocalizedText("no_duplicates_found")
                            .font(.headline)
                        
                        LocalizedText("great_no_duplicates")
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .foregroundColor(.gray)
                        
                        Button(action: {
                            analyzeDuplicates()
                        }) {
                            LocalizedText("scan_again")
                                .foregroundColor(.blue)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
                }
                else {
                    // Show duplicate groups with proper spacing for delete button
                    ScrollView {
                        VStack(alignment: .leading, spacing: 0) {
                            // Summary
                            HStack {
                                Text("\(storageState.duplicateGroups.count) \(LocalizedStrings.string(for: "duplicate_groups_found", language: languageManager.currentLanguage))")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                
                                Spacer()
                                
                                if !storageState.selectedDuplicates.isEmpty {
                                    Button(action: {
                                        storageState.selectedDuplicates.removeAll()
                                    }) {
                                        LocalizedText("deselect_all")
                                            .font(.subheadline)
                                            .foregroundColor(.blue)
                                    }
                                }
                            }
                            .padding()
                            
                            // Potential savings
                            if !storageState.selectedDuplicates.isEmpty {
                                let savings = calculateSelectedSavings()
                                Text("\(LocalizedStrings.string(for: "potential_savings", language: languageManager.currentLanguage)): \(formatBytes(savings))")
                                    .font(.caption)
                                    .foregroundColor(.green)
                                    .padding(.horizontal)
                                    .padding(.bottom, 10)
                            }
                            
                            // Duplicate groups
                            ForEach(storageState.duplicateGroups) { group in
                                DuplicateGroupView(
                                    group: group,
                                    selectedDuplicates: $storageState.selectedDuplicates
                                )
                                .environmentObject(languageManager)
                                
                                Divider()
                                    .padding(.horizontal)
                            }
                            
                            // Bottom padding to prevent overlap with delete button
                            if !storageState.selectedDuplicates.isEmpty {
                                Color.clear.frame(height: 90)
                            } else {
                                Color.clear.frame(height: 20)
                            }
                        }
                    }
                }
                
                // Delete button positioned at bottom without overlapping
                if !storageState.selectedDuplicates.isEmpty && !storageState.isAnalyzingDuplicates {
                    deleteSelectedDuplicatesButtonFixed
                }
            }
        }
        

    
    private var deleteSelectedDuplicatesButtonFixed: some View {
            VStack(spacing: 0) {
                LinearGradient(
                    gradient: Gradient(colors: [Color.clear, Color(.systemBackground).opacity(0.9), Color(.systemBackground)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 20)
                
                Button(action: {
                    deleteSelectedDuplicates()
                }) {
                    VStack(spacing: 4) {
                        Text("\(LocalizedStrings.string(for: "delete", language: languageManager.currentLanguage)) \(storageState.selectedDuplicates.count) \(LocalizedStrings.string(for: "duplicates", language: languageManager.currentLanguage))")
                            .font(.headline)
                        Text("\(LocalizedStrings.string(for: "save", language: languageManager.currentLanguage)) \(formatBytes(calculateSelectedSavings()))")
                            .font(.caption)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(Color.red)
                    .cornerRadius(12)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 20)
                .background(Color(.systemBackground))
            }
            .transition(.move(edge: .bottom).combined(with: .opacity))
            .animation(.easeInOut(duration: 0.3), value: !storageState.selectedDuplicates.isEmpty)
        }
        
    

    // Add this method to update storage info
    private func updateStorageInfo() {
           let storageInfo = FileManager.default.deviceStorageInfo()
           storageState.totalStorage = storageInfo.total
           storageState.usedStorage = storageInfo.used
           storageState.freeStorage = storageInfo.free
       }
    
    // Helper method to format bytes into human-readable format
    private func formatBytes(_ bytes: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useGB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: bytes)
    }
    
    // MARK: - Photo Library Access
    private func requestPhotoAccess() {
         storageState.isLoading = true
         
         PHPhotoLibrary.requestAuthorization { status in
             DispatchQueue.main.async {
                 if status == .authorized || status == .limited {
                     storageState.photoAccessGranted = true
                     fetchMedia()
                 } else {
                     storageState.photoAccessGranted = false
                     storageState.isLoading = false
                 }
             }
         }
     }
    
   
    
//
    
    // Delete selected photos
//    private func deleteSelectedPhotos() {
//          guard !storageState.selectedMediaItems.isEmpty, storageState.photoAccessGranted else { return }
//          storageState.selectedMediaItems.removeAll()
//      }
    
//    private func deleteSelectedPhotos() {
//        guard !storageState.selectedMediaItems.isEmpty,
//              storageState.photoAccessGranted,
//              let photoAssets = storageState.photoAssets else {
//            return
//        }
//
//        // Convert selected IDs into PHAsset objects
//        let assetsToDelete = photoAssets.objects(at: IndexSet(0..<photoAssets.count)).filter {
//            storageState.selectedMediaItems.contains($0.localIdentifier)
//        }
//
//        PHPhotoLibrary.shared().performChanges({
//            PHAssetChangeRequest.deleteAssets(assetsToDelete as NSFastEnumeration)
//        }, completionHandler: { success, error in
//            DispatchQueue.main.async {
//                if success {
//                    print("Photos deleted")
//                    storageState.selectedMediaItems.removeAll()
//                } else if let error = error {
//                    print("Failed to delete photos: \(error.localizedDescription)")
//                }
//            }
//        })
//    }
    
//    private func deleteSelectedPhotos() {
//        guard !storageState.selectedMediaItems.isEmpty,
//              storageState.photoAccessGranted,
//              let oldPhotoAssets = storageState.photoAssets else {
//            return
//        }
//
//        // Convert selected IDs into PHAsset objects
//        let assetsToDelete = oldPhotoAssets.objects(at: IndexSet(0..<oldPhotoAssets.count)).filter {
//            storageState.selectedMediaItems.contains($0.localIdentifier)
//        }
//
//        PHPhotoLibrary.shared().performChanges({
//            PHAssetChangeRequest.deleteAssets(assetsToDelete as NSFastEnumeration)
//        }, completionHandler: { success, error in
//            DispatchQueue.main.async {
//                if success {
//                    print("Photos deleted")
//                    storageState.selectedMediaItems.removeAll()
//
//                    // ✅ Refresh photoAssets
//                    let allPhotosOptions = PHFetchOptions()
//                    allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
//                    let updatedAssets = PHAsset.fetchAssets(with: .image, options: allPhotosOptions)
//                    storageState.photoAssets = updatedAssets
//                } else if let error = error {
//                    print("Failed to delete photos: \(error.localizedDescription)")
//                }
//            }
//        })
    
//    private func deleteSelectedPhotos() {
//        guard !storageState.selectedMediaItems.isEmpty,
//              storageState.photoAccessGranted,
//              let result = storageState.photoAssets else { return }
//
//        let assetsToDelete = result.objects(at: IndexSet(0..<result.count)).filter {
//            storageState.selectedMediaItems.contains($0.localIdentifier)
//        }
//
//        PHPhotoLibrary.shared().performChanges({
//            PHAssetChangeRequest.deleteAssets(assetsToDelete as NSFastEnumeration)
//        }, completionHandler: { success, error in
//            DispatchQueue.main.async {
//                if success {
//                    storageState.selectedMediaItems.removeAll()
//
//                    // Refresh both photoAssets and mediaAssetsArray
//                    let fetchOptions = PHFetchOptions()
//                    fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
//                    let updatedResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
//
//                    storageState.photoAssets = updatedResult
//                    storageState.mediaAssetsArray = updatedResult.objects(at: IndexSet(0..<updatedResult.count))
//                } else {
//                    print("Delete error: \(error?.localizedDescription ?? "Unknown error")")
//                }
//            }
//        })
//    }
    
    private func deleteSelectedPhotos() {
        guard !storageState.selectedMediaItems.isEmpty,
              storageState.photoAccessGranted,
              let result = storageState.photoAssets else { return }

        let assetsToDelete = result.objects(at: IndexSet(0..<result.count)).filter {
            storageState.selectedMediaItems.contains($0.localIdentifier)
        }

        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.deleteAssets(assetsToDelete as NSFastEnumeration)
        }, completionHandler: { success, error in
            DispatchQueue.main.async {
                if success {
                    storageState.selectedMediaItems.removeAll()

                    // ✅ Refresh using the correct media type based on selected category
                    let fetchOptions = PHFetchOptions()
                    fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]

                    let currentCategory = storageState.selectedMediaCategory
                    let mediaType: PHAssetMediaType = currentCategory == "Photos" ? .image : .video
                    let updatedResult = PHAsset.fetchAssets(with: mediaType, options: fetchOptions)

                    storageState.photoAssets = updatedResult
                    storageState.mediaAssetsArray = updatedResult.objects(at: IndexSet(0..<updatedResult.count))
                } else {
                    print("Delete error: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        })
    }
    // MARK: - Duplicates Content View
//
    
    private var deleteSelectedDuplicatesButton: some View {
        Button(action: {
            deleteSelectedDuplicates()
        }) {
            VStack(spacing: 4) {
                Text("Delete \(storageState.selectedDuplicates.count) Duplicates")
                    .font(.headline)
                Text("Save \(formatBytes(calculateSelectedSavings()))")
                    .font(.caption)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .background(Color.red)
            .cornerRadius(8)
        }
        .padding(.horizontal)
        .padding(.bottom, 20)
        .transition(.opacity)
        .animation(.easeInOut(duration: 0.2), value: !storageState.selectedDuplicates.isEmpty)
    }
    private func requestPhotoAccessForDuplicates() {
            // Only proceed if we haven't already checked
            guard !storageState.hasCheckedDuplicatesAccess else { return }
            
            storageState.hasCheckedDuplicatesAccess = true
            
            PHPhotoLibrary.requestAuthorization { status in
                DispatchQueue.main.async {
                    if status == .authorized || status == .limited {
                        storageState.duplicatesAccessGranted = true
                    } else {
                        storageState.duplicatesAccessGranted = false
                    }
                }
            }
        }
    
   
    private func calculatePerceptualHash(image: UIImage) -> [Int] {
        // Resize to 8x8 and convert to grayscale
        let size = CGSize(width: 8, height: 8)
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        
        // Draw image in grayscale
        image.draw(in: CGRect(origin: .zero, size: size))
        guard let resizedImage = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return []
        }
        UIGraphicsEndImageContext()
        
        // Get pixel data
        guard let cgImage = resizedImage.cgImage,
              let data = cgImage.dataProvider?.data,
              let pixelData = CFDataGetBytePtr(data) else {
            return []
        }
        
        // Calculate average brightness
        var totalBrightness: Int = 0
        var pixels: [Int] = []
        
        for y in 0..<8 {
            for x in 0..<8 {
                let pixelIndex = (y * cgImage.bytesPerRow) + (x * 4)
                let r = Int(pixelData[pixelIndex])
                let g = Int(pixelData[pixelIndex + 1])
                let b = Int(pixelData[pixelIndex + 2])
                let brightness = (r + g + b) / 3
                pixels.append(brightness)
                totalBrightness += brightness
            }
        }
        
        let averageBrightness = totalBrightness / 64
        
        // Generate hash based on whether each pixel is above or below average
        return pixels.map { $0 > averageBrightness ? 1 : 0 }
    }
    
    private func analyzeDuplicates() {
        storageState.isAnalyzingDuplicates = true
        storageState.duplicateGroups.removeAll()
        storageState.selectedDuplicates.removeAll()
        storageState.analyzedPhotosCount = 0
        
        DispatchQueue.global(qos: .userInitiated).async {
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            let allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
            
            DispatchQueue.main.async {
                storageState.totalPhotosCount = allPhotos.count
            }
            
            // Store perceptual hashes with assets
            var assetHashes: [(asset: PHAsset, hash: [Int])] = []
            let imageManager = PHImageManager.default()
            let options = PHImageRequestOptions()
            options.isSynchronous = true
            options.deliveryMode = .fastFormat
            options.resizeMode = .fast
            
            // Process in batches to update progress
            let batchSize = 50
            for i in stride(from: 0, to: allPhotos.count, by: batchSize) {
                autoreleasepool {
                    let endIndex = min(i + batchSize, allPhotos.count)
                    
                    for j in i..<endIndex {
                        let asset = allPhotos[j]
                        
                        // Request small thumbnail for hash calculation
                        imageManager.requestImage(
                            for: asset,
                            targetSize: CGSize(width: 64, height: 64),
                            contentMode: .aspectFit,
                            options: options
                        ) { image, _ in
                            if let image = image {
                                let perceptualHash = self.calculatePerceptualHash(image: image)
                                assetHashes.append((asset: asset, hash: perceptualHash))
                            }
                        }
                    }
                    
                    DispatchQueue.main.async {
                        storageState.analyzedPhotosCount = endIndex
                    }
                }
            }
            
            // Group similar images using perceptual hash
            var duplicateGroupsDict: [String: [PHAsset]] = [:]
            var processedAssets = Set<String>()
            
            for i in 0..<assetHashes.count {
                let currentAsset = assetHashes[i]
                
                // Skip if already processed
                if processedAssets.contains(currentAsset.asset.localIdentifier) {
                    continue
                }
                
                var similarAssets = [currentAsset.asset]
                processedAssets.insert(currentAsset.asset.localIdentifier)
                
                // Find similar images
                for j in (i + 1)..<assetHashes.count {
                    let compareAsset = assetHashes[j]
                    
                    // Skip if already processed
                    if processedAssets.contains(compareAsset.asset.localIdentifier) {
                        continue
                    }
                    
                    // Calculate similarity (Hamming distance)
                    let distance = self.hammingDistance(hash1: currentAsset.hash, hash2: compareAsset.hash)
                    
                    // If similarity threshold met (adjust as needed)
                    if distance <= 5 { // Lower number = more similar
                        similarAssets.append(compareAsset.asset)
                        processedAssets.insert(compareAsset.asset.localIdentifier)
                    }
                }
                
                // Only create group if duplicates found
                if similarAssets.count > 1 {
                    let groupKey = UUID().uuidString
                    duplicateGroupsDict[groupKey] = similarAssets
                }
            }
            
            // Create DuplicatePhotoGroup objects
            let duplicateGroupsArray = duplicateGroupsDict.compactMap { (key, assets) -> DuplicatePhotoGroup? in
                guard assets.count > 1 else { return nil }
                
                // Sort by creation date and quality to determine best
                let sortedAssets = assets.sorted { asset1, asset2 in
                    // Prefer higher resolution
                    let pixels1 = asset1.pixelWidth * asset1.pixelHeight
                    let pixels2 = asset2.pixelWidth * asset2.pixelHeight
                    
                    if pixels1 != pixels2 {
                        return pixels1 > pixels2
                    }
                    
                    // Then by creation date (newer first)
                    if let date1 = asset1.creationDate, let date2 = asset2.creationDate {
                        return date1 > date2
                    }
                    
                    return false
                }
                
                var group = DuplicatePhotoGroup(hash: key, assets: sortedAssets)
                group.bestAsset = sortedAssets.first
                return group
            }
            
            DispatchQueue.main.async {
                storageState.duplicateGroups = duplicateGroupsArray.sorted { $0.potentialSavings > $1.potentialSavings }
                storageState.isAnalyzingDuplicates = false
                storageState.hasAnalyzedDuplicates = true
            }
        }
    }
    // MARK: - Perceptual Hash Calculation
   
    
    // MARK: - Hamming Distance
    private func hammingDistance(hash1: [Int], hash2: [Int]) -> Int {
        guard hash1.count == hash2.count else { return Int.max }
        
        var distance = 0
        for i in 0..<hash1.count {
            if hash1[i] != hash2[i] {
                distance += 1
            }
        }
        return distance
    }
    
    // MARK: - Calculate Savings
    private func calculateSelectedSavings() -> Int64 {
        var totalSavings: Int64 = 0
        
        for group in storageState.duplicateGroups {
            for asset in group.assets {
                if storageState.selectedDuplicates.contains(asset.localIdentifier) {
                    let resources = PHAssetResource.assetResources(for: asset)
                    if let resource = resources.first {
                        // Estimate size
                        let estimatedSize = Int64(Double(asset.pixelWidth * asset.pixelHeight) * 0.1)
                        totalSavings += estimatedSize
                    }
                }
            }
        }
        
        return totalSavings
    }
    
    // MARK: - Delete Selected Duplicates
    private func deleteSelectedDuplicates() {
        guard !storageState.selectedDuplicates.isEmpty else { return }
        
        PHPhotoLibrary.shared().performChanges({
            let assetsToDelete = storageState.duplicateGroups.flatMap { group in
                group.assets.filter { storageState.selectedDuplicates.contains($0.localIdentifier) }
            }
            PHAssetChangeRequest.deleteAssets(assetsToDelete as NSArray)
        }) { success, error in
            DispatchQueue.main.async {
                if success {
                    // Remove deleted items from groups
                    storageState.duplicateGroups = storageState.duplicateGroups.compactMap { group in
                        let remainingAssets = group.assets.filter { !storageState.selectedDuplicates.contains($0.localIdentifier) }
                        if remainingAssets.count > 1 {
                            var updatedGroup = group
                            updatedGroup.assets = remainingAssets
                            return updatedGroup
                        }
                        return nil
                    }
                    storageState.selectedDuplicates.removeAll()
                } else if let error = error {
                    print("Error deleting duplicates: \(error)")
                }
            }
        }
    }
    
    // MARK: - Clean Media View
    private var duplicatesContentView: some View {
        VStack {
            if storageState.isAnalyzingDuplicates {
                // Analyzing progress view
                VStack(spacing: 20) {
                    ProgressView()
                        .scaleEffect(1.5)
                    
                    Text("Analyzing photos for duplicates...")
                        .font(.headline)
                    
                    Text("\(storageState.analyzedPhotosCount) of \(storageState.totalPhotosCount) photos analyzed")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    // Progress bar
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 4)
                                .cornerRadius(2)
                            
                            Rectangle()
                                .fill(Color.blue)
                                .frame(width: geometry.size.width * CGFloat(storageState.analyzedPhotosCount) / CGFloat(max(storageState.totalPhotosCount, 1)), height: 4)
                                .cornerRadius(2)
                        }
                    }
                    .frame(height: 4)
                    .padding(.horizontal, 40)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
            }
            else if !storageState.duplicatesAccessGranted {
                // Permission view
                VStack(spacing: 20) {
                    Image(systemName: "photo.stack")
                        .font(.system(size: 48))
                        .foregroundColor(.gray)
                    
                    Text("Photo Access Required")
                        .font(.headline)
                    
                    Text("Please allow access to analyze your photos for duplicates.")
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Button("Grant Access") {
                        // Reset the check state to allow re-requesting
                        storageState.hasCheckedDuplicatesAccess = false
                        requestPhotoAccessForDuplicates()
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 12)
                    .background(Color.blue)
                    .cornerRadius(8)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
            }
            else if storageState.duplicateGroups.isEmpty && !storageState.hasAnalyzedDuplicates {
                // Initial state - show analyze button
                VStack(spacing: 20) {
                    Image(systemName: "photo.stack")
                        .font(.system(size: 48))
                        .foregroundColor(.blue)
                    
                    Text("Find Duplicate Photos")
                        .font(.headline)
                    
                    Text("Scan your photo library to find and remove duplicate images to free up storage space.")
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .foregroundColor(.gray)
                    
                    Button("Start Scanning") {
                        analyzeDuplicates()
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 12)
                    .background(Color.blue)
                    .cornerRadius(8)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
            }
            else if storageState.duplicateGroups.isEmpty && storageState.hasAnalyzedDuplicates {
                // No duplicates found
                VStack(spacing: 20) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 48))
                        .foregroundColor(.green)
                    
                    Text("No Duplicates Found")
                        .font(.headline)
                    
                    Text("Great! Your photo library doesn't have any duplicate images.")
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .foregroundColor(.gray)
                    
                    Button("Scan Again") {
                        analyzeDuplicates()
                    }
                    .foregroundColor(.blue)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
            }
            else {
                // Show duplicate groups
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        // Summary
                        HStack {
                            Text("\(storageState.duplicateGroups.count) duplicate groups found")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            Spacer()
                            
                            if !storageState.selectedDuplicates.isEmpty {
                                Button("Deselect All") {
                                    storageState.selectedDuplicates.removeAll()
                                }
                                .font(.subheadline)
                                .foregroundColor(.blue)
                            }
                        }
                        .padding()
                        
                        // Potential savings
                        if !storageState.selectedDuplicates.isEmpty {
                            let savings = calculateSelectedSavings()
                            Text("Potential savings: \(formatBytes(savings))")
                                .font(.caption)
                                .foregroundColor(.green)
                                .padding(.horizontal)
                                .padding(.bottom, 10)
                        }
                        
                        // Duplicate groups
                        ForEach(storageState.duplicateGroups) { group in
                            DuplicateGroupView(
                                group: group,
                                selectedDuplicates: $storageState.selectedDuplicates
                            )
                            
                            Divider()
                                .padding(.horizontal)
                        }
                        
                        // Bottom padding for delete button
                        Color.clear.frame(height: 100)
                    }
                }
            }
        }
    }

    private func getLocalizedCategoryName(_ category: String, singular: Bool = false) -> String {
           let key = category.lowercased()
           let localizedName = LocalizedStrings.string(for: key, language: languageManager.currentLanguage)
           return singular ? localizedName.singularForm(language: languageManager.currentLanguage) : localizedName
       }
    
//    private var cleanMediaViewFixed: some View {
//       
//        return VStack(spacing: 0) {
//                // Media category selection with localized names
//                HStack(spacing: 20) {
//                    ForEach(mediaCategories, id: \.self) { category in
//                                let localizedCategory = LocalizedStrings.string(for: category, language: languageManager.currentLanguage)
//                                mediaCategoryButton(category: localizedCategory)
//                            }
//                }
//                .padding(.horizontal)
//                .padding(.top, 15)
//                .padding(.bottom, 5)
//                
//                if storageState.isLoading {
//                    VStack(spacing: 10) {
//                        ProgressView()
//                        Text("\(LocalizedStrings.string(for: "loading", language: languageManager.currentLanguage)) \(getLocalizedCategoryName(storageState.selectedMediaCategory).lowercased())...")
//                            .foregroundColor(.gray)
//                    }
//                    .padding()
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//                } else if !storageState.photoAccessGranted {
//                    VStack(spacing: 20) {
//                        Image(systemName: "photo.on.rectangle.angled")
//                            .font(.system(size: 48))
//                            .foregroundColor(.gray)
//                        LocalizedText("photo_access_required")
//                            .font(.headline)
//                        LocalizedText("allow_access_photos_settings")
//                            .multilineTextAlignment(.center)
//                            .padding(.horizontal)
//                        Button(action: {
//                            if let url = URL(string: UIApplication.openSettingsURLString) {
//                                UIApplication.shared.open(url)
//                            }
//                        }) {
//                            LocalizedText("open_settings")
//                                .foregroundColor(.blue)
//                        }
//                    }
//                    .padding()
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//                }
//            else if !storageState.mediaAssetsArray.isEmpty {
//                // Selected count and media list
//                HStack {
//                    let selectedCount = storageState.selectedMediaItems.count
//                    let categoryName = getLocalizedCategoryName(storageState.selectedMediaCategory, singular: true)
//                    let pluralName = selectedCount == 1 ? categoryName : getLocalizedCategoryName(storageState.selectedMediaCategory)
//                    
//                    Text("\(selectedCount) \(pluralName) \(LocalizedStrings.string(for: "selected", language: languageManager.currentLanguage))")
//                        .font(.subheadline)
//                        .foregroundColor(.gray)
//                    Spacer()
//                    if selectedCount > 0 {
//                        Button(action: {
//                            storageState.selectedMediaItems.removeAll()
//                        }) {
//                            LocalizedText("deselect_all")
//                                .font(.subheadline)
//                                .foregroundColor(.blue)
//                        }
//                    }
//                }
//              
//                .padding(.horizontal)
//                .padding(.vertical, 10)
//                ScrollView {
//                    LazyVStack(spacing: 0) {
//                        ForEach(storageState.mediaAssetsArray, id: \.localIdentifier) { asset in
//                            AssetRow(
//                                asset: asset,
//                                isSelected: storageState.selectedMediaItems.contains(asset.localIdentifier),
//                                onTap: {
//                                    toggleSelection(id: asset.localIdentifier)
//                                }
//                            )
//                            Divider()
//                        }
//                        
//                        if !storageState.selectedMediaItems.isEmpty {
//                            Color.clear.frame(height: 90)
//                        } else {
//                            Color.clear.frame(height: 20)
//                        }
//                    }
//                  
//                }
//            } else {
//                    VStack(spacing: 20) {
//                        Image(systemName: categoryIcon(for: storageState.selectedMediaCategory))
//                            .font(.system(size: 48))
//                            .foregroundColor(.gray)
//                        
//                        Text("\(LocalizedStrings.string(for: "no", language: languageManager.currentLanguage)) \(getLocalizedCategoryName(storageState.selectedMediaCategory)) \(LocalizedStrings.string(for: "no_media_found", language: languageManager.currentLanguage))")
//                            .font(.headline)
//                        
//                        Text(LocalizedStrings.string(for: "no_media_found", language: languageManager.currentLanguage))
//                            .multilineTextAlignment(.center)
//                            .foregroundColor(.gray)
//                            .padding(.horizontal)
//                    }
//                    .padding()
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//                }
//                
//                // Delete button for clean media
//                if !storageState.selectedMediaItems.isEmpty {
//                    cleanMediaDeleteButtonFixed
//                }
//            }
//        }
        
    private var cleanMediaViewFixed: some View {
        VStack(spacing: 0) {
            // Media category selection
            HStack(spacing: 20) {
                ForEach(mediaCategories, id: \.self) { category in
                    let localizedCategory = LocalizedStrings.string(for: category, language: languageManager.currentLanguage)
                    mediaCategoryButton(category: localizedCategory)
                }
            }
            .padding(.horizontal)
            .padding(.top, 15)
            .padding(.bottom, 5)
            
            // Loading indicator
            if storageState.isLoading {
                VStack(spacing: 10) {
                    ProgressView()
                    Text("\(LocalizedStrings.string(for: "loading", language: languageManager.currentLanguage)) \(getLocalizedCategoryName(storageState.selectedMediaCategory).lowercased())...")
                        .foregroundColor(.gray)
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            // If photo permission is denied
            else if !storageState.photoAccessGranted && storageState.selectedMediaCategory != "Audio" {
                VStack(spacing: 20) {
                    Image(systemName: "photo.on.rectangle.angled")
                        .font(.system(size: 48))
                        .foregroundColor(.gray)
                    LocalizedText("photo_access_required")
                        .font(.headline)
                    LocalizedText("allow_access_photos_settings")
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    Button(action: {
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        LocalizedText("open_settings")
                            .foregroundColor(.blue)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            // AUDIO tab content
            else if storageState.selectedMediaCategory == "Audio" {
                if storageState.audioFiles.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: categoryIcon(for: "Audio"))
                            .font(.system(size: 48))
                            .foregroundColor(.gray)

                        Text("\(LocalizedStrings.string(for: "no", language: languageManager.currentLanguage)) \(getLocalizedCategoryName("Audio")) \(LocalizedStrings.string(for: "no_media_found", language: languageManager.currentLanguage))")
                            .font(.headline)

                        Text(LocalizedStrings.string(for: "no_media_found", language: languageManager.currentLanguage))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(storageState.audioFiles, id: \.self) { audioURL in
                            Text(audioURL.lastPathComponent)
                                .font(.body)
                        }
                    }
                }
            }
            
            // PHOTO/VIDEO tab content
            else if !storageState.mediaAssetsArray.isEmpty {
                // Selected count and deselect
                HStack {
                    let selectedCount = storageState.selectedMediaItems.count
                    let categoryName = getLocalizedCategoryName(storageState.selectedMediaCategory, singular: true)
                    let pluralName = selectedCount == 1 ? categoryName : getLocalizedCategoryName(storageState.selectedMediaCategory)

                    Text("\(selectedCount) \(pluralName) \(LocalizedStrings.string(for: "selected", language: languageManager.currentLanguage))")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Spacer()
                    if selectedCount > 0 {
                        Button(action: {
                            storageState.selectedMediaItems.removeAll()
                        }) {
                            LocalizedText("deselect_all")
                                .font(.subheadline)
                                .foregroundColor(.blue)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 10)

                // Media list
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(storageState.mediaAssetsArray, id: \.localIdentifier) { asset in
                            AssetRow(
                                asset: asset,
                                isSelected: storageState.selectedMediaItems.contains(asset.localIdentifier),
                                onTap: {
                                    toggleSelection(id: asset.localIdentifier)
                                }
                            )
                            Divider()
                        }

                        if !storageState.selectedMediaItems.isEmpty {
                            Color.clear.frame(height: 90)
                        } else {
                            Color.clear.frame(height: 20)
                        }
                    }
                }
            }

            // Empty state for photos/videos
            else {
                VStack(spacing: 20) {
                    Image(systemName: categoryIcon(for: storageState.selectedMediaCategory))
                        .font(.system(size: 48))
                        .foregroundColor(.gray)

                    Text("\(LocalizedStrings.string(for: "no", language: languageManager.currentLanguage)) \(getLocalizedCategoryName(storageState.selectedMediaCategory)) \(LocalizedStrings.string(for: "no_media_found", language: languageManager.currentLanguage))")
                        .font(.headline)

                    Text(LocalizedStrings.string(for: "no_media_found", language: languageManager.currentLanguage))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }

            // Delete button (only for photo/video)
            if storageState.selectedMediaCategory != "Audio",
               !storageState.selectedMediaItems.isEmpty {
                cleanMediaDeleteButtonFixed
            }
        }
    }
    private func deleteButtonTitleKey(for category: String) -> String {
        switch category {
        case "Photos":
            return "delete_selected_photos"
        case "Videos":
            return "delete_selected_videos"
        case "Audio":
            return "delete_selected_audio"
        default:
            return "delete_selected_photos"
        }
    }
    
    private var cleanMediaDeleteButtonFixed: some View {
            VStack(spacing: 0) {
                LinearGradient(
                    gradient: Gradient(colors: [Color.clear, Color(.systemBackground).opacity(0.9), Color(.systemBackground)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 20)
                
                Button(action: {
                    deleteSelectedPhotos()
                }) {
                    Text(LocalizedStrings.string(for: deleteButtonTitleKey(for: storageState.selectedMediaCategory),
                                                  language: languageManager.currentLanguage))
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(Color.blue)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 20)
                .background(Color(.systemBackground))
            }
            .transition(.move(edge: .bottom).combined(with: .opacity))
            .animation(.easeInOut(duration: 0.3), value: !storageState.selectedMediaItems.isEmpty)
        }

    // Helper method for media selection
    private func toggleSelection(id: String) {
        if storageState.selectedMediaItems.contains(id) {
            storageState.selectedMediaItems.remove(id)
        } else {
            storageState.selectedMediaItems.insert(id)
        }
    }
   
    // Media category button
    private func mediaCategoryButton(category: String) -> some View {
        VStack {
            Button(action: {
                print("Switching to category: \(category)")
                if storageState.selectedMediaCategory != category {
                    storageState.selectedMediaCategory = category
                    storageState.isLoading = true
                    storageState.selectedMediaItems.removeAll() // Clear selections when changing categories
                    
                    // Reset photo assets to trigger reload
                    storageState.photoAssets = nil
                    
                    // Fetch new media type
                    fetchMedia()
                }
            }) {
                VStack(spacing: 8) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                            .frame(width: 100, height: 80)
                        
                        Image(systemName: categoryIcon(for: category))
                            .font(.system(size: 24))
                            .foregroundColor(storageState.selectedMediaCategory == category ? .blue : .gray)
                    }
                    
                    Text(category)
                        .font(.subheadline)
                        .foregroundColor(storageState.selectedMediaCategory == category ? .blue : .primary)
                }
            }
            
            // Indicator for selected category
            Rectangle()
                .fill(storageState.selectedMediaCategory == category ? Color.blue : Color.clear)
                .frame(height: 2)
                .cornerRadius(1)
        }
    }

    // Helper function to get icon for category
    private func categoryIcon(for category: String) -> String {
        switch category {
        case "Photos":
            return "photo"
        case "Videos":
            return "video"
        case "Audio":
            return "music.note"
        default:
            return "doc"
        }
    }
    
 
    
    // MARK: - Storage Analysis Section
//    private func fetchMedia() {
//        storageState.isLoading = true
//        
//        if storageState.selectedMediaCategory == "Audio" {
//            // For audio, we'll look for audio files in the device
//            fetchAudioFiles()
//        } else {
//            // For photos and videos, use the Photos framework
//            let options = PHFetchOptions()
//            options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
//            
//            DispatchQueue.global(qos: .userInitiated).async {
//                let mediaType: PHAssetMediaType = storageState.selectedMediaCategory == "Photos" ? .image : .video
//                
//                print("Fetching media type: \(mediaType.rawValue) for category: \(storageState.selectedMediaCategory)")
//                
//                let assets = PHAsset.fetchAssets(with: mediaType, options: options)
//                
//                print("Found \(assets.count) \(storageState.selectedMediaCategory.lowercased())")
//                
//                DispatchQueue.main.async {
//                    storageState.photoAssets = assets
//                    storageState.isLoading = false
//                    
//                    if assets.count == 0 {
//                        print("No \(storageState.selectedMediaCategory.lowercased()) found in photo library")
//                    }
//                }
//            }
//        }
//    }
//    
    
    private func fetchMedia() {
        storageState.isLoading = true

        if storageState.selectedMediaCategory == "Audio" {
            // For audio, we'll look for audio files in the device
            fetchAudioFiles()
        } else {
            // For photos and videos, use the Photos framework
            let options = PHFetchOptions()
            options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            
            DispatchQueue.global(qos: .userInitiated).async {
                let mediaType: PHAssetMediaType = storageState.selectedMediaCategory == "Photos" ? .image : .video
                
                print("Fetching media type: \(mediaType.rawValue) for category: \(storageState.selectedMediaCategory)")
                
                let assets = PHAsset.fetchAssets(with: mediaType, options: options)
                
                print("Found \(assets.count) \(storageState.selectedMediaCategory.lowercased())")
                
                // ✅ Convert fetch result to an array SwiftUI can observe
                let assetArray = assets.objects(at: IndexSet(0..<assets.count))

                DispatchQueue.main.async {
                    storageState.photoAssets = assets
                    storageState.mediaAssetsArray = assetArray // <-- this enables live UI update
                    storageState.isLoading = false
                    
                    if assets.count == 0 {
                        print("No \(storageState.selectedMediaCategory.lowercased()) found in photo library")
                    }
                }
            }
        }
    }
    
    private func scanForAudioFiles() -> [URL] {
        var audioFiles: [URL] = []
        
        // Common audio file extensions
        let audioExtensions = ["mp3", "m4a", "wav", "aac", "flac", "ogg"]
        
        // Scan Documents directory
        if let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            audioFiles.append(contentsOf: findAudioFiles(in: documentsPath, extensions: audioExtensions))
        }
        
        // Scan Downloads directory (if accessible)
        if let downloadsPath = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first {
            audioFiles.append(contentsOf: findAudioFiles(in: downloadsPath, extensions: audioExtensions))
        }
        
        return audioFiles
    }
    
    private func findAudioFiles(in directory: URL, extensions: [String]) -> [URL] {
        var audioFiles: [URL] = []
        
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(
                at: directory,
                includingPropertiesForKeys: [.isRegularFileKey, .fileSizeKey, .creationDateKey],
                options: .skipsHiddenFiles
            )
            
            for fileURL in fileURLs {
                let fileExtension = fileURL.pathExtension.lowercased()
                if extensions.contains(fileExtension) {
                    audioFiles.append(fileURL)
                }
            }
        } catch {
            print("Error scanning directory \(directory): \(error)")
        }
        
        return audioFiles
    }
//    private func fetchAudioFiles() {
//        DispatchQueue.global(qos: .userInitiated).async {
//            // Create dummy PHFetchResult for audio files
//            // In a real implementation, you'd scan the file system for audio files
//            let audioFiles = self.scanForAudioFiles()
//            
//            DispatchQueue.main.async {
//                // For now, we'll create an empty result to show the "no audio found" message
//                // with helpful information about where audio files are typically stored
//                storageState.photoAssets = PHAsset.fetchAssets(with: .audio, options: PHFetchOptions())
//                storageState.isLoading = false
//                
//                print("Audio scanning complete. Found \(audioFiles.count) audio files")
//            }
//        }
//    }
    
    private func fetchAudioFiles() {
        DispatchQueue.global(qos: .userInitiated).async {
            let audioFiles = self.scanForAudioFiles()
            
            DispatchQueue.main.async {
                storageState.audioFiles = audioFiles
                storageState.isLoading = false
                storageState.photoAssets = nil // Clear old data
                
                print("Audio scanning complete. Found \(audioFiles.count) audio files")
            }
        }
    }
   
        private func storageItem(color: Color, title: String, value: String) -> some View {
            HStack(spacing: 6) {
                Circle()
                    .fill(color)
                    .frame(width: 8, height: 8)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(value)
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
            }
        }
        
        private func toggleContactSelection(id: String) {
            if selectedContacts.contains(id) {
                selectedContacts.remove(id)
            } else {
                selectedContacts.insert(id)
            }
        }
    }


    //struct AssetRow: View {
    //    let asset: PHAsset
    //    let isSelected: Bool
    //    let onTap: () -> Void
    //
    //    @State private var thumbnail: UIImage?
    //    @State private var fileName: String = ""
    //    @State private var fileSize: String = ""
    //    @State private var isLoadingThumbnail = true
    //
    //    var body: some View {
    //        Button(action: onTap) {
    //            HStack(spacing: 12) {
    //                // Thumbnail - different display for each media type
    //                if asset.mediaType == .audio {
    //                    // Specialized audio thumbnail
    //                    ZStack {
    //                        Rectangle()
    //                            .fill(Color.blue.opacity(0.1))
    //                            .frame(width: 60, height: 60)
    //                            .cornerRadius(4)
    //
    //                        Image(systemName: "music.note")
    //                            .font(.system(size: 24))
    //                            .foregroundColor(.blue)
    //                    }
    //                } else if asset.mediaType == .video {
    //                    // Video thumbnail with duration indicator
    //                    ZStack(alignment: .bottomTrailing) {
    //                        if isLoadingThumbnail && thumbnail == nil {
    //                            Rectangle()
    //                                .fill(Color.gray.opacity(0.2))
    //                                .frame(width: 60, height: 60)
    //                                .cornerRadius(4)
    //                                .overlay(
    //                                    ProgressView()
    //                                        .scaleEffect(0.8)
    //                                )
    //                        } else if let image = thumbnail {
    //                            Image(uiImage: image)
    //                                .resizable()
    //                                .aspectRatio(contentMode: .fill)
    //                                .frame(width: 60, height: 60)
    //                                .cornerRadius(4)
    //                                .clipped()
    //                        } else {
    //                            Rectangle()
    //                                .fill(Color.gray.opacity(0.3))
    //                                .frame(width: 60, height: 60)
    //                                .cornerRadius(4)
    //                                .overlay(
    //                                    Image(systemName: "video")
    //                                        .foregroundColor(.gray)
    //                                )
    //                        }
    //
    //                        // Video duration label and play icon
    //                        HStack(spacing: 2) {
    //                            Image(systemName: "play.fill")
    //                                .font(.system(size: 8))
    //                                .foregroundColor(.white)
    //
    //                            Text(formatDuration(asset.duration))
    //                                .font(.system(size: 10, weight: .medium))
    //                                .foregroundColor(.white)
    //                        }
    //                        .padding(.horizontal, 4)
    //                        .padding(.vertical, 2)
    //                        .background(Color.black.opacity(0.7))
    //                        .cornerRadius(3)
    //                        .padding(4)
    //                    }
    //                } else {
    //                    // Standard photo thumbnail
    //                    if isLoadingThumbnail && thumbnail == nil {
    //                        Rectangle()
    //                            .fill(Color.gray.opacity(0.2))
    //                            .frame(width: 60, height: 60)
    //                            .cornerRadius(4)
    //                            .overlay(
    //                                ProgressView()
    //                                    .scaleEffect(0.8)
    //                            )
    //                    } else if let image = thumbnail {
    //                        Image(uiImage: image)
    //                            .resizable()
    //                            .aspectRatio(contentMode: .fill)
    //                            .frame(width: 60, height: 60)
    //                            .cornerRadius(4)
    //                            .clipped()
    //                    } else {
    //                        Rectangle()
    //                            .fill(Color.gray.opacity(0.3))
    //                            .frame(width: 60, height: 60)
    //                            .cornerRadius(4)
    //                            .overlay(
    //                                Image(systemName: "photo")
    //                                    .foregroundColor(.gray)
    //                            )
    //                    }
    //                }
    //
    //                // Details
    //                VStack(alignment: .leading, spacing: 2) {
    //                    Text(fileName)
    //                        .font(.system(size: 16))
    //                        .foregroundColor(.primary)
    //                        .lineLimit(1)
    //
    //                    HStack {
    //                        if asset.mediaType == .audio {
    //                            Text("Duration")
    //                                .foregroundColor(.gray)
    //                                .font(.system(size: 14))
    //
    //                            Text(formatDuration(asset.duration))
    //                                .foregroundColor(.gray)
    //                                .font(.system(size: 14))
    //                        } else if asset.mediaType == .video {
    //                            Text("Duration")
    //                                .foregroundColor(.gray)
    //                                .font(.system(size: 14))
    //
    //                            Text(formatDuration(asset.duration))
    //                                .foregroundColor(.gray)
    //                                .font(.system(size: 14))
    //
    //                            Text("•")
    //                                .foregroundColor(.gray)
    //                                .font(.system(size: 14))
    //
    //                            Text("\(asset.pixelWidth)×\(asset.pixelHeight)")
    //                                .foregroundColor(.gray)
    //                                .font(.system(size: 14))
    //                        } else {
    //                            Text("Taken")
    //                                .foregroundColor(.gray)
    //                                .font(.system(size: 14))
    //
    //                            Text(formattedDate)
    //                                .foregroundColor(.gray)
    //                                .font(.system(size: 14))
    //                        }
    //                    }
    //
    //                    Text(fileSize)
    //                        .foregroundColor(.gray)
    //                        .font(.system(size: 14))
    //                }
    //
    //                Spacer()
    //
    //                // Selection indicator
    //                ZStack {
    //                    Circle()
    //                        .fill(isSelected ? Color.blue : Color.clear)
    //                        .frame(width: 24, height: 24)
    //
    //                    if isSelected {
    //                        Image(systemName: "checkmark")
    //                            .foregroundColor(.white)
    //                            .font(.system(size: 12, weight: .bold))
    //                    } else {
    //                        Circle()
    //                            .strokeBorder(Color.gray, lineWidth: 1)
    //                            .frame(width: 24, height: 24)
    //                    }
    //                }
    //            }
    //            .padding(.vertical, 10)
    //            .padding(.horizontal, 16)
    //        }
    //        .buttonStyle(PlainButtonStyle())
    //        .onAppear {
    //            loadAssetInfo()
    //            // Load thumbnail for both photos and videos
    //            if asset.mediaType != .audio {
    //                loadThumbnail()
    //            } else {
    //                isLoadingThumbnail = false
    //            }
    //        }
    //    }
struct AssetRow: View {
    let asset: PHAsset
    let isSelected: Bool
    let onTap: () -> Void
    @EnvironmentObject var languageManager: LanguageManager

    @State private var thumbnail: UIImage?
    @State private var fileName: String = ""
    @State private var fileSize: String = ""
    @State private var isLoadingThumbnail = true
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                // Thumbnail display (keep existing code)
                if asset.mediaType == .audio {
                    ZStack {
                        Rectangle()
                            .fill(Color.blue.opacity(0.1))
                            .frame(width: 60, height: 60)
                            .cornerRadius(4)
                        
                        Image(systemName: "music.note")
                            .font(.system(size: 24))
                            .foregroundColor(.blue)
                    }
                } else if asset.mediaType == .video {
                    ZStack(alignment: .bottomTrailing) {
                        if isLoadingThumbnail && thumbnail == nil {
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 60, height: 60)
                                .cornerRadius(4)
                                .overlay(ProgressView().scaleEffect(0.8))
                        } else if let image = thumbnail {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 60, height: 60)
                                .cornerRadius(4)
                                .clipped()
                        } else {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 60, height: 60)
                                .cornerRadius(4)
                                .overlay(Image(systemName: "video").foregroundColor(.gray))
                        }
                        
                        HStack(spacing: 2) {
                            Image(systemName: "play.fill")
                                .font(.system(size: 8))
                                .foregroundColor(.white)
                            
                            Text(formatDuration(asset.duration))
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 4)
                        .padding(.vertical, 2)
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(3)
                        .padding(4)
                    }
                } else {
                    if isLoadingThumbnail && thumbnail == nil {
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 60, height: 60)
                            .cornerRadius(4)
                            .overlay(ProgressView().scaleEffect(0.8))
                    } else if let image = thumbnail {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 60, height: 60)
                            .cornerRadius(4)
                            .clipped()
                    } else {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 60, height: 60)
                            .cornerRadius(4)
                            .overlay(Image(systemName: "photo").foregroundColor(.gray))
                    }
                }
                
                // Details with translations
                VStack(alignment: .leading, spacing: 2) {
                    Text(fileName)
                        .font(.system(size: 16))
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    
                    HStack {
                        if asset.mediaType == .audio {
                            Text(LocalizedStrings.string(for: "duration", language: languageManager.currentLanguage))
                                .foregroundColor(.gray)
                                .font(.system(size: 14))
                            
                            Text(formatDuration(asset.duration))
                                .foregroundColor(.gray)
                                .font(.system(size: 14))
                        } else if asset.mediaType == .video {
                            Text(LocalizedStrings.string(for: "duration", language: languageManager.currentLanguage))
                                .foregroundColor(.gray)
                                .font(.system(size: 14))
                            
                            Text(formatDuration(asset.duration))
                                .foregroundColor(.gray)
                                .font(.system(size: 14))
                            
                            Text("•")
                                .foregroundColor(.gray)
                                .font(.system(size: 14))
                            
                            Text("\(asset.pixelWidth)×\(asset.pixelHeight)")
                                .foregroundColor(.gray)
                                .font(.system(size: 14))
                        } else {
                            Text(LocalizedStrings.string(for: "taken", language: languageManager.currentLanguage))
                                .foregroundColor(.gray)
                                .font(.system(size: 14))
                            
                            Text(formattedDate)
                                .foregroundColor(.gray)
                                .font(.system(size: 14))
                        }
                    }
                    
                    Text(fileSize)
                        .foregroundColor(.gray)
                        .font(.system(size: 14))
                }
                
                Spacer()
                
                // Selection indicator (keep existing)
                ZStack {
                    Circle()
                        .fill(isSelected ? Color.blue : Color.clear)
                        .frame(width: 24, height: 24)
                    
                    if isSelected {
                        Image(systemName: "checkmark")
                            .foregroundColor(.white)
                            .font(.system(size: 12, weight: .bold))
                    } else {
                        Circle()
                            .strokeBorder(Color.gray, lineWidth: 1)
                            .frame(width: 24, height: 24)
                    }
                }
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 16)
        }
        .buttonStyle(PlainButtonStyle())
        .onAppear {
            loadAssetInfo()
            if asset.mediaType != .audio {
                loadThumbnail()
            } else {
                isLoadingThumbnail = false
            }
        }
    }
     
    
//    private var formattedDate: String {
//          let formatter = DateFormatter()
//          formatter.dateFormat = "MM/dd/yyyy"
//          if let date = asset.creationDate {
//              return formatter.string(from: date)
//          }
//          return "Unknown"
//      }
    
    private var formattedDate: String {
           let formatter = DateFormatter()
           formatter.dateFormat = "MM/dd/yyyy"
           if let date = asset.creationDate {
               return formatter.string(from: date)
           }
           return LocalizedStrings.string(for: "unknown", language: languageManager.currentLanguage)
       }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
           let hours = Int(duration) / 3600
           let minutes = (Int(duration) % 3600) / 60
           let seconds = Int(duration) % 60
           
           if hours > 0 {
               return String(format: "%d:%02d:%02d", hours, minutes, seconds)
           } else {
               return String(format: "%d:%02d", minutes, seconds)
           }
       }
    
    private func loadThumbnail() {
            let manager = PHImageManager.default()
            let options = PHImageRequestOptions()
            options.deliveryMode = .opportunistic
            options.resizeMode = .exact
            options.isNetworkAccessAllowed = true
            options.isSynchronous = false
            
            // For videos, we need to specifically request video thumbnails
            if asset.mediaType == .video {
                let videoOptions = PHVideoRequestOptions()
                videoOptions.isNetworkAccessAllowed = true
                
                manager.requestAVAsset(forVideo: asset, options: videoOptions) { avAsset, audioMix, info in
                    guard let avAsset = avAsset else {
                        DispatchQueue.main.async {
                            self.isLoadingThumbnail = false
                        }
                        return
                    }
                    
                    let imageGenerator = AVAssetImageGenerator(asset: avAsset)
                    imageGenerator.appliesPreferredTrackTransform = true
                    imageGenerator.maximumSize = CGSize(width: 120, height: 120)
                    
                    do {
                        let cgImage = try imageGenerator.copyCGImage(at: CMTime.zero, actualTime: nil)
                        let thumbnail = UIImage(cgImage: cgImage)
                        
                        DispatchQueue.main.async {
                            self.thumbnail = thumbnail
                            self.isLoadingThumbnail = false
                        }
                    } catch {
                        print("Error generating video thumbnail: \(error)")
                        DispatchQueue.main.async {
                            self.isLoadingThumbnail = false
                        }
                    }
                }
            } else {
                // For photos, use the regular image request
                manager.requestImage(
                    for: asset,
                    targetSize: CGSize(width: 120, height: 120),
                    contentMode: .aspectFill,
                    options: options
                ) { image, _ in
                    DispatchQueue.main.async {
                        self.thumbnail = image
                        self.isLoadingThumbnail = false
                    }
                }
            }
        }
    
    // Load asset metadata
    private func loadAssetInfo() {
            let resources = PHAssetResource.assetResources(for: asset)
            if let resource = resources.first {
                self.fileName = resource.originalFilename
                
                // Better size estimation for different media types
                let sizeInBytes: Int64
                if asset.mediaType == .image {
                    sizeInBytes = Int64(Double(asset.pixelWidth * asset.pixelHeight) * 0.1)
                } else if asset.mediaType == .video {
                    // More accurate video size estimation based on duration and resolution
                    let pixelCount = asset.pixelWidth * asset.pixelHeight
                    let bitrate = Double(pixelCount) * 0.5 // Estimated bitrate per pixel
                    sizeInBytes = Int64(asset.duration * bitrate)
                } else {
                    sizeInBytes = Int64(asset.duration * 500000) // Audio estimation
                }
                
                let formatter = ByteCountFormatter()
                formatter.allowedUnits = [.useKB, .useMB, .useGB]
                formatter.countStyle = .file
                self.fileSize = formatter.string(fromByteCount: sizeInBytes)
            } else {
                self.fileName = "\(asset.mediaType == .video ? "Video" : "Photo") \(asset.localIdentifier.suffix(8))"
                self.fileSize = "Unknown"
            }
        }
    }

// MARK: - Duplicate Group View
struct DuplicateGroupView: View {
    let group: DuplicatePhotoGroup
    @Binding var selectedDuplicates: Set<String>
    @EnvironmentObject var languageManager: LanguageManager
    @State private var isExpanded = false
    @State private var thumbnails: [String: UIImage] = [:]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header with best photo
            HStack(spacing: 12) {
                // Best photo thumbnail (keep existing code)
                if let bestAsset = group.bestAsset {
                    ZStack(alignment: .topLeading) {
                        if let thumbnail = thumbnails[bestAsset.localIdentifier] {
                            Image(uiImage: thumbnail)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 80, height: 80)
                                .cornerRadius(8)
                                .clipped()
                        } else {
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 80, height: 80)
                                .cornerRadius(8)
                                .overlay(ProgressView())
                        }
                        
                        // Best badge with translation
                        Text(LocalizedStrings.string(for: "best", language: languageManager.currentLanguage))
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.green)
                            .cornerRadius(4)
                            .padding(4)
                    }
                }
                
                // Info with translations
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(group.assets.count) \(LocalizedStrings.string(for: "photos", language: languageManager.currentLanguage))")
                        .font(.headline)
                    
                    Text("\(LocalizedStrings.string(for: "potential_savings", language: languageManager.currentLanguage)): \(formatBytes(group.potentialSavings))")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    if let bestAsset = group.bestAsset {
                        Text("\(bestAsset.pixelWidth) × \(bestAsset.pixelHeight) px")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
                
                // Expand/Collapse button
                Button(action: {
                    withAnimation {
                        isExpanded.toggle()
                    }
                }) {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal)
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation {
                    isExpanded.toggle()
                }
            }
            
            // Expanded duplicates
            if isExpanded {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(group.assets.filter { $0 != group.bestAsset }, id: \.localIdentifier) { asset in
                            DuplicatePhotoItemView(
                                asset: asset,
                                isSelected: selectedDuplicates.contains(asset.localIdentifier),
                                thumbnail: thumbnails[asset.localIdentifier]
                            ) {
                                toggleDuplicateSelection(asset.localIdentifier)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .padding(.vertical, 8)
        .onAppear {
            loadThumbnails()
        }
    }
    
    private func loadThumbnails() {
            let manager = PHImageManager.default()
            let options = PHImageRequestOptions()
            options.deliveryMode = .opportunistic
            options.resizeMode = .exact
            options.isNetworkAccessAllowed = true
            
            for asset in group.assets {
                manager.requestImage(
                    for: asset,
                    targetSize: CGSize(width: 160, height: 160),
                    contentMode: .aspectFill,
                    options: options
                ) { image, _ in
                    if let image = image {
                        DispatchQueue.main.async {
                            self.thumbnails[asset.localIdentifier] = image
                        }
                    }
                }
            }
        }
    
    private func toggleDuplicateSelection(_ id: String) {
        if selectedDuplicates.contains(id) {
            selectedDuplicates.remove(id)
        } else {
            selectedDuplicates.insert(id)
        }
    }
    
    private func formatBytes(_ bytes: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useKB, .useMB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: bytes)
    }
}

// MARK: - Duplicate Photo Item View
struct DuplicatePhotoItemView: View {
    let asset: PHAsset
    let isSelected: Bool
    let thumbnail: UIImage?
    let onTap: () -> Void
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 4) {
                // Thumbnail
                if let thumbnail = thumbnail {
                    Image(uiImage: thumbnail)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 80, height: 80)
                        .cornerRadius(8)
                        .clipped()
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 80, height: 80)
                        .cornerRadius(8)
                        .overlay(
                            ProgressView()
                        )
                }
                
                // Info
                VStack(spacing: 2) {
                    Text("\(asset.pixelWidth)×\(asset.pixelHeight)")
                        .font(.system(size: 10))
                        .foregroundColor(.gray)
                    
                    if let date = asset.creationDate {
                        Text(dateFormatter.string(from: date))
                            .font(.system(size: 10))
                            .foregroundColor(.gray)
                    }
                }
            }
            
            // Selection checkbox
            ZStack {
                Circle()
                    .fill(isSelected ? Color.red : Color.black.opacity(0.5))
                    .frame(width: 24, height: 24)
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(.white)
                        .font(.system(size: 12, weight: .bold))
                } else {
                    Circle()
                        .strokeBorder(Color.white, lineWidth: 2)
                        .frame(width: 22, height: 22)
                }
            }
            .padding(4)
        }
        .onTapGesture {
            onTap()
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        return formatter
    }
}

// MARK: - Contacts Cleanup View


// MARK: - Event Row
struct EventRow: View {
    let event: EKEvent
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                // Calendar color indicator
                Rectangle()
                    .fill(Color(event.calendar.cgColor))
                    .frame(width: 4, height: 50)
                    .cornerRadius(2)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(event.title ?? "Untitled Event")
                        .font(.system(size: 16))
                        .foregroundColor(.primary)
                    
                    if let startDate = event.startDate {
                        Text(dateFormatter.string(from: startDate))
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                    
                    Text(event.calendar.title)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                // Selection indicator
                ZStack {
                    Circle()
                        .fill(isSelected ? Color.red : Color.clear)
                        .frame(width: 24, height: 24)
                    
                    if isSelected {
                        Image(systemName: "checkmark")
                            .foregroundColor(.white)
                            .font(.system(size: 12, weight: .bold))
                    } else {
                        Circle()
                            .strokeBorder(Color.gray, lineWidth: 1)
                            .frame(width: 24, height: 24)
                    }
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }
}

// MARK: - Extensions
extension FileManager {
    func deviceStorageInfo() -> (total: Int64, used: Int64, free: Int64) {
        let fileURL = URL(fileURLWithPath: NSHomeDirectory() as String)
        do {
            let values = try fileURL.resourceValues(forKeys: [.volumeTotalCapacityKey, .volumeAvailableCapacityKey, .volumeAvailableCapacityForImportantUsageKey])
            
            // Get the total capacity, defaulting to 0 if nil
            let totalCapacity: Int64 = values.volumeTotalCapacity.map { Int64($0) } ?? 0
            
            // Try to get volumeAvailableCapacityForImportantUsage first, then fall back to volumeAvailableCapacity
            let availableCapacity: Int64
            if let importantUsage = values.volumeAvailableCapacityForImportantUsage {
                availableCapacity = Int64(importantUsage)
            } else if let regularAvailable = values.volumeAvailableCapacity {
                availableCapacity = Int64(regularAvailable)
            } else {
                availableCapacity = 0
            }
            
            let usedCapacity = totalCapacity - availableCapacity
            return (totalCapacity, usedCapacity, availableCapacity)
        } catch {
            print("Error retrieving storage info: \(error)")
        }
        return (0, 0, 0)
    }
}

extension CNContact {
    var initials: String {
        let first = givenName.first.map { String($0) } ?? ""
        let last = familyName.first.map { String($0) } ?? ""
        return (first + last).uppercased()
    }
}
