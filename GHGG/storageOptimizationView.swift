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

//extension FileManager {
//    func deviceStorageInfo() -> (total: Int64, used: Int64, free: Int64) {
//        let fileURL = URL(fileURLWithPath: NSHomeDirectory() as String)
//        do {
//            let values = try fileURL.resourceValues(forKeys: [.volumeTotalCapacityKey, .volumeAvailableCapacityKey, .volumeAvailableCapacityForImportantUsageKey])
//            
//            // Get the total capacity, defaulting to 0 if nil
//            let totalCapacity: Int64 = values.volumeTotalCapacity.map { Int64($0) } ?? 0
//            
//            // Try to get volumeAvailableCapacityForImportantUsage first, then fall back to volumeAvailableCapacity
//            let availableCapacity: Int64
//            if let importantUsage = values.volumeAvailableCapacityForImportantUsage {
//                availableCapacity = Int64(importantUsage)
//            } else if let regularAvailable = values.volumeAvailableCapacity {
//                availableCapacity = Int64(regularAvailable)
//            } else {
//                availableCapacity = 0
//            }
//            
//            let usedCapacity = totalCapacity - availableCapacity
//            return (totalCapacity, usedCapacity, availableCapacity)
//        } catch {
//            print("Error retrieving storage info: \(error)")
//        }
//        return (0, 0, 0)
//    }
//}
//
//// MARK: - Duplicate Photo Model
//struct DuplicatePhotoGroup: Identifiable {
//    let id = UUID()
//    let hash: String
//    var assets: [PHAsset]
//    var bestAsset: PHAsset? // The one to keep
//    
//    var totalSize: Int64 {
//        assets.reduce(0) { sum, asset in
//            sum + getAssetSize(asset)
//        }
//    }
//    
//    var potentialSavings: Int64 {
//        // Size of all duplicates except the best one
//        guard let best = bestAsset else { return totalSize }
//        return assets.reduce(0) { sum, asset in
//            asset == best ? sum : sum + getAssetSize(asset)
//        }
//    }
//    
//    private func getAssetSize(_ asset: PHAsset) -> Int64 {
//        // Estimate based on dimensions
//        if asset.mediaType == .image {
//            return Int64(Double(asset.pixelWidth * asset.pixelHeight) * 0.1)
//        }
//        return 0
//    }
//}
//
//// MARK: - Main View
//struct StorageOptimizationView: View {
//    // Use @State for dynamic storage values
//    @State private var totalStorage: Int64 = 0
//    @State private var usedStorage: Int64 = 0
//    @State private var freeStorage: Int64 = 0
//    
//    @State private var selectedContacts: Set<String> = []
//
//    @State private var selectedTab = "Duplicates"
//    @State private var selectedPhotos: Set<Int> = []
//    @State private var selectedVideos: Set<Int> = []
//    @State private var selectedMediaItems: Set<String> = [] // Using localIdentifiers
//    @State private var selectedMediaCategory = "Photos" // Default category
//    
//    // Photos access states
//    @State private var photoAssets: PHFetchResult<PHAsset>?
//    @State private var photoAccessGranted = false
//    @State private var isLoading = true
//    
//    // Duplicate detection states
//    @State private var duplicateGroups: [DuplicatePhotoGroup] = []
//    @State private var selectedDuplicates: Set<String> = [] // localIdentifiers
//    @State private var isAnalyzingDuplicates = false
//    @State private var duplicatesAccessGranted = false
//    @State private var analyzedPhotosCount = 0
//    @State private var totalPhotosCount = 0
//    
//    let tabs = ["Duplicates",  "Clean Media", "Contacts Cleanup", "Calendar Cleaner"]
//    let mediaCategories = ["Photos", "Videos", "Audio"]
//    
//    // Photo and video data
//    let photoItems = [0, 1, 2, 3]
//    let videoItems = [0, 1, 2, 3]
//    
//    var body: some View {
//        VStack(spacing: 0) {
//            // Navigation bar
//            VStack(spacing: 20) {
//                HStack {
//                    Button(action: {}) {
//                        Image(systemName: "chevron.left")
//                            .foregroundColor(.blue)
//                    }
//                    Spacer()
//                    Text("Storage Optimization")
//                        .font(.headline)
//                    Spacer()
//                    Spacer().frame(width: 20) // For visual balance
//                }
//                
//                .padding(.horizontal)
//                .padding(.top)
//                
//                // Storage analysis section
//                storageAnalysisSection
//                
//                // Tab selection
//                ScrollView(.horizontal, showsIndicators: false) {
//                    HStack(spacing: 15) {
//                        ForEach(tabs, id: \.self) { tab in
//                            Text(tab)
//                                .padding(.vertical, 8)
//                                .padding(.horizontal, 10)
//                                .font(.subheadline)
//                                .foregroundColor(selectedTab == tab ? .black : .gray)
//                                .background(
//                                    selectedTab == tab ?
//                                    Rectangle()
//                                        .fill(Color.white)
//                                        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
//                                    : nil
//                                )
//                                .cornerRadius(4)
//                                .onTapGesture {
//                                    selectedTab = tab
//                                    if tab == "Duplicates" && duplicateGroups.isEmpty && !isAnalyzingDuplicates {
//                                        requestPhotoAccessForDuplicates()
//                                    } else if tab == "Clean Media" && photoAssets == nil {
//                                        requestPhotoAccess()
//                                    }
//                                }
//                        }
//                    }
//                    .padding(.horizontal)
//                }
//                .background(Color.gray.opacity(0.1))
//            }
//            
//            // Content area
//            if selectedTab == "Duplicates" {
//                duplicatesContentView
//            }else if selectedTab == "Clean Media" {
//                cleanMediaView
//            } else if selectedTab == "Contacts Cleanup" {
//                ContactsCleanupView()
//            }
//            
//           
//            
//            else if selectedTab == "Calendar Cleaner" {
//                CalendarCleanerView()
//            }
//            
//            // Delete button for duplicates
//            if selectedTab == "Duplicates" && !selectedDuplicates.isEmpty && !isAnalyzingDuplicates {
//                VStack {
//                    Spacer()
//                    deleteSelectedDuplicatesButton
//                }
//            }
//            
//            // Delete button only when items selected
//            if selectedTab == "Clean Media" && !selectedMediaItems.isEmpty {
//                Spacer()
//                Button(action: {
//                    // Action to delete selected photos
//                    deleteSelectedPhotos()
//                }) {
//                    Text("Delete Selected Photos")
//                        .font(.headline)
//                        .foregroundColor(.white)
//                        .frame(maxWidth: .infinity)
//                        .padding(.vertical, 15)
//                        .background(Color.blue)
//                        .cornerRadius(8)
//                }
//                .padding(.horizontal)
//                .padding(.bottom, 20)
//                .transition(.opacity)
//                .animation(.easeInOut(duration: 0.2), value: !selectedMediaItems.isEmpty)
//            }
//        }
//        .background(Color(.systemBackground))
//        .onAppear {
//            // Get real device storage information when the view appears
//            updateStorageInfo()
//        }
//    }
//    
//    // Add this method to update storage info
//    private func updateStorageInfo() {
//        let storageInfo = FileManager.default.deviceStorageInfo()
//        self.totalStorage = storageInfo.total
//        self.usedStorage = storageInfo.used
//        self.freeStorage = storageInfo.free
//    }
//    
//    // Helper method to format bytes into human-readable format
//    private func formatBytes(_ bytes: Int64) -> String {
//        let formatter = ByteCountFormatter()
//        formatter.allowedUnits = [.useGB]
//        formatter.countStyle = .file
//        return formatter.string(fromByteCount: bytes)
//    }
//    
//    // MARK: - Photo Library Access
//    
//    private func requestPhotoAccess() {
//        isLoading = true
//        
//        PHPhotoLibrary.requestAuthorization { status in
//            DispatchQueue.main.async {
//                if status == .authorized || status == .limited {
//                    self.photoAccessGranted = true
//                    self.fetchMedia() // Changed from fetchPhotos
//                } else {
//                    self.photoAccessGranted = false
//                    self.isLoading = false
//                }
//            }
//        }
//    }
//    
//    private func fetchMedia() {
//        let options = PHFetchOptions()
//        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
//        
//        DispatchQueue.global(qos: .userInitiated).async {
//            let mediaType: PHAssetMediaType
//            
//            switch self.selectedMediaCategory {
//            case "Photos":
//                mediaType = .image
//            case "Videos":
//                mediaType = .video
//            case "Audio":
//                // For audio, we can try to fetch using .audio type, but note that
//                // this typically won't return many results from Photos library
//                mediaType = .audio
//            default:
//                mediaType = .image
//            }
//            
//            // Fetch assets of the specific type
//            let assets = PHAsset.fetchAssets(with: mediaType, options: options)
//            
//            DispatchQueue.main.async {
//                self.photoAssets = assets
//                self.isLoading = false
//            }
//        }
//    }
//    
//    // Delete selected photos
//    private func deleteSelectedPhotos() {
//        guard !selectedMediaItems.isEmpty, photoAccessGranted else { return }
//        
//        // In a real app, you would delete the actual photos
//        // This is just simulating the deletion
//        selectedMediaItems.removeAll()
//    }
//    
//    // MARK: - Duplicates Content View
//    private var duplicatesContentView: some View {
//        VStack {
//            if isAnalyzingDuplicates {
//                // Analyzing progress view
//                VStack(spacing: 20) {
//                    ProgressView()
//                        .scaleEffect(1.5)
//                    
//                    Text("Analyzing photos for duplicates...")
//                        .font(.headline)
//                    
//                    Text("\(analyzedPhotosCount) of \(totalPhotosCount) photos analyzed")
//                        .font(.subheadline)
//                        .foregroundColor(.gray)
//                    
//                    // Progress bar
//                    GeometryReader { geometry in
//                        ZStack(alignment: .leading) {
//                            Rectangle()
//                                .fill(Color.gray.opacity(0.3))
//                                .frame(height: 4)
//                                .cornerRadius(2)
//                            
//                            Rectangle()
//                                .fill(Color.blue)
//                                .frame(width: geometry.size.width * CGFloat(analyzedPhotosCount) / CGFloat(max(totalPhotosCount, 1)), height: 4)
//                                .cornerRadius(2)
//                        }
//                    }
//                    .frame(height: 4)
//                    .padding(.horizontal, 40)
//                }
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                .padding()
//            } else if !duplicatesAccessGranted {
//                // Permission view
//                VStack(spacing: 20) {
//                    Image(systemName: "photo.stack")
//                        .font(.system(size: 48))
//                        .foregroundColor(.gray)
//                    
//                    Text("Photo Access Required")
//                        .font(.headline)
//                    
//                    Text("Please allow access to analyze your photos for duplicates.")
//                        .multilineTextAlignment(.center)
//                        .padding(.horizontal)
//                    
//                    Button("Grant Access") {
//                        requestPhotoAccessForDuplicates()
//                    }
//                    .foregroundColor(.white)
//                    .padding(.horizontal, 30)
//                    .padding(.vertical, 12)
//                    .background(Color.blue)
//                    .cornerRadius(8)
//                }
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                .padding()
//            } else if duplicateGroups.isEmpty {
//                // No duplicates found
//                VStack(spacing: 20) {
//                    Image(systemName: "checkmark.circle.fill")
//                        .font(.system(size: 48))
//                        .foregroundColor(.green)
//                    
//                    Text("No Duplicates Found")
//                        .font(.headline)
//                    
//                    Text("Great! Your photo library doesn't have any duplicate images.")
//                        .multilineTextAlignment(.center)
//                        .padding(.horizontal)
//                        .foregroundColor(.gray)
//                    
//                    Button("Scan Again") {
//                        analyzeDuplicates()
//                    }
//                    .foregroundColor(.blue)
//                }
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                .padding()
//            } else {
//                // Show duplicate groups
//                ScrollView {
//                    VStack(alignment: .leading, spacing: 0) {
//                        // Summary
//                        HStack {
//                            Text("\(duplicateGroups.count) duplicate groups found")
//                                .font(.subheadline)
//                                .foregroundColor(.gray)
//                            
//                            Spacer()
//                            
//                            if !selectedDuplicates.isEmpty {
//                                Button("Deselect All") {
//                                    selectedDuplicates.removeAll()
//                                }
//                                .font(.subheadline)
//                                .foregroundColor(.blue)
//                            }
//                        }
//                        .padding()
//                        
//                        // Potential savings
//                        if !selectedDuplicates.isEmpty {
//                            let savings = calculateSelectedSavings()
//                            Text("Potential savings: \(formatBytes(savings))")
//                                .font(.caption)
//                                .foregroundColor(.green)
//                                .padding(.horizontal)
//                                .padding(.bottom, 10)
//                        }
//                        
//                        // Duplicate groups
//                        ForEach(duplicateGroups) { group in
//                            DuplicateGroupView(
//                                group: group,
//                                selectedDuplicates: $selectedDuplicates
//                            )
//                            
//                            Divider()
//                                .padding(.horizontal)
//                        }
//                        
//                        // Bottom padding for delete button
//                        Color.clear.frame(height: 100)
//                    }
//                }
//            }
//        }
//    }
//    
//    // MARK: - Delete Button for Duplicates
//    private var deleteSelectedDuplicatesButton: some View {
//        Button(action: {
//            deleteSelectedDuplicates()
//        }) {
//            VStack(spacing: 4) {
//                Text("Delete \(selectedDuplicates.count) Duplicates")
//                    .font(.headline)
//                Text("Save \(formatBytes(calculateSelectedSavings()))")
//                    .font(.caption)
//            }
//            .foregroundColor(.white)
//            .frame(maxWidth: .infinity)
//            .padding(.vertical, 15)
//            .background(Color.red)
//            .cornerRadius(8)
//        }
//        .padding(.horizontal)
//        .padding(.bottom, 20)
//        .transition(.opacity)
//        .animation(.easeInOut(duration: 0.2), value: !selectedDuplicates.isEmpty)
//    }
//    
//    // MARK: - Photo Access for Duplicates
//    private func requestPhotoAccessForDuplicates() {
//        PHPhotoLibrary.requestAuthorization { status in
//            DispatchQueue.main.async {
//                if status == .authorized || status == .limited {
//                    self.duplicatesAccessGranted = true
//                    self.analyzeDuplicates()
//                } else {
//                    self.duplicatesAccessGranted = false
//                }
//            }
//        }
//    }
//    
//    // MARK: - Analyze Duplicates
//    private func analyzeDuplicates() {
//        isAnalyzingDuplicates = true
//        duplicateGroups.removeAll()
//        selectedDuplicates.removeAll()
//        analyzedPhotosCount = 0
//        
//        DispatchQueue.global(qos: .userInitiated).async {
//            let fetchOptions = PHFetchOptions()
//            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
//            let allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
//            
//            DispatchQueue.main.async {
//                self.totalPhotosCount = allPhotos.count
//            }
//            
//            var hashGroups: [String: [PHAsset]] = [:]
//            let imageManager = PHImageManager.default()
//            let options = PHImageRequestOptions()
//            options.isSynchronous = true
//            options.deliveryMode = .fastFormat
//            options.resizeMode = .fast
//            
//            // Process in batches to update progress
//            let batchSize = 50
//            for i in stride(from: 0, to: allPhotos.count, by: batchSize) {
//                autoreleasepool {
//                    let endIndex = min(i + batchSize, allPhotos.count)
//                    
//                    for j in i..<endIndex {
//                        let asset = allPhotos[j]
//                        
//                        // Request small thumbnail for hash calculation
//                        imageManager.requestImage(
//                            for: asset,
//                            targetSize: CGSize(width: 100, height: 100),
//                            contentMode: .aspectFit,
//                            options: options
//                        ) { image, _ in
//                            if let image = image,
//                               let imageData = image.jpegData(compressionQuality: 0.5) {
//                                let hash = SHA256.hash(data: imageData)
//                                let hashString = hash.compactMap { String(format: "%02x", $0) }.joined()
//                                
//                                if hashGroups[hashString] == nil {
//                                    hashGroups[hashString] = []
//                                }
//                                hashGroups[hashString]?.append(asset)
//                            }
//                        }
//                    }
//                    
//                    DispatchQueue.main.async {
//                        self.analyzedPhotosCount = endIndex
//                    }
//                }
//            }
//            
//            // Filter groups with duplicates and create DuplicatePhotoGroup objects
//            let duplicateGroupsArray = hashGroups.compactMap { (hash, assets) -> DuplicatePhotoGroup? in
//                guard assets.count > 1 else { return nil }
//                
//                // Sort by creation date and quality to determine best
//                let sortedAssets = assets.sorted { asset1, asset2 in
//                    // Prefer higher resolution
//                    let pixels1 = asset1.pixelWidth * asset1.pixelHeight
//                    let pixels2 = asset2.pixelWidth * asset2.pixelHeight
//                    
//                    if pixels1 != pixels2 {
//                        return pixels1 > pixels2
//                    }
//                    
//                    // Then by creation date (newer first)
//                    if let date1 = asset1.creationDate, let date2 = asset2.creationDate {
//                        return date1 > date2
//                    }
//                    
//                    return false
//                }
//                
//                var group = DuplicatePhotoGroup(hash: hash, assets: sortedAssets)
//                group.bestAsset = sortedAssets.first
//                return group
//            }
//            
//            DispatchQueue.main.async {
//                self.duplicateGroups = duplicateGroupsArray.sorted { $0.potentialSavings > $1.potentialSavings }
//                self.isAnalyzingDuplicates = false
//            }
//        }
//    }
//    
//    // MARK: - Calculate Savings
//    private func calculateSelectedSavings() -> Int64 {
//        var totalSavings: Int64 = 0
//        
//        for group in duplicateGroups {
//            for asset in group.assets {
//                if selectedDuplicates.contains(asset.localIdentifier) {
//                    let resources = PHAssetResource.assetResources(for: asset)
//                    if let resource = resources.first {
//                        // Estimate size
//                        let estimatedSize = Int64(Double(asset.pixelWidth * asset.pixelHeight) * 0.1)
//                        totalSavings += estimatedSize
//                    }
//                }
//            }
//        }
//        
//        return totalSavings
//    }
//    
//    // MARK: - Delete Selected Duplicates
//    private func deleteSelectedDuplicates() {
//        guard !selectedDuplicates.isEmpty else { return }
//        
//        PHPhotoLibrary.shared().performChanges({
//            let assetsToDelete = self.duplicateGroups.flatMap { group in
//                group.assets.filter { self.selectedDuplicates.contains($0.localIdentifier) }
//            }
//            PHAssetChangeRequest.deleteAssets(assetsToDelete as NSArray)
//        }) { success, error in
//            DispatchQueue.main.async {
//                if success {
//                    // Remove deleted items from groups
//                    self.duplicateGroups = self.duplicateGroups.compactMap { group in
//                        let remainingAssets = group.assets.filter { !self.selectedDuplicates.contains($0.localIdentifier) }
//                        if remainingAssets.count > 1 {
//                            var updatedGroup = group
//                            updatedGroup.assets = remainingAssets
//                            return updatedGroup
//                        }
//                        return nil
//                    }
//                    self.selectedDuplicates.removeAll()
//                } else if let error = error {
//                    print("Error deleting duplicates: \(error)")
//                }
//            }
//        }
//    }
//    
//    // MARK: - Clean Media View
//    
//    private var cleanMediaView: some View {
//        VStack(spacing: 0) {
//            // Media category selection
//            HStack(spacing: 20) {
//                ForEach(mediaCategories, id: \.self) { category in
//                    mediaCategoryButton(category: category)
//                }
//            }
//            .padding(.horizontal)
//            .padding(.top, 15)
//            .padding(.bottom, 5)
//            
//            if isLoading {
//                // Loading view
//                ProgressView("Loading photos...")
//                    .padding()
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//            } else if !photoAccessGranted {
//                // Permission denied view
//                VStack(spacing: 20) {
//                    Image(systemName: "photo.on.rectangle.angled")
//                        .font(.system(size: 48))
//                        .foregroundColor(.gray)
//                    Text("Photo Access Required")
//                        .font(.headline)
//                    Text("Please allow access to your photos in Settings.")
//                        .multilineTextAlignment(.center)
//                        .padding(.horizontal)
//                    Button("Open Settings") {
//                        if let url = URL(string: UIApplication.openSettingsURLString) {
//                            UIApplication.shared.open(url)
//                        }
//                    }
//                    .foregroundColor(.blue)
//                }
//                .padding()
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//            } else if let assets = photoAssets, assets.count > 0 {
//                // Selected count and media list
//                HStack {
//                    let selectedCount = selectedMediaItems.count
//                    Text("\(selectedCount) Photo selected")
//                        .font(.subheadline)
//                        .foregroundColor(.gray)
//                    Spacer()
//                    if selectedCount > 0 {
//                        Button("Deselect All") {
//                            selectedMediaItems.removeAll()
//                        }
//                        .font(.subheadline)
//                        .foregroundColor(.blue)
//                    }
//                }
//                .padding(.horizontal)
//                .padding(.vertical, 10)
//                
//                // Media items list
//                ScrollView {
//                    LazyVStack(spacing: 0) {
//                        ForEach(0..<assets.count, id: \.self) { index in
//                            let asset = assets[index]
//                            AssetRow(
//                                asset: asset,
//                                isSelected: selectedMediaItems.contains(asset.localIdentifier),
//                                onTap: {
//                                    toggleSelection(id: asset.localIdentifier)
//                                }
//                            )
//                            Divider()
//                        }
//                    }
//                    .padding(.bottom, 120)
//                }
//            } else {
//                // No photos found
//                Text("No \(selectedMediaCategory.lowercased()) found")
//                    .font(.headline)
//                    .foregroundColor(.gray)
//                    .padding()
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//            }
//        }
//    }
//    
//    // Media category button
//    private func mediaCategoryButton(category: String) -> some View {
//        VStack {
//            Button(action: {
//                if selectedMediaCategory != category {
//                    selectedMediaCategory = category
//                    isLoading = true
//                    selectedMediaItems.removeAll() // Clear selections when changing categories
//                    
//                    if category == "Audio" {
//                        // For audio files, still use fetchMedia but be aware that
//                        // it might not return many results from Photos library
//                        fetchMedia()
//                        
//                        // Optional: If you wanted to show a message about limited audio support
//                        /*
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                            if self.photoAssets?.count == 0 {
//                                // Could show some UI message about limited audio support
//                            }
//                        }
//                        */
//                    } else {
//                        // For photos and videos
//                        fetchMedia()
//                    }
//                }
//            }) {
//                VStack(spacing: 8) {
//                    ZStack {
//                        RoundedRectangle(cornerRadius: 12)
//                            .fill(Color.white)
//                            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
//                            .frame(width: 100, height: 80)
//                        
//                        Image(systemName: categoryIcon(for: category))
//                            .font(.system(size: 24))
//                            .foregroundColor(.blue)
//                    }
//                    
//                    Text(category)
//                        .font(.subheadline)
//                        .foregroundColor(selectedMediaCategory == category ? .blue : .primary)
//                }
//            }
//            
//            // Indicator for selected category
//            Rectangle()
//                .fill(selectedMediaCategory == category ? Color.blue : Color.clear)
//                .frame(height: 2)
//                .cornerRadius(1)
//        }
//    }
//    // Helper function to get icon for category
//    private func categoryIcon(for category: String) -> String {
//        switch category {
//        case "Photos":
//            return "photo"
//        case "Videos":
//            return "video"
//        case "Audio":
//            return "music.note"
//        default:
//            return "doc"
//        }
//    }
//    
//    // Toggle selection
//    private func toggleSelection(id: String) {
//        if selectedMediaItems.contains(id) {
//            selectedMediaItems.remove(id)
//        } else {
//            selectedMediaItems.insert(id)
//        }
//    }
//    
//    // MARK: - Storage Analysis Section
//    
//    private var storageAnalysisSection: some View {
//        VStack(alignment: .leading, spacing: 10) {
//            Text("Storage analysis")
//                .font(.headline)
//                .padding(.horizontal)
//            
//            HStack(spacing: 20) {
//                // Total Storage - using real values
//                storageItem(
//                    color: .blue,
//                    title: "Total Storage",
//                    value: formatBytes(totalStorage)
//                )
//                
//                // Used Storage - using real values
//                storageItem(
//                    color: .red,
//                    title: "Used Storage",
//                    value: formatBytes(usedStorage)
//                )
//                
//                // Free Storage - using real values
//                storageItem(
//                    color: .green,
//                    title: "Free Storage",
//                    value: formatBytes(freeStorage)
//                )
//            }
//            .padding(.horizontal)
//        }
//    }
//    
//    private func storageItem(color: Color, title: String, value: String) -> some View {
//        HStack(spacing: 6) {
//            Circle()
//                .fill(color)
//                .frame(width: 8, height: 8)
//            
//            VStack(alignment: .leading, spacing: 2) {
//                Text(title)
//                    .font(.caption)
//                    .foregroundColor(.gray)
//                Text(value)
//                    .font(.subheadline)
//                    .fontWeight(.medium)
//            }
//        }
//    }
//    
//    private func toggleContactSelection(id: String) {
//        if selectedContacts.contains(id) {
//            selectedContacts.remove(id)
//        } else {
//            selectedContacts.insert(id)
//        }
//    }
//}
//
//// MARK: - Asset Row Component
//struct AssetRow: View {
//    let asset: PHAsset
//    let isSelected: Bool
//    let onTap: () -> Void
//    
//    @State private var thumbnail: UIImage?
//    @State private var fileName: String = ""
//    @State private var fileSize: String = ""
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
//                        if let image = thumbnail {
//                            Image(uiImage: image)
//                                .resizable()
//                                .aspectRatio(contentMode: .fill)
//                                .frame(width: 60, height: 60)
//                                .cornerRadius(4)
//                                .clipped()
//                        } else {
//                            Rectangle()
//                                .fill(Color.gray.opacity(0.2))
//                                .frame(width: 60, height: 60)
//                                .cornerRadius(4)
//                                .overlay(
//                                    ProgressView()
//                                )
//                        }
//                        
//                        // Video duration label
//                        Text(formatDuration(asset.duration))
//                            .font(.system(size: 10))
//                            .padding(.horizontal, 4)
//                            .padding(.vertical, 2)
//                            .background(Color.black.opacity(0.6))
//                            .foregroundColor(.white)
//                            .cornerRadius(2)
//                            .padding(4)
//                    }
//                } else {
//                    // Standard photo thumbnail
//                    if let image = thumbnail {
//                        Image(uiImage: image)
//                            .resizable()
//                            .aspectRatio(contentMode: .fill)
//                            .frame(width: 60, height: 60)
//                            .cornerRadius(4)
//                            .clipped()
//                    } else {
//                        Rectangle()
//                            .fill(Color.gray.opacity(0.2))
//                            .frame(width: 60, height: 60)
//                            .cornerRadius(4)
//                            .overlay(
//                                ProgressView()
//                            )
//                    }
//                }
//                
//                // Details
//                VStack(alignment: .leading, spacing: 2) {
//                    Text(fileName)
//                        .font(.system(size: 16))
//                        .foregroundColor(.primary)
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
//            // Don't try to load thumbnail for audio files
//            if asset.mediaType != .audio {
//                loadThumbnail()
//            }
//            loadAssetInfo()
//        }
//    }
//    
//    private func formatDuration(_ duration: TimeInterval) -> String {
//          let minutes = Int(duration) / 60
//          let seconds = Int(duration) % 60
//          return String(format: "%d:%02d", minutes, seconds)
//      }
//    
//    private var formattedDate: String {
//            let formatter = DateFormatter()
//            formatter.dateFormat = "MM/dd/yyyy"
//            if let date = asset.creationDate {
//                return formatter.string(from: date)
//            }
//            return "Unknown"
//        }
//    
//    private func loadThumbnail() {
//            let manager = PHImageManager.default()
//            let options = PHImageRequestOptions()
//            options.deliveryMode = .opportunistic
//            options.resizeMode = .exact
//            options.isNetworkAccessAllowed = true
//            
//            manager.requestImage(
//                for: asset,
//                targetSize: CGSize(width: 120, height: 120),
//                contentMode: .aspectFill,
//                options: options
//            ) { image, _ in
//                if let image = image {
//                    DispatchQueue.main.async {
//                        self.thumbnail = image
//                    }
//                }
//            }
//        }
//    
//    // Load asset metadata
//    private func loadAssetInfo() {
//        let resources = PHAssetResource.assetResources(for: asset)
//        if let resource = resources.first {
//            self.fileName = resource.originalFilename
//            
//            // Estimate file size based on dimensions
//            let sizeInBytes: Int64
//            if asset.mediaType == .image {
//                sizeInBytes = Int64(Double(asset.pixelWidth * asset.pixelHeight) * 0.1)
//            } else {
//                sizeInBytes = Int64(asset.duration * 500000)
//            }
//            
//            let formatter = ByteCountFormatter()
//            formatter.allowedUnits = [.useKB, .useMB]
//            formatter.countStyle = .file
//            self.fileSize = formatter.string(fromByteCount: sizeInBytes)
//        } else {
//            self.fileName = "Photo \(asset.localIdentifier.suffix(8))"
//            self.fileSize = "Unknown"
//        }
//    }
//}
//
//// MARK: - Duplicate Group View
//struct DuplicateGroupView: View {
//    let group: DuplicatePhotoGroup
//    @Binding var selectedDuplicates: Set<String>
//    @State private var isExpanded = false
//    @State private var thumbnails: [String: UIImage] = [:] // localIdentifier -> thumbnail
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 12) {
//            // Header with best photo
//            HStack(spacing: 12) {
//                // Best photo thumbnail
//                if let bestAsset = group.bestAsset {
//                    ZStack(alignment: .topLeading) {
//                        if let thumbnail = thumbnails[bestAsset.localIdentifier] {
//                            Image(uiImage: thumbnail)
//                                .resizable()
//                                .aspectRatio(contentMode: .fill)
//                                .frame(width: 80, height: 80)
//                                .cornerRadius(8)
//                                .clipped()
//                        } else {
//                            Rectangle()
//                                .fill(Color.gray.opacity(0.2))
//                                .frame(width: 80, height: 80)
//                                .cornerRadius(8)
//                                .overlay(
//                                    ProgressView()
//                                )
//                        }
//                        
//                        // Best badge
//                        Text("BEST")
//                            .font(.system(size: 10, weight: .bold))
//                            .foregroundColor(.white)
//                            .padding(.horizontal, 6)
//                            .padding(.vertical, 2)
//                            .background(Color.green)
//                            .cornerRadius(4)
//                            .padding(4)
//                    }
//                }
//                
//                // Info
//                VStack(alignment: .leading, spacing: 4) {
//                    Text("\(group.assets.count) photos")
//                        .font(.headline)
//                    
//                    Text("Potential savings: \(formatBytes(group.potentialSavings))")
//                        .font(.subheadline)
//                        .foregroundColor(.gray)
//                    
//                    if let bestAsset = group.bestAsset {
//                        Text("\(bestAsset.pixelWidth) × \(bestAsset.pixelHeight) px")
//                            .font(.caption)
//                            .foregroundColor(.gray)
//                    }
//                }
//                
//                Spacer()
//                
//                // Expand/Collapse button
//                Button(action: {
//                    withAnimation {
//                        isExpanded.toggle()
//                    }
//                }) {
//                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
//                        .foregroundColor(.gray)
//                }
//            }
//            .padding(.horizontal)
//            .contentShape(Rectangle())
//            .onTapGesture {
//                withAnimation {
//                    isExpanded.toggle()
//                }
//            }
//            
//            // Expanded duplicates
//            if isExpanded {
//                ScrollView(.horizontal, showsIndicators: false) {
//                    HStack(spacing: 12) {
//                        ForEach(group.assets.filter { $0 != group.bestAsset }, id: \.localIdentifier) { asset in
//                            DuplicatePhotoItemView(
//                                asset: asset,
//                                isSelected: selectedDuplicates.contains(asset.localIdentifier),
//                                thumbnail: thumbnails[asset.localIdentifier]
//                            ) {
//                                toggleDuplicateSelection(asset.localIdentifier)
//                            }
//                        }
//                    }
//                    .padding(.horizontal)
//                }
//            }
//        }
//        .padding(.vertical, 8)
//        .onAppear {
//            loadThumbnails()
//        }
//    }
//    
//    private func loadThumbnails() {
//        let manager = PHImageManager.default()
//        let options = PHImageRequestOptions()
//        options.deliveryMode = .opportunistic
//        options.resizeMode = .exact
//        options.isNetworkAccessAllowed = true
//        
//        for asset in group.assets {
//            manager.requestImage(
//                for: asset,
//                targetSize: CGSize(width: 160, height: 160),
//                contentMode: .aspectFill,
//                options: options
//            ) { image, _ in
//                if let image = image {
//                    DispatchQueue.main.async {
//                        self.thumbnails[asset.localIdentifier] = image
//                    }
//                }
//            }
//        }
//    }
//    
//    private func toggleDuplicateSelection(_ id: String) {
//        if selectedDuplicates.contains(id) {
//            selectedDuplicates.remove(id)
//        } else {
//            selectedDuplicates.insert(id)
//        }
//    }
//    
//    private func formatBytes(_ bytes: Int64) -> String {
//        let formatter = ByteCountFormatter()
//        formatter.allowedUnits = [.useKB, .useMB]
//        formatter.countStyle = .file
//        return formatter.string(fromByteCount: bytes)
//    }
//}
//
//// MARK: - Duplicate Photo Item View
//struct DuplicatePhotoItemView: View {
//    let asset: PHAsset
//    let isSelected: Bool
//    let thumbnail: UIImage?
//    let onTap: () -> Void
//    
//    var body: some View {
//        ZStack(alignment: .topTrailing) {
//            VStack(spacing: 4) {
//                // Thumbnail
//                if let thumbnail = thumbnail {
//                    Image(uiImage: thumbnail)
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                        .frame(width: 80, height: 80)
//                        .cornerRadius(8)
//                        .clipped()
//                } else {
//                    Rectangle()
//                        .fill(Color.gray.opacity(0.2))
//                        .frame(width: 80, height: 80)
//                        .cornerRadius(8)
//                        .overlay(
//                            ProgressView()
//                        )
//                }
//                
//                // Info
//                VStack(spacing: 2) {
//                    Text("\(asset.pixelWidth)×\(asset.pixelHeight)")
//                        .font(.system(size: 10))
//                        .foregroundColor(.gray)
//                    
//                    if let date = asset.creationDate {
//                        Text(dateFormatter.string(from: date))
//                            .font(.system(size: 10))
//                            .foregroundColor(.gray)
//                    }
//                }
//            }
//            
//            // Selection checkbox
//            ZStack {
//                Circle()
//                    .fill(isSelected ? Color.red : Color.black.opacity(0.5))
//                    .frame(width: 24, height: 24)
//                
//                if isSelected {
//                    Image(systemName: "checkmark")
//                        .foregroundColor(.white)
//                        .font(.system(size: 12, weight: .bold))
//                } else {
//                    Circle()
//                        .strokeBorder(Color.white, lineWidth: 2)
//                        .frame(width: 22, height: 22)
//                }
//            }
//            .padding(4)
//        }
//        .onTapGesture {
//            onTap()
//        }
//    }
//    
//    private var dateFormatter: DateFormatter {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "MM/dd"
//        return formatter
//    }
//}
//
//// MARK: - Contacts Cleanup View
//
//    
//  
//    
//    
//
//// MARK: - Contact Row
//
//
//// MARK: - Calendar Cleaner View
//
//    
//
//// MARK: - Event Row
//struct EventRow: View {
//    let event: EKEvent
//    let isSelected: Bool
//    let onTap: () -> Void
//    
//    var body: some View {
//        Button(action: onTap) {
//            HStack(spacing: 12) {
//                // Calendar color indicator
//                Rectangle()
//                    .fill(Color(event.calendar.cgColor))
//                    .frame(width: 4, height: 50)
//                    .cornerRadius(2)
//                
//                VStack(alignment: .leading, spacing: 2) {
//                    Text(event.title ?? "Untitled Event")
//                        .font(.system(size: 16))
//                        .foregroundColor(.primary)
//                    
//                    if let startDate = event.startDate {
//                        Text(dateFormatter.string(from: startDate))
//                            .font(.system(size: 14))
//                            .foregroundColor(.gray)
//                    }
//                    
//                    Text(event.calendar.title)
//                        .font(.system(size: 12))
//                        .foregroundColor(.gray)
//                }
//                
//                Spacer()
//                
//                // Selection indicator
//                ZStack {
//                    Circle()
//                        .fill(isSelected ? Color.red : Color.clear)
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
//            .padding(.vertical, 8)
//            .padding(.horizontal)
//        }
//        .buttonStyle(PlainButtonStyle())
//    }
//    
//    private var dateFormatter: DateFormatter {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .medium
//        formatter.timeStyle = .short
//        return formatter
//    }
//}
//
//
//
//extension CNContact {
//    var initials: String {
//        let first = givenName.first.map { String($0) } ?? ""
//        let last = familyName.first.map { String($0) } ?? ""
//        return (first + last).uppercased()
//    }
//}

// MARK: - Duplicate Photo Model
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

    @State private var selectedTab = "Duplicates"
    @State private var selectedPhotos: Set<Int> = []
    @State private var selectedVideos: Set<Int> = []
    @State private var selectedMediaItems: Set<String> = [] // Using localIdentifiers
    @State private var selectedMediaCategory = "Photos" // Default category
    
    // Photos access states
    @State private var photoAssets: PHFetchResult<PHAsset>?
    @State private var photoAccessGranted = false
    @State private var isLoading = true
    
    // Duplicate detection states
    @State private var duplicateGroups: [DuplicatePhotoGroup] = []
    @State private var selectedDuplicates: Set<String> = [] // localIdentifiers
    @State private var isAnalyzingDuplicates = false
    @State private var duplicatesAccessGranted = false
    @State private var hasCheckedDuplicatesAccess = false
    @State private var hasAnalyzedDuplicates = false
    @State private var analyzedPhotosCount = 0
    @State private var totalPhotosCount = 0
    
    let tabs = ["Duplicates",  "Clean Media", "Contacts Cleanup", "Calendar Cleaner"]
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
                    Text("Storage Optimization")
                        .font(.headline)
                    Spacer()
                    Spacer().frame(width: 20) // For visual balance
                }
                
                .padding(.horizontal)
                .padding(.top)
                
                // Storage analysis section
                storageAnalysisSection
                
                // Tab selection
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(tabs, id: \.self) { tab in
                            Text(tab)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 10)
                                .font(.subheadline)
                                .foregroundColor(selectedTab == tab ? .black : .gray)
                                .background(
                                    selectedTab == tab ?
                                    Rectangle()
                                        .fill(Color.white)
                                        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                                    : nil
                                )
                                .cornerRadius(4)
                                .onTapGesture {
                                    selectedTab = tab
                                    if tab == "Duplicates" && duplicateGroups.isEmpty && !isAnalyzingDuplicates && !hasAnalyzedDuplicates {
                                        requestPhotoAccessForDuplicates()
                                    } else if tab == "Clean Media" && photoAssets == nil {
                                        requestPhotoAccess()
                                    }
                                }
                        }
                    }
                    .padding(.horizontal)
                }
                .background(Color.gray.opacity(0.1))
            }
            
            // Content area
            if selectedTab == "Duplicates" {
                duplicatesContentView
            }else if selectedTab == "Clean Media" {
                cleanMediaView
            } else if selectedTab == "Contacts Cleanup" {
                ContactsCleanupView()
            }
            
           
            
            else if selectedTab == "Calendar Cleaner" {
                CalendarCleanerView()
            }
            
            // Delete button for duplicates
            if selectedTab == "Duplicates" && !selectedDuplicates.isEmpty && !isAnalyzingDuplicates {
                VStack {
                    Spacer()
                    deleteSelectedDuplicatesButton
                }
            }
            
            // Delete button only when items selected
            if selectedTab == "Clean Media" && !selectedMediaItems.isEmpty {
                Spacer()
                Button(action: {
                    // Action to delete selected photos
                    deleteSelectedPhotos()
                }) {
                    Text("Delete Selected Photos")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
                .transition(.opacity)
                .animation(.easeInOut(duration: 0.2), value: !selectedMediaItems.isEmpty)
            }
        }
        .background(Color(.systemBackground))
        .onAppear {
            // Get real device storage information when the view appears
            updateStorageInfo()
        }
    }
    
    // Add this method to update storage info
    private func updateStorageInfo() {
        let storageInfo = FileManager.default.deviceStorageInfo()
        self.totalStorage = storageInfo.total
        self.usedStorage = storageInfo.used
        self.freeStorage = storageInfo.free
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
        isLoading = true
        
        PHPhotoLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                if status == .authorized || status == .limited {
                    self.photoAccessGranted = true
                    self.fetchMedia() // Changed from fetchPhotos
                } else {
                    self.photoAccessGranted = false
                    self.isLoading = false
                }
            }
        }
    }
    
    private func fetchMedia() {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        DispatchQueue.global(qos: .userInitiated).async {
            let mediaType: PHAssetMediaType
            
            switch self.selectedMediaCategory {
            case "Photos":
                mediaType = .image
            case "Videos":
                mediaType = .video
            case "Audio":
                // For audio, we can try to fetch using .audio type, but note that
                // this typically won't return many results from Photos library
                mediaType = .audio
            default:
                mediaType = .image
            }
            
            // Fetch assets of the specific type
            let assets = PHAsset.fetchAssets(with: mediaType, options: options)
            
            DispatchQueue.main.async {
                self.photoAssets = assets
                self.isLoading = false
            }
        }
    }
    
    // Delete selected photos
    private func deleteSelectedPhotos() {
        guard !selectedMediaItems.isEmpty, photoAccessGranted else { return }
        
        // In a real app, you would delete the actual photos
        // This is just simulating the deletion
        selectedMediaItems.removeAll()
    }
    
    // MARK: - Duplicates Content View
    private var duplicatesContentView: some View {
        VStack {
            if isAnalyzingDuplicates {
                // Analyzing progress view
                VStack(spacing: 20) {
                    ProgressView()
                        .scaleEffect(1.5)
                    
                    Text("Analyzing photos for duplicates...")
                        .font(.headline)
                    
                    Text("\(analyzedPhotosCount) of \(totalPhotosCount) photos analyzed")
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
                                .frame(width: geometry.size.width * CGFloat(analyzedPhotosCount) / CGFloat(max(totalPhotosCount, 1)), height: 4)
                                .cornerRadius(2)
                        }
                    }
                    .frame(height: 4)
                    .padding(.horizontal, 40)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
            } else if !duplicatesAccessGranted && !hasCheckedDuplicatesAccess {
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
            } else if duplicateGroups.isEmpty && !hasAnalyzedDuplicates {
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
            } else if duplicateGroups.isEmpty && hasAnalyzedDuplicates {
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
            } else {
                // Show duplicate groups
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        // Summary
                        HStack {
                            Text("\(duplicateGroups.count) duplicate groups found")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            Spacer()
                            
                            if !selectedDuplicates.isEmpty {
                                Button("Deselect All") {
                                    selectedDuplicates.removeAll()
                                }
                                .font(.subheadline)
                                .foregroundColor(.blue)
                            }
                        }
                        .padding()
                        
                        // Potential savings
                        if !selectedDuplicates.isEmpty {
                            let savings = calculateSelectedSavings()
                            Text("Potential savings: \(formatBytes(savings))")
                                .font(.caption)
                                .foregroundColor(.green)
                                .padding(.horizontal)
                                .padding(.bottom, 10)
                        }
                        
                        // Duplicate groups
                        ForEach(duplicateGroups) { group in
                            DuplicateGroupView(
                                group: group,
                                selectedDuplicates: $selectedDuplicates
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
    
    // MARK: - Delete Button for Duplicates
    private var deleteSelectedDuplicatesButton: some View {
        Button(action: {
            deleteSelectedDuplicates()
        }) {
            VStack(spacing: 4) {
                Text("Delete \(selectedDuplicates.count) Duplicates")
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
        .animation(.easeInOut(duration: 0.2), value: !selectedDuplicates.isEmpty)
    }
    
    // MARK: - Photo Access for Duplicates
    private func requestPhotoAccessForDuplicates() {
        hasCheckedDuplicatesAccess = true
        
        PHPhotoLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                if status == .authorized || status == .limited {
                    self.duplicatesAccessGranted = true
                    // Don't automatically analyze, let user click the button
                } else {
                    self.duplicatesAccessGranted = false
                }
            }
        }
    }
    
    // MARK: - Analyze Duplicates
    private func analyzeDuplicates() {
        isAnalyzingDuplicates = true
        duplicateGroups.removeAll()
        selectedDuplicates.removeAll()
        analyzedPhotosCount = 0
        
        DispatchQueue.global(qos: .userInitiated).async {
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            let allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
            
            DispatchQueue.main.async {
                self.totalPhotosCount = allPhotos.count
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
                        self.analyzedPhotosCount = endIndex
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
                self.duplicateGroups = duplicateGroupsArray.sorted { $0.potentialSavings > $1.potentialSavings }
                self.isAnalyzingDuplicates = false
                self.hasAnalyzedDuplicates = true
            }
        }
    }
    
    // MARK: - Perceptual Hash Calculation
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
        
        for group in duplicateGroups {
            for asset in group.assets {
                if selectedDuplicates.contains(asset.localIdentifier) {
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
        guard !selectedDuplicates.isEmpty else { return }
        
        PHPhotoLibrary.shared().performChanges({
            let assetsToDelete = self.duplicateGroups.flatMap { group in
                group.assets.filter { self.selectedDuplicates.contains($0.localIdentifier) }
            }
            PHAssetChangeRequest.deleteAssets(assetsToDelete as NSArray)
        }) { success, error in
            DispatchQueue.main.async {
                if success {
                    // Remove deleted items from groups
                    self.duplicateGroups = self.duplicateGroups.compactMap { group in
                        let remainingAssets = group.assets.filter { !self.selectedDuplicates.contains($0.localIdentifier) }
                        if remainingAssets.count > 1 {
                            var updatedGroup = group
                            updatedGroup.assets = remainingAssets
                            return updatedGroup
                        }
                        return nil
                    }
                    self.selectedDuplicates.removeAll()
                } else if let error = error {
                    print("Error deleting duplicates: \(error)")
                }
            }
        }
    }
    
    // MARK: - Clean Media View
    
    private var cleanMediaView: some View {
        VStack(spacing: 0) {
            // Media category selection
            HStack(spacing: 20) {
                ForEach(mediaCategories, id: \.self) { category in
                    mediaCategoryButton(category: category)
                }
            }
            .padding(.horizontal)
            .padding(.top, 15)
            .padding(.bottom, 5)
            
            if isLoading {
                // Loading view
                ProgressView("Loading photos...")
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if !photoAccessGranted {
                // Permission denied view
                VStack(spacing: 20) {
                    Image(systemName: "photo.on.rectangle.angled")
                        .font(.system(size: 48))
                        .foregroundColor(.gray)
                    Text("Photo Access Required")
                        .font(.headline)
                    Text("Please allow access to your photos in Settings.")
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    Button("Open Settings") {
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url)
                        }
                    }
                    .foregroundColor(.blue)
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let assets = photoAssets, assets.count > 0 {
                // Selected count and media list
                HStack {
                    let selectedCount = selectedMediaItems.count
                    Text("\(selectedCount) Photo selected")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Spacer()
                    if selectedCount > 0 {
                        Button("Deselect All") {
                            selectedMediaItems.removeAll()
                        }
                        .font(.subheadline)
                        .foregroundColor(.blue)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                
                // Media items list
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(0..<assets.count, id: \.self) { index in
                            let asset = assets[index]
                            AssetRow(
                                asset: asset,
                                isSelected: selectedMediaItems.contains(asset.localIdentifier),
                                onTap: {
                                    toggleSelection(id: asset.localIdentifier)
                                }
                            )
                            Divider()
                        }
                    }
                    .padding(.bottom, 120)
                }
            } else {
                // No photos found
                Text("No \(selectedMediaCategory.lowercased()) found")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
    
    // Media category button
    private func mediaCategoryButton(category: String) -> some View {
        VStack {
            Button(action: {
                if selectedMediaCategory != category {
                    selectedMediaCategory = category
                    isLoading = true
                    selectedMediaItems.removeAll() // Clear selections when changing categories
                    
                    if category == "Audio" {
                        // For audio files, still use fetchMedia but be aware that
                        // it might not return many results from Photos library
                        fetchMedia()
                        
                        // Optional: If you wanted to show a message about limited audio support
                        /*
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            if self.photoAssets?.count == 0 {
                                // Could show some UI message about limited audio support
                            }
                        }
                        */
                    } else {
                        // For photos and videos
                        fetchMedia()
                    }
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
                            .foregroundColor(.blue)
                    }
                    
                    Text(category)
                        .font(.subheadline)
                        .foregroundColor(selectedMediaCategory == category ? .blue : .primary)
                }
            }
            
            // Indicator for selected category
            Rectangle()
                .fill(selectedMediaCategory == category ? Color.blue : Color.clear)
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
    
    // Toggle selection
    private func toggleSelection(id: String) {
        if selectedMediaItems.contains(id) {
            selectedMediaItems.remove(id)
        } else {
            selectedMediaItems.insert(id)
        }
    }
    
    // MARK: - Storage Analysis Section
    
    private var storageAnalysisSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Storage analysis")
                .font(.headline)
                .padding(.horizontal)
            
            HStack(spacing: 20) {
                // Total Storage - using real values
                storageItem(
                    color: .blue,
                    title: "Total Storage",
                    value: formatBytes(totalStorage)
                )
                
                // Used Storage - using real values
                storageItem(
                    color: .red,
                    title: "Used Storage",
                    value: formatBytes(usedStorage)
                )
                
                // Free Storage - using real values
                storageItem(
                    color: .green,
                    title: "Free Storage",
                    value: formatBytes(freeStorage)
                )
            }
            .padding(.horizontal)
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

// MARK: - Asset Row Component
struct AssetRow: View {
    let asset: PHAsset
    let isSelected: Bool
    let onTap: () -> Void
    
    @State private var thumbnail: UIImage?
    @State private var fileName: String = ""
    @State private var fileSize: String = ""
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                // Thumbnail - different display for each media type
                if asset.mediaType == .audio {
                    // Specialized audio thumbnail
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
                    // Video thumbnail with duration indicator
                    ZStack(alignment: .bottomTrailing) {
                        if let image = thumbnail {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 60, height: 60)
                                .cornerRadius(4)
                                .clipped()
                        } else {
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 60, height: 60)
                                .cornerRadius(4)
                                .overlay(
                                    ProgressView()
                                )
                        }
                        
                        // Video duration label
                        Text(formatDuration(asset.duration))
                            .font(.system(size: 10))
                            .padding(.horizontal, 4)
                            .padding(.vertical, 2)
                            .background(Color.black.opacity(0.6))
                            .foregroundColor(.white)
                            .cornerRadius(2)
                            .padding(4)
                    }
                } else {
                    // Standard photo thumbnail
                    if let image = thumbnail {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 60, height: 60)
                            .cornerRadius(4)
                            .clipped()
                    } else {
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 60, height: 60)
                            .cornerRadius(4)
                            .overlay(
                                ProgressView()
                            )
                    }
                }
                
                // Details
                VStack(alignment: .leading, spacing: 2) {
                    Text(fileName)
                        .font(.system(size: 16))
                        .foregroundColor(.primary)
                    
                    HStack {
                        if asset.mediaType == .audio {
                            Text("Duration")
                                .foregroundColor(.gray)
                                .font(.system(size: 14))
                            
                            Text(formatDuration(asset.duration))
                                .foregroundColor(.gray)
                                .font(.system(size: 14))
                        } else {
                            Text("Taken")
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
                
                // Selection indicator
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
            // Don't try to load thumbnail for audio files
            if asset.mediaType != .audio {
                loadThumbnail()
            }
            loadAssetInfo()
        }
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
          let minutes = Int(duration) / 60
          let seconds = Int(duration) % 60
          return String(format: "%d:%02d", minutes, seconds)
      }
    
    private var formattedDate: String {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy"
            if let date = asset.creationDate {
                return formatter.string(from: date)
            }
            return "Unknown"
        }
    
    private func loadThumbnail() {
            let manager = PHImageManager.default()
            let options = PHImageRequestOptions()
            options.deliveryMode = .opportunistic
            options.resizeMode = .exact
            options.isNetworkAccessAllowed = true
            
            manager.requestImage(
                for: asset,
                targetSize: CGSize(width: 120, height: 120),
                contentMode: .aspectFill,
                options: options
            ) { image, _ in
                if let image = image {
                    DispatchQueue.main.async {
                        self.thumbnail = image
                    }
                }
            }
        }
    
    // Load asset metadata
    private func loadAssetInfo() {
        let resources = PHAssetResource.assetResources(for: asset)
        if let resource = resources.first {
            self.fileName = resource.originalFilename
            
            // Estimate file size based on dimensions
            let sizeInBytes: Int64
            if asset.mediaType == .image {
                sizeInBytes = Int64(Double(asset.pixelWidth * asset.pixelHeight) * 0.1)
            } else {
                sizeInBytes = Int64(asset.duration * 500000)
            }
            
            let formatter = ByteCountFormatter()
            formatter.allowedUnits = [.useKB, .useMB]
            formatter.countStyle = .file
            self.fileSize = formatter.string(fromByteCount: sizeInBytes)
        } else {
            self.fileName = "Photo \(asset.localIdentifier.suffix(8))"
            self.fileSize = "Unknown"
        }
    }
}

// MARK: - Duplicate Group View
struct DuplicateGroupView: View {
    let group: DuplicatePhotoGroup
    @Binding var selectedDuplicates: Set<String>
    @State private var isExpanded = false
    @State private var thumbnails: [String: UIImage] = [:] // localIdentifier -> thumbnail
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header with best photo
            HStack(spacing: 12) {
                // Best photo thumbnail
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
                                .overlay(
                                    ProgressView()
                                )
                        }
                        
                        // Best badge
                        Text("BEST")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.green)
                            .cornerRadius(4)
                            .padding(4)
                    }
                }
                
                // Info
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(group.assets.count) photos")
                        .font(.headline)
                    
                    Text("Potential savings: \(formatBytes(group.potentialSavings))")
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
