//
//  mediaCompressionView.swift
//  GHGG
//
//  Created by test on 17/05/2025.
//
import Photos
import UIKit
import SwiftUI
import PhotosUI
//
//enum CompressionQuality: String, CaseIterable {
//    case low = "Low"
//    case medium = "Medium"
//    case high = "High"
//
//    func localizedTitle(language: String) -> String {
//        return LocalizedStrings.string(for: self.rawValue, language: language)
//    }
//
//    func compressionPercentage(language: String) -> String {
//        switch self {
//        case .low:
//            return "20% " + LocalizedStrings.string(for: "compress", language: language)
//        case .medium:
//            return "50% " + LocalizedStrings.string(for: "compress", language: language)
//        case .high:
//            return "80% " + LocalizedStrings.string(for: "compress", language: language)
//        }
//    }
//
//    // This returns the target file size ratio (what percentage of CURRENT size to keep)
//    var targetSizeRatio: Double {
//        switch self {
//        case .low: return 0.8     // 20% compression = keep 80% of CURRENT size
//        case .medium: return 0.5  // 50% compression = keep 50% of CURRENT size
//        case .high: return 0.2    // 80% compression = keep 20% of CURRENT size
//        }
//    }
//    
//    // Initial compression quality to try
//    var initialCompressionQuality: CGFloat {
//        switch self {
//        case .low: return 0.9     // Start with high quality for low compression
//        case .medium: return 0.5   // Start with medium quality
//        case .high: return 0.2     // Start with low quality for high compression
//        }
//    }
//}
//
//// MARK: - Image Picker
//struct ImagePickerWithAsset: UIViewControllerRepresentable {
//    @Binding var selectedImage: UIImage?
//    @Binding var selectedAsset: PHAsset?
//    @Binding var originalFileSize: Int64
//    @Environment(\.presentationMode) private var presentationMode
//
//    func makeUIViewController(context: Context) -> PHPickerViewController {
//        var configuration = PHPickerConfiguration()
//        configuration.filter = .images
//        configuration.selectionLimit = 1
//        configuration.preferredAssetRepresentationMode = .current
//
//        let picker = PHPickerViewController(configuration: configuration)
//        picker.delegate = context.coordinator
//        return picker
//    }
//
//    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    class Coordinator: NSObject, PHPickerViewControllerDelegate {
//        let parent: ImagePickerWithAsset
//        
//        init(_ parent: ImagePickerWithAsset) {
//            self.parent = parent
//        }
//        
//        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//            parent.presentationMode.wrappedValue.dismiss()
//            
//            guard let result = results.first else { return }
//            
//            // Reset values
//            DispatchQueue.main.async {
//                self.parent.selectedImage = nil
//                self.parent.selectedAsset = nil
//                self.parent.originalFileSize = 0
//            }
//            
//            // Try to get file size directly from the item provider
//            if result.itemProvider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
//                result.itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.image.identifier) { url, error in
//                    if let url = url {
//                        do {
//                            let resourceValues = try url.resourceValues(forKeys: [.fileSizeKey])
//                            if let fileSize = resourceValues.fileSize {
//                                DispatchQueue.main.async {
//                                    self.parent.originalFileSize = Int64(fileSize)
//                                    print("📁 File size from URL: \(fileSize) bytes (\(ByteCountFormatter.string(fromByteCount: Int64(fileSize), countStyle: .file)))")
//                                }
//                            }
//                        } catch {
//                            print("Error getting file size: \(error)")
//                        }
//                    }
//                }
//            }
//            
//            // Load image for display
//            result.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
//                if let image = image as? UIImage {
//                    DispatchQueue.main.async {
//                        self.parent.selectedImage = image
//                        
//                        // If we couldn't get file size from URL, try from PHAsset
//                        if self.parent.originalFileSize == 0 {
//                            self.tryGetFileSizeFromAsset(result: result)
//                        }
//                    }
//                }
//            }
//        }
//        
//        private func tryGetFileSizeFromAsset(result: PHPickerResult) {
//            // Try to get PHAsset for metadata
//            if let assetIdentifier = result.assetIdentifier {
//                let fetchOptions = PHFetchOptions()
//                let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [assetIdentifier], options: fetchOptions)
//                if let asset = fetchResult.firstObject {
//                    DispatchQueue.main.async {
//                        self.parent.selectedAsset = asset
//                        
//                        // Get actual file size
//                        self.getActualFileSize(from: asset) { size in
//                            DispatchQueue.main.async {
//                                if size > 0 {
//                                    self.parent.originalFileSize = size
//                                    print("📁 File size from PHAsset: \(size) bytes (\(ByteCountFormatter.string(fromByteCount: size, countStyle: .file)))")
//                                } else {
//                                    // Fallback: estimate from image
//                                    self.estimateFileSizeFromImage()
//                                }
//                            }
//                        }
//                    }
//                } else {
//                    // No asset found, estimate from image
//                    self.estimateFileSizeFromImage()
//                }
//            } else {
//                // No asset identifier, estimate from image
//                self.estimateFileSizeFromImage()
//            }
//        }
//        
//        private func estimateFileSizeFromImage() {
//            guard let image = self.parent.selectedImage else { return }
//            
//            // Try to get original data representation
//            if let imageData = image.jpegData(compressionQuality: 1.0) {
//                DispatchQueue.main.async {
//                    self.parent.originalFileSize = Int64(imageData.count)
//                    print("📁 Estimated file size from JPEG data: \(imageData.count) bytes (\(ByteCountFormatter.string(fromByteCount: Int64(imageData.count), countStyle: .file)))")
//                }
//            } else {
//                // Last resort: calculate based on dimensions
//                let estimatedSize = self.calculateSmartFileSize(for: image)
//                DispatchQueue.main.async {
//                    self.parent.originalFileSize = estimatedSize
//                    print("📁 Calculated file size: \(estimatedSize) bytes (\(ByteCountFormatter.string(fromByteCount: estimatedSize, countStyle: .file)))")
//                }
//            }
//        }
//        
//        private func getActualFileSize(from asset: PHAsset, completion: @escaping (Int64) -> Void) {
//            let resources = PHAssetResource.assetResources(for: asset)
//            
//            guard let resource = resources.first else {
//                completion(0)
//                return
//            }
//            
//            // Try multiple approaches to get file size
//            
//            // Approach 1: Direct property access
//            if let fileSize = resource.value(forKey: "fileSize") as? CLong {
//                completion(Int64(fileSize))
//                return
//            }
//            
//            // Approach 2: Use uniformTypeIdentifier to check if it's available
//            let resourceManager = PHAssetResourceManager.default()
//            let options = PHAssetResourceRequestOptions()
//            options.isNetworkAccessAllowed = true
//            
//            // Approach 3: Stream the data to calculate size
//            var totalSize: Int64 = 0
//            resourceManager.requestData(for: resource, options: options, dataReceivedHandler: { data in
//                totalSize += Int64(data.count)
//            }, completionHandler: { error in
//                if error == nil && totalSize > 0 {
//                    completion(totalSize)
//                } else {
//                    // Approach 4: Request the full data at once
//                    var imageData = Data()
//                    resourceManager.requestData(for: resource, options: options, dataReceivedHandler: { data in
//                        imageData.append(data)
//                    }, completionHandler: { error in
//                        completion(Int64(imageData.count))
//                    })
//                }
//            })
//        }
//        
//        private func calculateSmartFileSize(for image: UIImage) -> Int64 {
//            let width = Int(image.size.width * image.scale)
//            let height = Int(image.size.height * image.scale)
//            let totalPixels = width * height
//            
//            // More accurate estimation based on typical iOS photo compression
//            let bytesPerPixel: Double
//            
//            if totalPixels > 10_000_000 { // Very high resolution (10MP+)
//                bytesPerPixel = 0.3 // HEIF/JPEG compression
//            } else if totalPixels > 5_000_000 { // High resolution (5-10MP)
//                bytesPerPixel = 0.35
//            } else if totalPixels > 2_000_000 { // Medium resolution (2-5MP)
//                bytesPerPixel = 0.4
//            } else { // Lower resolution
//                bytesPerPixel = 0.5
//            }
//            
//            let estimatedSize = Int64(Double(totalPixels) * bytesPerPixel)
//            
//            print("📐 Image: \(width)×\(height) (\(totalPixels) pixels)")
//            print("📏 Estimated size: \(estimatedSize) bytes (\(String(format: "%.1f", Double(estimatedSize)/1024/1024)) MB)")
//            
//            return estimatedSize
//        }
//    }
//}
//
//// MARK: - Main View
//struct MediaCompressionView: View {
//    @State private var selectedQuality: CompressionQuality = .medium
//
//    @State private var showingImagePicker = false
//    @State private var selectedImage: UIImage?
//    @State private var selectedAsset: PHAsset?
//    @State private var originalFileSize: Int64 = 0
//    @State private var showingPermissionAlert = false
//    @State private var isCompressing = false
//    @State private var showSuccessAlert = false
//    @State private var showErrorAlert = false
//    @State private var compressionResult = CompressionResult()
//    @State private var compressionCount = 0
//    @State private var compressionHistory: [CompressionHistoryItem] = []
//    @EnvironmentObject var languageManager: LanguageManager
//
//    struct CompressionResult {
//        var originalSize: String = ""
//        var compressedSize: String = ""
//        var savedSpace: String = ""
//        var errorMessage: String = ""
//    }
//    
//    struct CompressionHistoryItem {
//        var step: Int
//        var fromSize: String
//        var toSize: String
//        var percentage: String
//    }
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                ScrollView {
//                    VStack(spacing: 16) {
//                        qualitySection
//                        imageComparisonView
//                        sizeComparisonView
//                        
//                        // Compression history
//                        if !compressionHistory.isEmpty {
//                            compressionHistoryView
//                        }
//                    }
//                }
//
//                if selectedImage != nil {
//                    VStack(spacing: 10) {
//                        if compressionCount > 0 {
//                            Text("Compressed \(compressionCount) time\(compressionCount == 1 ? "" : "s") of 5 maximum")
//                                .font(.caption)
//                                .foregroundColor(compressionCount >= 5 ? .orange : .green)
//                        }
//                        
//                        compressButton
//                            .disabled(compressionCount >= 5)
//                        
//                        if compressionCount >= 5 {
//                            Text("Maximum compressions reached")
//                                .font(.caption)
//                                .foregroundColor(.orange)
//                                .padding(.top, 5)
//                        }
//                    }
//                    .padding()
//                    .background(Color(UIColor.systemBackground))
//                }
//            }
//            .onAppear {
//                checkPhotoLibraryPermission()
//            }
//            .alert("Permission Required", isPresented: $showingPermissionAlert) {
//                Button("Settings") {
//                    if let url = URL(string: UIApplication.openSettingsURLString) {
//                        UIApplication.shared.open(url)
//                    }
//                }
//                Button("Cancel", role: .cancel) {}
//            } message: {
//                Text("Please allow full access to your photo library to compress and replace images. Limited access prevents deleting the original image, which may cause duplicates.")
//            }
//            .alert(LocalizedStrings.string(for: "image_compressed_successfully", language: languageManager.currentLanguage), isPresented: $showSuccessAlert) {
//                Button(LocalizedStrings.string(for: "done", language: languageManager.currentLanguage), role: .cancel) {
//                    selectedImage = nil
//                    selectedAsset = nil
//                    originalFileSize = 0
//                    compressionCount = 0
//                    compressionHistory.removeAll()
//                }
//            } message: {
//                Text("Compressed successfully!")
//            }
//            .alert("Compression Failed ❌", isPresented: $showErrorAlert) {
//                Button("OK") {}
//            } message: {
//                Text(compressionResult.errorMessage)
//            }
//            .overlay {
//                if isCompressing {
//                    loadingOverlay
//                }
//            }
//            .sheet(isPresented: $showingImagePicker) {
//                ImagePickerWithAsset(
//                    selectedImage: $selectedImage,
//                    selectedAsset: $selectedAsset,
//                    originalFileSize: $originalFileSize
//                )
//                .onDisappear {
//                    // Reset compression count when selecting new image
//                    if selectedImage != nil {
//                        compressionCount = 0
//                        compressionHistory.removeAll()
//                    }
//                }
//            }
//        }
//    }
//    
//    private var compressionHistoryView: some View {
//        VStack(alignment: .leading, spacing: 10) {
//            HStack {
//                Text("Compression History")
//                    .font(.headline)
//                
//                Spacer()
//                
//                Text("\(compressionCount)/5")
//                    .font(.caption)
//                    .foregroundColor(compressionCount >= 5 ? .orange : .gray)
//                    .padding(.horizontal, 8)
//                    .padding(.vertical, 4)
//                    .background(Color.gray.opacity(0.2))
//                    .cornerRadius(12)
//            }
//            .padding(.horizontal)
//            
//            VStack(spacing: 8) {
//                ForEach(compressionHistory, id: \.step) { item in
//                    HStack {
//                        Text("Step \(item.step):")
//                            .font(.caption)
//                            .foregroundColor(.gray)
//                        
//                        Text(item.fromSize)
//                            .font(.caption)
//                            .foregroundColor(.orange)
//                        
//                        Image(systemName: "arrow.right")
//                            .font(.caption)
//                            .foregroundColor(.gray)
//                        
//                        Text(item.toSize)
//                            .font(.caption)
//                            .foregroundColor(.green)
//                        
//                        Spacer()
//                        
//                        Text(item.percentage)
//                            .font(.caption)
//                            .foregroundColor(.blue)
//                    }
//                    .padding(.horizontal)
//                    .padding(.vertical, 4)
//                    .background(Color.gray.opacity(0.1))
//                    .cornerRadius(8)
//                }
//            }
//            .padding(.horizontal)
//        }
//    }
//
//    private var qualitySection: some View {
//        VStack(alignment: .leading) {
//            Text(LocalizedStrings.string(for: "quality", language: languageManager.currentLanguage))
//                .font(.headline)
//                .padding(.horizontal)
//
//            HStack(spacing: 8) {
//                ForEach(CompressionQuality.allCases, id: \.self) { quality in
//                    Button(action: {
//                        selectedQuality = quality
//                    }) {
//                        VStack {
//                            Text(quality.localizedTitle(language: languageManager.currentLanguage))
//                                .font(.system(size: 16, weight: .medium))
//                            Text(quality.compressionPercentage(language: languageManager.currentLanguage))
//                                .font(.caption)
//                                .foregroundColor(.gray)
//                        }
//                        .frame(maxWidth: .infinity)
//                        .padding(.vertical, 12)
//                        .padding(.horizontal, 8)
//                        .background(
//                            RoundedRectangle(cornerRadius: 10)
//                                .fill(selectedQuality == quality ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1))
//                        )
//                    }
//                    .buttonStyle(.plain)
//                }
//            }
//            .padding(.horizontal)
//        }
//    }
//
//    private var imageComparisonView: some View {
//        VStack(spacing: 10) {
//            ZStack {
//                if let image = selectedImage {
//                    Image(uiImage: image)
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(height: 300)
//                } else {
//                    RoundedRectangle(cornerRadius: 12)
//                        .fill(Color.gray.opacity(0.1))
//                        .frame(height: 300)
//                        .overlay(
//                            VStack {
//                                Image(systemName: "photo")
//                                    .font(.system(size: 50))
//                                Text(LocalizedStrings.string(for: "select_image_to_preview", language: languageManager.currentLanguage))
//                                    .foregroundColor(.gray)
//                            }
//                        )
//                }
//
//                if selectedImage != nil {
//                    // Visual indicator for selected image
//                    Rectangle()
//                        .stroke(Color.blue.opacity(0.3), lineWidth: 2)
//                        .frame(height: 300)
//                }
//            }
//            .onTapGesture {
//                showingImagePicker = true
//            }
//        }
//        .padding()
//    }
//
//    private var sizeComparisonView: some View {
//        HStack {
//            VStack {
//                Text(LocalizedStrings.string(for: "original", language: languageManager.currentLanguage))
//                if originalFileSize > 0 {
//                    Text(formatBytes(originalFileSize))
//                        .foregroundColor(.orange)
//                        .font(.system(size: 16, weight: .semibold))
//                } else if selectedImage != nil {
//                    HStack(spacing: 4) {
//                        ProgressView()
//                            .scaleEffect(0.7)
//                        Text("Loading...")
//                            .font(.caption)
//                    }
//                    .foregroundColor(.orange)
//                } else {
//                    Text("--")
//                        .foregroundColor(.orange)
//                }
//            }
//            
//            Spacer()
//            Image(systemName: "arrow.right")
//            Spacer()
//            
//            VStack {
//                Text(LocalizedStrings.string(for: "compressed", language: languageManager.currentLanguage))
//                if let image = selectedImage, originalFileSize > 0 {
//                    Text(getCompressedSizeText(for: image))
//                        .foregroundColor(.green)
//                        .font(.system(size: 16, weight: .semibold))
//                } else if selectedImage != nil {
//                    HStack(spacing: 4) {
//                        ProgressView()
//                            .scaleEffect(0.7)
//                        Text("Calculating...")
//                            .font(.caption)
//                    }
//                    .foregroundColor(.green)
//                } else {
//                    Text("--")
//                        .foregroundColor(.green)
//                }
//            }
//        }
//        .padding()
//    }
//    
//    private var compressButton: some View {
//        Button(action: {
//            compressAndReplace()
//        }) {
//            HStack {
//                if isCompressing {
//                    ProgressView()
//                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
//                } else {
//                    Image(systemName: "arrow.down.circle.fill")
//                    Text(LocalizedStrings.string(for: "compress", language: languageManager.currentLanguage))
//                }
//            }
//            .foregroundColor(.white)
//            .padding()
//            .frame(maxWidth: .infinity)
//            .background(Color.blue)
//            .cornerRadius(10)
//        }
//        .disabled(isCompressing)
//    }
//
//    private var loadingOverlay: some View {
//        ZStack {
//            Color.black.opacity(0.3).ignoresSafeArea()
//            VStack(spacing: 15) {
//                ProgressView()
//                    .scaleEffect(1.5)
//                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
//                Text("Compressing...")
//                    .foregroundColor(.white)
//                    .font(.headline)
//                
//                if compressionCount > 0 {
//                    Text("Compression #\(compressionCount + 1)")
//                        .foregroundColor(.white.opacity(0.8))
//                        .font(.caption)
//                }
//            }
//            .padding(30)
//            .background(Color.black.opacity(0.7))
//            .cornerRadius(12)
//        }
//    }
//
//    private func checkPhotoLibraryPermission() {
//        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
//        switch status {
//        case .authorized:
//            break
//        case .limited:
//            showingPermissionAlert = true
//        case .notDetermined:
//            PHPhotoLibrary.requestAuthorization(for: .readWrite) { newStatus in
//                DispatchQueue.main.async {
//                    if newStatus != .authorized {
//                        showingPermissionAlert = true
//                    }
//                }
//            }
//        default:
//            showingPermissionAlert = true
//        }
//    }
//
//    private func compressAndReplace() {
//        guard let image = selectedImage else { return }
//        
//        // Check if maximum compressions reached
//        if compressionCount >= 5 {
//            compressionResult.errorMessage = "Maximum 5 compressions allowed per image. Please select a new image."
//            showErrorAlert = true
//            return
//        }
//
//        isCompressing = true
//        let currentSize = originalFileSize // Use CURRENT file size, not original
//
//        DispatchQueue.global(qos: .userInitiated).async {
//            // Calculate target size based on CURRENT image size (incremental compression)
//            let targetSize = Int64(Double(currentSize) * self.selectedQuality.targetSizeRatio)
//            
//            print("🎯 Current size: \(self.formatBytes(currentSize))")
//            print("🎯 Target size: \(self.formatBytes(targetSize)) (\(Int(self.selectedQuality.targetSizeRatio * 100))% of current)")
//            print("📊 Compression #\(self.compressionCount + 1)")
//            
//            // Try different compression qualities to achieve target size
//            var compressionQuality = self.selectedQuality.initialCompressionQuality
//            var compressedData: Data?
//            var bestData: Data?
//            var bestDifference = Int64.max
//            var attempts = 0
//            let maxAttempts = 20
//            
//            // Binary search for the best compression quality
//            var minQuality: CGFloat = 0.01
//            var maxQuality: CGFloat = 1.0
//            
//            while attempts < maxAttempts && maxQuality - minQuality > 0.01 {
//                compressionQuality = (minQuality + maxQuality) / 2
//                compressedData = image.jpegData(compressionQuality: compressionQuality)
//                
//                if let data = compressedData {
//                    let currentSize = Int64(data.count)
//                    let difference = abs(currentSize - targetSize)
//                    
//                    print("🔄 Attempt \(attempts + 1): Quality \(String(format: "%.3f", compressionQuality)) → Size \(self.formatBytes(currentSize)) (target: \(self.formatBytes(targetSize)))")
//                    
//                    // Keep track of the best result so far
//                    if difference < bestDifference {
//                        bestDifference = difference
//                        bestData = data
//                    }
//                    
//                    // If we're within 5% of target, accept it
//                    if difference <= targetSize / 20 {
//                        bestData = data
//                        break
//                    }
//                    
//                    // Adjust search range
//                    if currentSize > targetSize {
//                        maxQuality = compressionQuality
//                    } else {
//                        minQuality = compressionQuality
//                    }
//                }
//                
//                attempts += 1
//            }
//            
//            guard let finalCompressedData = bestData else {
//                DispatchQueue.main.async {
//                    self.compressionResult.errorMessage = "Failed to compress image."
//                    self.showErrorAlert = true
//                    self.isCompressing = false
//                }
//                return
//            }
//
//            let compressedSize = Int64(finalCompressedData.count)
//            let savedSpace = currentSize - compressedSize
//            
//            print("✅ Final compressed size: \(self.formatBytes(compressedSize)) (saved: \(self.formatBytes(savedSpace)))")
//            print("📊 Size reduction: \(String(format: "%.1f", (1.0 - Double(compressedSize)/Double(currentSize)) * 100))%")
//
//            // Create resource options to ensure JPEG format
//            let options = PHAssetResourceCreationOptions()
//            options.uniformTypeIdentifier = "public.jpeg"
//            
//            // Create compressed UIImage for immediate reuse
//            let compressedUIImage = UIImage(data: finalCompressedData) ?? image
//            
//            // Variable to store the new asset's identifier
//            var newAssetIdentifier: String?
//            
//            PHPhotoLibrary.shared().performChanges({
//                // Create asset from JPEG data with explicit type
//                let creationRequest = PHAssetCreationRequest.forAsset()
//                creationRequest.addResource(with: .photo, data: finalCompressedData, options: options)
//                
//                // Get the placeholder for the newly created asset
//                if let placeholder = creationRequest.placeholderForCreatedAsset {
//                    newAssetIdentifier = placeholder.localIdentifier
//                }
//            }) { success, error in
//                if success {
//                    // Delete original if exists
//                    if let originalAsset = self.selectedAsset {
//                        PHPhotoLibrary.shared().performChanges({
//                            PHAssetChangeRequest.deleteAssets([originalAsset] as NSArray)
//                        }) { _, _ in
//                            // Don't care if deletion fails, we already have the new compressed image
//                        }
//                    }
//                    
//                    // Fetch the newly created asset
//                    if let assetId = newAssetIdentifier {
//                        let fetchOptions = PHFetchOptions()
//                        let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [assetId], options: fetchOptions)
//                        
//                        DispatchQueue.main.async {
//                            self.isCompressing = false
//                            
//                            // Update UI with compressed image and new asset
//                            self.selectedImage = compressedUIImage
//                            self.originalFileSize = compressedSize
//                            self.selectedAsset = fetchResult.firstObject // New compressed asset
//                            
//                            // Update compression count and history
//                            self.compressionCount += 1
//                            
//                            // Calculate actual compression percentage from CURRENT size
//                            let actualCompressionPercent = Int((1.0 - (Double(compressedSize) / Double(currentSize))) * 100)
//                            
//                            self.compressionHistory.append(CompressionHistoryItem(
//                                step: self.compressionCount,
//                                fromSize: self.formatBytes(currentSize),
//                                toSize: self.formatBytes(compressedSize),
//                                percentage: "\(actualCompressionPercent)% compressed"
//                            ))
//                            
//                            self.compressionResult = CompressionResult(
//                                originalSize: self.formatBytes(currentSize),
//                                compressedSize: self.formatBytes(compressedSize),
//                                savedSpace: self.formatBytes(savedSpace)
//                            )
//                            self.showSuccessAlert = true
//                        }
//                    } else {
//                        // Fallback if we couldn't get the new asset
//                        DispatchQueue.main.async {
//                            self.isCompressing = false
//                            
//                            // Still update with compressed image
//                            self.selectedImage = compressedUIImage
//                            self.originalFileSize = compressedSize
//                            self.selectedAsset = nil
//                            
//                            // Update compression count and history
//                            self.compressionCount += 1
//                            
//                            // Calculate actual compression percentage from CURRENT size
//                            let actualCompressionPercent = Int((1.0 - (Double(compressedSize) / Double(currentSize))) * 100)
//                            
//                            self.compressionHistory.append(CompressionHistoryItem(
//                                step: self.compressionCount,
//                                fromSize: self.formatBytes(currentSize),
//                                toSize: self.formatBytes(compressedSize),
//                                percentage: "\(actualCompressionPercent)% compressed"
//                            ))
//                            
//                            self.compressionResult = CompressionResult(
//                                originalSize: self.formatBytes(currentSize),
//                                compressedSize: self.formatBytes(compressedSize),
//                                savedSpace: self.formatBytes(savedSpace)
//                            )
//                            self.showSuccessAlert = true
//                        }
//                    }
//                } else {
//                    DispatchQueue.main.async {
//                        self.isCompressing = false
//                        self.compressionResult.errorMessage = error?.localizedDescription ?? "Failed to save compressed image."
//                        self.showErrorAlert = true
//                    }
//                }
//            }
//        }
//    }
//
//    private func getCompressedSizeText(for image: UIImage) -> String {
//        // Calculate target size based on selected quality
//        let targetSize = Int64(Double(originalFileSize) * selectedQuality.targetSizeRatio)
//        return formatBytes(targetSize)
//    }
//
//    private func formatBytes(_ bytes: Int64) -> String {
//        let formatter = ByteCountFormatter()
//        formatter.allowedUnits = [.useKB, .useMB, .useGB]
//        formatter.countStyle = .file
//        return formatter.string(fromByteCount: bytes)
//    }
//}
//
//// MARK: - Preview
//struct MediaCompressionView_Previews: PreviewProvider {
//    static var previews: some View {
//        MediaCompressionView()
//            .environmentObject(LanguageManager())
//    }
//}

enum CompressionQuality: String, CaseIterable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"

    func localizedTitle(language: String) -> String {
        return LocalizedStrings.string(for: self.rawValue, language: language)
    }

    func compressionPercentage(language: String) -> String {
        switch self {
        case .low:
            return "20% " + LocalizedStrings.string(for: "compress", language: language)
        case .medium:
            return "50% " + LocalizedStrings.string(for: "compress", language: language)
        case .high:
            return "80% " + LocalizedStrings.string(for: "compress", language: language)
        }
    }

    // This returns the target file size ratio (what percentage of CURRENT size to keep)
    var targetSizeRatio: Double {
        switch self {
        case .low: return 0.8     // 20% compression = keep 80% of CURRENT size
        case .medium: return 0.5  // 50% compression = keep 50% of CURRENT size
        case .high: return 0.2    // 80% compression = keep 20% of CURRENT size
        }
    }
    
    // Initial compression quality to try
    var initialCompressionQuality: CGFloat {
        switch self {
        case .low: return 0.9     // Start with high quality for low compression
        case .medium: return 0.5   // Start with medium quality
        case .high: return 0.2     // Start with low quality for high compression
        }
    }
}

// MARK: - Image Picker
struct ImagePickerWithAsset: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Binding var selectedAsset: PHAsset?
    @Binding var originalFileSize: Int64
    @Binding var imageFormat: String
    @Environment(\.presentationMode) private var presentationMode

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        configuration.preferredAssetRepresentationMode = .current

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePickerWithAsset
        
        init(_ parent: ImagePickerWithAsset) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.presentationMode.wrappedValue.dismiss()
            
            guard let result = results.first else { return }
            
            // Reset values
            DispatchQueue.main.async {
                self.parent.selectedImage = nil
                self.parent.selectedAsset = nil
                self.parent.originalFileSize = 0
                self.parent.imageFormat = "Unknown"
            }
            
            // Priority 1: Try to get actual file data (most accurate)
            self.loadActualFileData(from: result)
            
            // Load image for display
            result.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                if let image = image as? UIImage {
                    DispatchQueue.main.async {
                        self.parent.selectedImage = image
                    }
                }
            }
        }
        
        private func loadActualFileData(from result: PHPickerResult) {
            let typeIdentifiers = [
                UTType.image.identifier,
                UTType.heif.identifier,
                UTType.heic.identifier,
                UTType.rawImage.identifier,
                UTType.png.identifier,
                UTType.jpeg.identifier,
                UTType.tiff.identifier,
                UTType.gif.identifier,
                UTType.bmp.identifier,
                UTType.webP.identifier
            ]
            
            // Find which type identifier the item conforms to
            var foundType: String?
            for typeId in typeIdentifiers {
                if result.itemProvider.hasItemConformingToTypeIdentifier(typeId) {
                    foundType = typeId
                    break
                }
            }
            
            guard let typeIdentifier = foundType else {
                print("❌ No supported image type found")
                self.fallbackToAssetSize(result: result)
                return
            }
            
            // Update format
            DispatchQueue.main.async {
                self.parent.imageFormat = self.getFormatName(from: typeIdentifier)
            }
            
            // Method 1: Load data representation (most accurate)
            result.itemProvider.loadDataRepresentation(forTypeIdentifier: typeIdentifier) { data, error in
                if let data = data {
                    DispatchQueue.main.async {
                        self.parent.originalFileSize = Int64(data.count)
                        print("✅ Actual file data size: \(data.count) bytes (\(ByteCountFormatter.string(fromByteCount: Int64(data.count), countStyle: .file)))")
                        print("📄 Format: \(self.parent.imageFormat)")
                    }
                    return
                }
                
                // Method 2: Try file representation
                result.itemProvider.loadFileRepresentation(forTypeIdentifier: typeIdentifier) { url, error in
                    if let url = url {
                        do {
                            let resourceValues = try url.resourceValues(forKeys: [.fileSizeKey, .typeIdentifierKey])
                            if let fileSize = resourceValues.fileSize {
                                DispatchQueue.main.async {
                                    self.parent.originalFileSize = Int64(fileSize)
                                    if let typeId = resourceValues.typeIdentifier {
                                        self.parent.imageFormat = self.getFormatName(from: typeId)
                                    }
                                    print("✅ File size from URL: \(fileSize) bytes (\(ByteCountFormatter.string(fromByteCount: Int64(fileSize), countStyle: .file)))")
                                }
                                return
                            }
                        } catch {
                            print("❌ Error getting file size from URL: \(error)")
                        }
                    }
                    
                    // Fallback to PHAsset
                    self.fallbackToAssetSize(result: result)
                }
            }
        }
        
        private func getFormatName(from typeIdentifier: String) -> String {
            switch typeIdentifier {
            case UTType.jpeg.identifier: return "JPEG"
            case UTType.png.identifier: return "PNG"
            case UTType.heif.identifier, UTType.heic.identifier: return "HEIF/HEIC"
            case UTType.gif.identifier: return "GIF"
            case UTType.tiff.identifier: return "TIFF"
            case UTType.bmp.identifier: return "BMP"
            case UTType.webP.identifier: return "WebP"
            case UTType.rawImage.identifier: return "RAW"
            default: return "Image"
            }
        }
        
        private func fallbackToAssetSize(result: PHPickerResult) {
            // Try to get PHAsset for more accurate size
            if let assetIdentifier = result.assetIdentifier {
                let fetchOptions = PHFetchOptions()
                let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [assetIdentifier], options: fetchOptions)
                if let asset = fetchResult.firstObject {
                    DispatchQueue.main.async {
                        self.parent.selectedAsset = asset
                    }
                    
                    // Get actual file size from asset
                    self.getActualFileSize(from: asset) { size, format in
                        DispatchQueue.main.async {
                            if size > 0 {
                                self.parent.originalFileSize = size
                                self.parent.imageFormat = format
                                print("✅ File size from PHAsset: \(size) bytes (\(ByteCountFormatter.string(fromByteCount: size, countStyle: .file)))")
                            } else {
                                // Last resort: smart estimation
                                self.smartEstimateFileSize()
                            }
                        }
                    }
                } else {
                    self.smartEstimateFileSize()
                }
            } else {
                self.smartEstimateFileSize()
            }
        }
        
        private func getActualFileSize(from asset: PHAsset, completion: @escaping (Int64, String) -> Void) {
            let resources = PHAssetResource.assetResources(for: asset)
            
            guard let resource = resources.first(where: { $0.type == .photo }) ?? resources.first else {
                completion(0, "Unknown")
                return
            }
            
            // Get format from resource
            let format = getFormatFromResource(resource)
            
            // Try to get file size using data request
            let resourceManager = PHAssetResourceManager.default()
            let options = PHAssetResourceRequestOptions()
            options.isNetworkAccessAllowed = true
            
            var totalSize: Int64 = 0
            resourceManager.requestData(for: resource, options: options, dataReceivedHandler: { data in
                totalSize += Int64(data.count)
            }, completionHandler: { error in
                if error == nil && totalSize > 0 {
                    completion(totalSize, format)
                } else {
                    // Try alternate method
                    if let fileSize = resource.value(forKey: "fileSize") as? CLong {
                        completion(Int64(fileSize), format)
                    } else {
                        completion(0, format)
                    }
                }
            })
        }
        
        private func getFormatFromResource(_ resource: PHAssetResource) -> String {
            let uti = resource.uniformTypeIdentifier
            
            if uti.contains("heif") || uti.contains("heic") {
                return "HEIF/HEIC"
            } else if uti.contains("jpeg") || uti.contains("jpg") {
                return "JPEG"
            } else if uti.contains("png") {
                return "PNG"
            } else if uti.contains("gif") {
                return "GIF"
            } else if uti.contains("tiff") {
                return "TIFF"
            } else if uti.contains("raw") {
                return "RAW"
            } else if uti.contains("webp") {
                return "WebP"
            }
            
            return "Image"
        }
        
        private func smartEstimateFileSize() {
            guard let image = self.parent.selectedImage else { return }
            
            // Try to detect format from image data
            let format = detectImageFormat(from: image)
            
            DispatchQueue.main.async {
                self.parent.imageFormat = format
            }
            
            // Calculate based on format
            let estimatedSize = self.calculateSmartFileSize(for: image, format: format)
            
            DispatchQueue.main.async {
                self.parent.originalFileSize = estimatedSize
                print("⚠️ Estimated file size: \(estimatedSize) bytes (\(ByteCountFormatter.string(fromByteCount: estimatedSize, countStyle: .file)))")
                print("📄 Detected format: \(format)")
            }
        }
        
        private func detectImageFormat(from image: UIImage) -> String {
            // Try to get format from CGImage properties
            if let cgImage = image.cgImage {
                let bitsPerComponent = cgImage.bitsPerComponent
                let bitsPerPixel = cgImage.bitsPerPixel
                let hasAlpha = cgImage.alphaInfo != .none && cgImage.alphaInfo != .noneSkipLast && cgImage.alphaInfo != .noneSkipFirst
                
                if hasAlpha && bitsPerComponent == 8 {
                    return "PNG" // Likely PNG due to alpha channel
                }
            }
            
            // Default to JPEG for photos without alpha
            return "JPEG"
        }
        
        private func calculateSmartFileSize(for image: UIImage, format: String) -> Int64 {
            let width = Int(image.size.width * image.scale)
            let height = Int(image.size.height * image.scale)
            let totalPixels = width * height
            
            // Format-specific bytes per pixel estimation
            let bytesPerPixel: Double
            
            switch format {
            case "HEIF/HEIC":
                // HEIF is highly compressed
                if totalPixels > 10_000_000 {
                    bytesPerPixel = 0.2
                } else if totalPixels > 5_000_000 {
                    bytesPerPixel = 0.25
                } else {
                    bytesPerPixel = 0.3
                }
                
            case "PNG":
                // PNG is lossless, larger files
                if image.cgImage?.alphaInfo != .none {
                    bytesPerPixel = 3.0 // With alpha channel
                } else {
                    bytesPerPixel = 2.0 // Without alpha
                }
                
            case "RAW":
                // RAW files are very large
                bytesPerPixel = 6.0
                
            case "GIF":
                // GIF uses 8-bit color
                bytesPerPixel = 1.0
                
            case "TIFF":
                // TIFF can be large
                bytesPerPixel = 4.0
                
            default: // JPEG and others
                if totalPixels > 10_000_000 {
                    bytesPerPixel = 0.3
                } else if totalPixels > 5_000_000 {
                    bytesPerPixel = 0.35
                } else if totalPixels > 2_000_000 {
                    bytesPerPixel = 0.4
                } else {
                    bytesPerPixel = 0.5
                }
            }
            
            let estimatedSize = Int64(Double(totalPixels) * bytesPerPixel)
            
            print("📐 Image: \(width)×\(height) (\(totalPixels) pixels)")
            print("📏 Format: \(format), Bytes/pixel: \(bytesPerPixel)")
            print("📏 Estimated size: \(estimatedSize) bytes (\(String(format: "%.1f", Double(estimatedSize)/1024/1024)) MB)")
            
            return estimatedSize
        }
    }
}

// MARK: - Main View
struct MediaCompressionView: View {
    @State private var selectedQuality: CompressionQuality = .medium
    @State private var showingImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var selectedAsset: PHAsset?
    @State private var originalFileSize: Int64 = 0
    @State private var imageFormat: String = "Unknown"
    @State private var showingPermissionAlert = false
    @State private var isCompressing = false
    @State private var showSuccessAlert = false
    @State private var showErrorAlert = false
    @State private var compressionResult = CompressionResult()
    @State private var compressionCount = 0
    @State private var compressionHistory: [CompressionHistoryItem] = []
    @State private var lastCompressionUsedResizing = false
    @EnvironmentObject var languageManager: LanguageManager

    struct CompressionResult {
        var originalSize: String = ""
        var compressedSize: String = ""
        var savedSpace: String = ""
        var errorMessage: String = ""
    }
    
    struct CompressionHistoryItem {
        var step: Int
        var fromSize: String
        var toSize: String
        var percentage: String
    }

    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack(spacing: 16) {
                        qualitySection
                        imageComparisonView
                        sizeComparisonView
                        
//                        // Compression history
//                        if !compressionHistory.isEmpty {
//                            compressionHistoryView
//                        }
                    }
                }

                if selectedImage != nil {
                    VStack(spacing: 10) {
//                        if compressionCount > 0 {
//                            Text("Compressed \(compressionCount) time\(compressionCount == 1 ? "" : "s") of 5 maximum")
//                                .font(.caption)
//                                .foregroundColor(compressionCount >= 5 ? .orange : .green)
//                        }
                        
                        compressButton
                            .disabled(compressionCount >= 5)
                        
//                        if compressionCount >= 5 {
//                            Text("Maximum compressions reached")
//                                .font(.caption)
//                                .foregroundColor(.orange)
//                                .padding(.top, 5)
//                        }
                    }
                    .padding()
                    .background(Color(UIColor.systemBackground))
                }
            }
            .onAppear {
                checkPhotoLibraryPermission()
            }
            .alert("Permission Required", isPresented: $showingPermissionAlert) {
                Button("Settings") {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Please allow full access to your photo library to compress and replace images. Limited access prevents deleting the original image, which may cause duplicates.")
            }
            .alert(LocalizedStrings.string(for: "image_compressed_successfully", language: languageManager.currentLanguage), isPresented: $showSuccessAlert) {
                Button(LocalizedStrings.string(for: "done", language: languageManager.currentLanguage), role: .cancel) {
                    selectedImage = nil
                    selectedAsset = nil
                    originalFileSize = 0
                    compressionCount = 0
                    compressionHistory.removeAll()
                    imageFormat = "Unknown"
                }
            } message: {
                Text("Compressed successfully!")
            }
            .alert("Compression Failed ❌", isPresented: $showErrorAlert) {
                Button("OK") {}
            } message: {
                Text(compressionResult.errorMessage)
            }
            .overlay {
                if isCompressing {
                    loadingOverlay
                }
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePickerWithAsset(
                    selectedImage: $selectedImage,
                    selectedAsset: $selectedAsset,
                    originalFileSize: $originalFileSize,
                    imageFormat: $imageFormat
                )
                .onDisappear {
                    // Reset compression count when selecting new image
                    if selectedImage != nil {
                        compressionCount = 0
                        compressionHistory.removeAll()
                    }
                }
            }
        }
    }
    
//    private var compressionHistoryView: some View {
//        VStack(alignment: .leading, spacing: 10) {
//            HStack {
//                Text("Compression History")
//                    .font(.headline)
//                
//                Spacer()
//                
//                Text("\(compressionCount)/5")
//                    .font(.caption)
//                    .foregroundColor(compressionCount >= 5 ? .orange : .gray)
//                    .padding(.horizontal, 8)
//                    .padding(.vertical, 4)
//                    .background(Color.gray.opacity(0.2))
//                    .cornerRadius(12)
//            }
//            .padding(.horizontal)
//            
//            VStack(spacing: 8) {
//                ForEach(compressionHistory, id: \.step) { item in
//                    HStack {
//                        Text("Step \(item.step):")
//                            .font(.caption)
//                            .foregroundColor(.gray)
//                        
//                        Text(item.fromSize)
//                            .font(.caption)
//                            .foregroundColor(.orange)
//                        
//                        Image(systemName: "arrow.right")
//                            .font(.caption)
//                            .foregroundColor(.gray)
//                        
//                        Text(item.toSize)
//                            .font(.caption)
//                            .foregroundColor(.green)
//                        
//                        Spacer()
//                        
//                        Text(item.percentage)
//                            .font(.caption)
//                            .foregroundColor(.blue)
//                        
//                        if item.percentage.contains("📐") {
//                            Text("Resized")
//                                .font(.caption2)
//                                .foregroundColor(.purple)
//                                .padding(.horizontal, 6)
//                                .padding(.vertical, 2)
//                                .background(Color.purple.opacity(0.2))
//                                .cornerRadius(4)
//                        }
//                    }
//                    .padding(.horizontal)
//                    .padding(.vertical, 4)
//                    .background(Color.gray.opacity(0.1))
//                    .cornerRadius(8)
//                }
//            }
//            .padding(.horizontal)
//        }
//    }

    private var qualitySection: some View {
        VStack(alignment: .leading) {
            Text(LocalizedStrings.string(for: "quality", language: languageManager.currentLanguage))
                .font(.headline)
                .padding(.horizontal)

            HStack(spacing: 8) {
                ForEach(CompressionQuality.allCases, id: \.self) { quality in
                    Button(action: {
                        selectedQuality = quality
                    }) {
                        VStack {
                            Text(quality.localizedTitle(language: languageManager.currentLanguage))
                                .font(.system(size: 16, weight: .medium))
                            Text(quality.compressionPercentage(language: languageManager.currentLanguage))
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(selectedQuality == quality ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1))
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)
        }
    }

    private var imageComparisonView: some View {
        VStack(spacing: 10) {
            ZStack {
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 300)
                } else {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.1))
                        .frame(height: 300)
                        .overlay(
                            VStack {
                                Image(systemName: "photo")
                                    .font(.system(size: 50))
                                Text(LocalizedStrings.string(for: "select_image_to_preview", language: languageManager.currentLanguage))
                                    .foregroundColor(.gray)
                            }
                        )
                }

                if selectedImage != nil {
                    // Visual indicator for selected image with format badge
                    VStack {
                        HStack {
                            Spacer()
                            Text(imageFormat)
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.blue.opacity(0.8))
                                .foregroundColor(.white)
                                .cornerRadius(6)
                                .padding(8)
                        }
                        Spacer()
                    }
                }
            }
            .onTapGesture {
                showingImagePicker = true
            }
        }
        .padding()
    }

    private var sizeComparisonView: some View {
        HStack {
            VStack {
                Text(LocalizedStrings.string(for: "original", language: languageManager.currentLanguage))
                if originalFileSize > 0 {
                    Text(formatBytes(originalFileSize))
                        .foregroundColor(.orange)
                        .font(.system(size: 16, weight: .semibold))
                } else if selectedImage != nil {
                    HStack(spacing: 4) {
                        ProgressView()
                            .scaleEffect(0.7)
                        Text("Loading...")
                            .font(.caption)
                    }
                    .foregroundColor(.orange)
                } else {
                    Text("--")
                        .foregroundColor(.orange)
                }
            }
            
            Spacer()
            Image(systemName: "arrow.right")
            Spacer()
            
            VStack {
                Text(LocalizedStrings.string(for: "compressed", language: languageManager.currentLanguage))
                if let image = selectedImage, originalFileSize > 0 {
                    Text(getCompressedSizeText(for: image))
                        .foregroundColor(.green)
                        .font(.system(size: 16, weight: .semibold))
                } else if selectedImage != nil {
                    HStack(spacing: 4) {
                        ProgressView()
                            .scaleEffect(0.7)
                        Text("Calculating...")
                            .font(.caption)
                    }
                    .foregroundColor(.green)
                } else {
                    Text("--")
                        .foregroundColor(.green)
                }
            }
        }
        .padding()
    }
    
    private var compressButton: some View {
        Button(action: {
            compressAndReplace()
        }) {
            HStack {
                if isCompressing {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Image(systemName: "arrow.down.circle.fill")
                    Text(LocalizedStrings.string(for: "compress", language: languageManager.currentLanguage))
                }
            }
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .cornerRadius(10)
        }
        .disabled(isCompressing || originalFileSize == 0)
    }

    private var loadingOverlay: some View {
        ZStack {
            Color.black.opacity(0.3).ignoresSafeArea()
            VStack(spacing: 15) {
                ProgressView()
                    .scaleEffect(1.5)
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                Text("Compressing...")
                    .foregroundColor(.white)
                    .font(.headline)
                
                if compressionCount > 0 {
                    Text("Compression #\(compressionCount + 1)")
                        .foregroundColor(.white.opacity(0.8))
                        .font(.caption)
                }
            }
            .padding(30)
            .background(Color.black.opacity(0.7))
            .cornerRadius(12)
        }
    }

    private func checkPhotoLibraryPermission() {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        switch status {
        case .authorized:
            break
        case .limited:
            showingPermissionAlert = true
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { newStatus in
                DispatchQueue.main.async {
                    if newStatus != .authorized {
                        showingPermissionAlert = true
                    }
                }
            }
        default:
            showingPermissionAlert = true
        }
    }

    private func compressAndReplace() {
        guard let image = selectedImage else { return }
        
        // Check if maximum compressions reached
        if compressionCount >= 5 {
            compressionResult.errorMessage = "Maximum 5 compressions allowed per image. Please select a new image."
            showErrorAlert = true
            return
        }

        isCompressing = true
        let currentSize = originalFileSize // Use CURRENT file size, not original

        DispatchQueue.global(qos: .userInitiated).async {
            // Calculate target size based on CURRENT image size (incremental compression)
            let targetSize = Int64(Double(currentSize) * self.selectedQuality.targetSizeRatio)
            
            print("🎯 Current size: \(self.formatBytes(currentSize))")
            print("🎯 Target size: \(self.formatBytes(targetSize)) (\(Int(self.selectedQuality.targetSizeRatio * 100))% of current)")
            print("📊 Compression #\(self.compressionCount + 1)")
            print("📄 Original format: \(self.imageFormat)")
            
            // First, try compression only
            var bestData: Data?
            var bestSize: Int64 = Int64.max
            var usedResizing = false
            var resizedImage = image
            
            // Step 1: Try multiple JPEG qualities
            let qualities: [CGFloat] = [0.9, 0.7, 0.5, 0.3, 0.1, 0.05, 0.01]
            for quality in qualities {
                if let data = image.jpegData(compressionQuality: quality) {
                    let size = Int64(data.count)
                    print("🔄 Quality \(quality): \(self.formatBytes(size))")
                    
                    if abs(size - targetSize) < abs(bestSize - targetSize) {
                        bestData = data
                        bestSize = size
                    }
                    
                    // If we're close enough, stop
                    if size <= targetSize && size >= targetSize * Int64(0.9) {
                        break
                    }
                }
            }
            
            // Step 2: If compression alone can't achieve target, combine with resizing
            if bestSize > targetSize * Int64(1.1) { // If still more than 10% over target
                print("📐 Compression alone insufficient. Adding image resizing...")
                
                // Calculate required size reduction
                let sizeReductionNeeded = Double(targetSize) / Double(bestSize)
                let dimensionScale = sqrt(sizeReductionNeeded)
                
                // Resize the image
                resizedImage = self.resizeImage(image, scale: dimensionScale)
                usedResizing = true
                
                // Try compression again with resized image
                bestData = nil
                bestSize = Int64.max
                
                for quality in qualities {
                    if let data = resizedImage.jpegData(compressionQuality: quality) {
                        let size = Int64(data.count)
                        print("🔄 Resized + Quality \(quality): \(self.formatBytes(size))")
                        
                        if abs(size - targetSize) < abs(bestSize - targetSize) {
                            bestData = data
                            bestSize = size
                        }
                        
                        // If we achieved target, stop
                        if size <= targetSize {
                            break
                        }
                    }
                }
            }
            
            // Step 3: If still over target, use more aggressive resizing
            if bestSize > targetSize && usedResizing {
                print("🎯 Fine-tuning size with additional resizing...")
                
                let additionalScale = Double(targetSize) / Double(bestSize) * 0.95 // Slightly under to ensure we hit target
                resizedImage = self.resizeImage(resizedImage, scale: additionalScale)
                
                // Use medium quality for final compression
                if let data = resizedImage.jpegData(compressionQuality: 0.7) {
                    bestData = data
                    bestSize = Int64(data.count)
                }
            }
            
            guard let finalCompressedData = bestData else {
                DispatchQueue.main.async {
                    self.compressionResult.errorMessage = "Failed to compress image."
                    self.showErrorAlert = true
                    self.isCompressing = false
                }
                return
            }

            let compressedSize = Int64(finalCompressedData.count)
            let savedSpace = currentSize - compressedSize
            let actualCompressionPercent = Int((1.0 - (Double(compressedSize) / Double(currentSize))) * 100)
            
            print("✅ Final compressed size: \(self.formatBytes(compressedSize)) (saved: \(self.formatBytes(savedSpace)))")
            print("📊 Actual compression: \(actualCompressionPercent)% (target was \(Int((1.0 - self.selectedQuality.targetSizeRatio) * 100))%)")
            print("📐 Used resizing: \(usedResizing)")

            // Create resource options to ensure JPEG format
            let options = PHAssetResourceCreationOptions()
            options.uniformTypeIdentifier = UTType.jpeg.identifier
            
            // Create compressed UIImage for immediate reuse
            let compressedUIImage = UIImage(data: finalCompressedData) ?? resizedImage
            
            // Variable to store the new asset's identifier
            var newAssetIdentifier: String?
            
            PHPhotoLibrary.shared().performChanges({
                // Create asset from JPEG data with explicit type
                let creationRequest = PHAssetCreationRequest.forAsset()
                creationRequest.addResource(with: .photo, data: finalCompressedData, options: options)
                
                // Get the placeholder for the newly created asset
                if let placeholder = creationRequest.placeholderForCreatedAsset {
                    newAssetIdentifier = placeholder.localIdentifier
                }
            }) { success, error in
                if success {
                    // Delete original if exists
                    if let originalAsset = self.selectedAsset {
                        PHPhotoLibrary.shared().performChanges({
                            PHAssetChangeRequest.deleteAssets([originalAsset] as NSArray)
                        }) { _, _ in
                            // Don't care if deletion fails, we already have the new compressed image
                        }
                    }
                    
                    // Fetch the newly created asset
                    if let assetId = newAssetIdentifier {
                        let fetchOptions = PHFetchOptions()
                        let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [assetId], options: fetchOptions)
                        
                        DispatchQueue.main.async {
                            self.isCompressing = false
                            
                            // Update UI with compressed image and new asset
                            self.selectedImage = compressedUIImage
                            self.originalFileSize = compressedSize
                            self.selectedAsset = fetchResult.firstObject // New compressed asset
                            self.imageFormat = "JPEG" // Always JPEG after compression
                            
                            // Update compression count and history
                            self.compressionCount += 1
                            self.lastCompressionUsedResizing = usedResizing
                            self.lastCompressionUsedResizing = usedResizing
                            
                            // Calculate actual compression percentage from CURRENT size
                            let actualCompressionPercent = Int((1.0 - (Double(compressedSize) / Double(currentSize))) * 100)
                            
                            self.compressionHistory.append(CompressionHistoryItem(
                                step: self.compressionCount,
                                fromSize: self.formatBytes(currentSize),
                                toSize: self.formatBytes(compressedSize),
                                percentage: "\(actualCompressionPercent)% compressed" + (usedResizing ? " 📐" : "")
                            ))
                            
                            self.compressionResult = CompressionResult(
                                originalSize: self.formatBytes(currentSize),
                                compressedSize: self.formatBytes(compressedSize),
                                savedSpace: self.formatBytes(savedSpace)
                            )
                            self.showSuccessAlert = true
                        }
                    } else {
                        // Fallback if we couldn't get the new asset
                        DispatchQueue.main.async {
                            self.isCompressing = false
                            
                            // Still update with compressed image
                            self.selectedImage = compressedUIImage
                            self.originalFileSize = compressedSize
                            self.selectedAsset = nil
                            self.imageFormat = "JPEG"
                            
                            // Update compression count and history
                            self.compressionCount += 1
                            
                            // Calculate actual compression percentage from CURRENT size
                            let actualCompressionPercent = Int((1.0 - (Double(compressedSize) / Double(currentSize))) * 100)
                            
                            self.compressionHistory.append(CompressionHistoryItem(
                                step: self.compressionCount,
                                fromSize: self.formatBytes(currentSize),
                                toSize: self.formatBytes(compressedSize),
                                percentage: "\(actualCompressionPercent)% compressed" + (usedResizing ? " 📐" : "")
                            ))
                            
                            self.compressionResult = CompressionResult(
                                originalSize: self.formatBytes(currentSize),
                                compressedSize: self.formatBytes(compressedSize),
                                savedSpace: self.formatBytes(savedSpace)
                            )
                            self.showSuccessAlert = true
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.isCompressing = false
                        self.compressionResult.errorMessage = error?.localizedDescription ?? "Failed to save compressed image."
                        self.showErrorAlert = true
                    }
                }
            }
        }
    }

    private func getCompressedSizeText(for image: UIImage) -> String {
        // Calculate target size based on selected quality
        let targetSize = Int64(Double(originalFileSize) * selectedQuality.targetSizeRatio)
        return formatBytes(targetSize)
    }

    private func formatBytes(_ bytes: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useKB, .useMB, .useGB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: bytes)
    }
    
    // Helper function to resize image
    private func resizeImage(_ image: UIImage, scale: Double) -> UIImage {
        let newWidth = Int(Double(image.size.width) * scale)
        let newHeight = Int(Double(image.size.height) * scale)
        let newSize = CGSize(width: newWidth, height: newHeight)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: CGRect(origin: .zero, size: newSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage ?? image
    }
}

// MARK: - Preview
struct MediaCompressionView_Previews: PreviewProvider {
    static var previews: some View {
        MediaCompressionView()
            .environmentObject(LanguageManager())
    }
}
