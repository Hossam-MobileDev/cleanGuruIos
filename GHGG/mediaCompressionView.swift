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
//    var compressionRatio: CGFloat {
//        switch self {
//        case .low: return 0.8
//        case .medium: return 0.5
//        case .high: return 0.2
//        }
//    }
//}
//
//struct ImagePickerWithAsset: UIViewControllerRepresentable {
//    @Binding var selectedImage: UIImage?
//    @Binding var selectedAsset: PHAsset?
//    @Environment(\.presentationMode) private var presentationMode
//
//    func makeUIViewController(context: Context) -> PHPickerViewController {
//        var configuration = PHPickerConfiguration()
//        configuration.filter = .images
//        configuration.selectionLimit = 1
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
//            if let assetIdentifier = result.assetIdentifier {
//                let fetchOptions = PHFetchOptions()
//                let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [assetIdentifier], options: fetchOptions)
//                parent.selectedAsset = fetchResult.firstObject
//            }
//
//            result.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
//                if let image = image as? UIImage {
//                    DispatchQueue.main.async {
//                        self.parent.selectedImage = image
//                    }
//                }
//            }
//        }
//    }
//}
//
//struct MediaCompressionView: View {
//    @State private var selectedQuality: CompressionQuality = .medium
//    @State private var sliderValue: CGFloat = 0.5
//    @State private var showingImagePicker = false
//    @State private var selectedImage: UIImage?
//    @State private var selectedAsset: PHAsset?
//    @State private var showingPermissionAlert = false
//    @State private var isCompressing = false
//    @State private var showSuccessAlert = false
//    @State private var showErrorAlert = false
//    @State private var compressionResult = CompressionResult()
//    @EnvironmentObject var languageManager: LanguageManager
//
//    struct CompressionResult {
//        var originalSize: String = ""
//        var compressedSize: String = ""
//        var savedSpace: String = ""
//        var errorMessage: String = ""
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
//                    }
//                }
//
//                if selectedImage != nil {
//                    compressButton
//                        .padding()
//                        .background(Color(UIColor.systemBackground))
//                }
//            }
//           // .navigationBarTitle("Media Compression", displayMode: .inline)
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
//            .alert("Image Replaced Successfully! ✅", isPresented: $showSuccessAlert) {
//                Button("OK") {
//                    selectedImage = nil
//                    selectedAsset = nil
//                }
//            } message: {
//                Text("Original: \(compressionResult.originalSize)\nCompressed: \(compressionResult.compressedSize)\nSaved: \(compressionResult.savedSpace)")
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
//                ImagePickerWithAsset(selectedImage: $selectedImage, selectedAsset: $selectedAsset)
//            }
//        }
//    }
//
////    private var qualitySection: some View {
////        VStack(alignment: .leading) {
////            Text("Quality")
////                .font(.headline)
////                .padding(.horizontal)
////
////            HStack {
////                ForEach(CompressionQuality.allCases, id: \.self) { quality in
////                    Button(action: {
////                        selectedQuality = quality
////                        sliderValue = quality.compressionRatio
////                    }) {
////                        VStack {
////                            Text(quality.localizedTitle(language: languageManager.currentLanguage))
////                            Text(quality.compressionPercentage(language: languageManager.currentLanguage))
////                                .font(.caption)
////                                .foregroundColor(.gray)
////                        }
////                        .padding()
////                        .background(
////                            RoundedRectangle(cornerRadius: 10)
////                                .fill(selectedQuality == quality ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1))
////                        )
////                    }
////                    .buttonStyle(.plain)
////                }
////            }
////            .padding(.horizontal)
////        }
////    }
//
//    private var qualitySection: some View {
//            VStack(alignment: .leading) {
//                Text("Quality")
//                    .font(.headline)
//                    .padding(.horizontal)
//
//                HStack(spacing: 8) {
//                    ForEach(CompressionQuality.allCases, id: \.self) { quality in
//                        Button(action: {
//                            selectedQuality = quality
//                            sliderValue = quality.compressionRatio
//                        }) {
//                            VStack {
//                                Text(quality.localizedTitle(language: languageManager.currentLanguage))
//                                    .font(.system(size: 16, weight: .medium))
//                                Text(quality.compressionPercentage(language: languageManager.currentLanguage))
//                                    .font(.caption)
//                                    .foregroundColor(.gray)
//                            }
//                            .frame(maxWidth: .infinity) // This makes all buttons equal width
//                            .padding(.vertical, 12)
//                            .padding(.horizontal, 8)
//                            .background(
//                                RoundedRectangle(cornerRadius: 10)
//                                    .fill(selectedQuality == quality ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1))
//                            )
//                        }
//                        .buttonStyle(.plain)
//                    }
//                }
//                .padding(.horizontal)
//            }
//        }
//
//    private var imageComparisonView: some View {
//        ZStack {
//            if let image = selectedImage {
//                Image(uiImage: image)
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(height: 300)
//            } else {
//                RoundedRectangle(cornerRadius: 12)
//                    .fill(Color.gray.opacity(0.1))
//                    .frame(height: 300)
//                    .overlay(
//                        VStack {
//                            Image(systemName: "photo")
//                                .font(.system(size: 50))
//                            Text("Select an image to preview")
//                                .foregroundColor(.gray)
//                        }
//                    )
//            }
//
//            if selectedImage != nil {
//                GeometryReader { geometry in
//                    ZStack {
//                        Rectangle()
//                            .fill(Color.white)
//                            .frame(width: 2)
//                            .position(x: sliderValue * geometry.size.width, y: geometry.size.height / 2)
//
//                        Circle()
//                            .fill(Color.white)
//                            .frame(width: 30, height: 30)
//                            .overlay(
//                                Image(systemName: "arrow.left.and.right")
//                                    .foregroundColor(.black)
//                            )
//                            .position(x: sliderValue * geometry.size.width, y: geometry.size.height / 2)
//                            .gesture(
//                                DragGesture()
//                                    .onChanged { value in
//                                        let newValue = value.location.x / geometry.size.width
//                                        sliderValue = min(max(newValue, 0), 1)
//                                    }
//                            )
//                    }
//                }
//            }
//        }
//        .onTapGesture {
//            showingImagePicker = true
//        }
//        .padding()
//    }
//
//    private var sizeComparisonView: some View {
//        HStack {
//            VStack {
//                Text("Original")
//                if let image = selectedImage, let data = image.jpegData(compressionQuality: 1.0) {
//                    Text(formatBytes(Int64(data.count)))
//                        .foregroundColor(.orange)
//                } else {
//                    Text("--")
//                        .foregroundColor(.orange)
//                }
//            }
//            Spacer()
//            Image(systemName: "arrow.right")
//            Spacer()
//            VStack {
//                Text("Compressed")
//                if let image = selectedImage {
//                    Text(getCompressedSizeText(for: image))
//                        .foregroundColor(.green)
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
//                } else {
//                    Image(systemName: "arrow.down.to.line")
//                    Text("Compress & Replace")
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
//            VStack {
//                ProgressView()
//                    .scaleEffect(1.5)
//                Text("Compressing...")
//                    .foregroundColor(.white)
//            }
//            .padding()
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
//
//    
//    private func compressAndReplace() {
//        guard let image = selectedImage else { return }
//
//        isCompressing = true
//
//        let originalData = image.jpegData(compressionQuality: 1.0) ?? Data()
//        let originalSize = Int64(originalData.count)
//
//        DispatchQueue.global(qos: .userInitiated).async {
//            guard let compressedData = image.jpegData(compressionQuality: selectedQuality.compressionRatio),
//                  let compressedImage = UIImage(data: compressedData) else {
//                DispatchQueue.main.async {
//                    self.compressionResult.errorMessage = "Failed to compress image."
//                    self.showErrorAlert = true
//                    self.isCompressing = false
//                }
//                return
//            }
//
//            let compressedSize = Int64(compressedData.count)
//            let savedSpace = originalSize - compressedSize
//
//            PHPhotoLibrary.shared().performChanges({
//                // Save compressed image
//                PHAssetChangeRequest.creationRequestForAsset(from: compressedImage)
//            }) { success, error in
//                if success {
//                    // Delete the original image if asset is available
//                    if let originalAsset = self.selectedAsset {
//                        PHPhotoLibrary.shared().performChanges({
//                            PHAssetChangeRequest.deleteAssets([originalAsset] as NSArray)
//                        }) { deleteSuccess, deleteError in
//                            DispatchQueue.main.async {
//                                self.isCompressing = false
//                                if deleteSuccess {
//                                    self.compressionResult = CompressionResult(
//                                        originalSize: self.formatBytes(originalSize),
//                                        compressedSize: self.formatBytes(compressedSize),
//                                        savedSpace: self.formatBytes(savedSpace)
//                                    )
//                                    self.showSuccessAlert = true
//                                } else {
//                                    self.compressionResult.errorMessage = deleteError?.localizedDescription ?? "Failed to delete original image."
//                                    self.showErrorAlert = true
//                                }
//                            }
//                        }
//                    } else {
//                        DispatchQueue.main.async {
//                            self.isCompressing = false
//                            self.compressionResult = CompressionResult(
//                                originalSize: self.formatBytes(originalSize),
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
//    func deleteAsset(with localIdentifier: String) {
//        let assets = PHAsset.fetchAssets(withLocalIdentifiers: [localIdentifier], options: nil)
//        PHPhotoLibrary.shared().performChanges({
//            PHAssetChangeRequest.deleteAssets(assets)
//        }, completionHandler: { success, error in
//            if success {
//                print("🗑️ Original image deleted.")
//            } else if let error = error {
//                print("❌ Error deleting original image: \(error)")
//            }
//        })
//    }
//    private func getCompressedSizeText(for image: UIImage) -> String {
//        if let data = image.jpegData(compressionQuality: selectedQuality.compressionRatio) {
//            return formatBytes(Int64(data.count))
//        }
//        return "--"
//    }
//
//    private func formatBytes(_ bytes: Int64) -> String {
//        let formatter = ByteCountFormatter()
//        formatter.allowedUnits = [.useKB, .useMB, .useGB]
//        formatter.countStyle = .file
//        return formatter.string(fromByteCount: bytes)
//    }
//}

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
//    var compressionRatio: CGFloat {
//        switch self {
//        case .low: return 0.8
//        case .medium: return 0.5
//        case .high: return 0.2
//        }
//    }
//}
//
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
//            // Reset file size and set loading state
//            DispatchQueue.main.async {
//                self.parent.originalFileSize = 0
//                self.parent.selectedImage = nil
//                self.parent.selectedAsset = nil
//            }
//
//            // Load the image for display first (this is usually faster)
//            result.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
//                if let image = image as? UIImage {
//                    DispatchQueue.main.async {
//                        print("🖼️ Image loaded successfully")
//                        self.parent.selectedImage = image
//                    }
//                } else {
//                    print("❌ Failed to load image: \(error?.localizedDescription ?? "Unknown error")")
//                }
//            }
//
//            // Get the PHAsset and file size
//            if let assetIdentifier = result.assetIdentifier {
//                let fetchOptions = PHFetchOptions()
//                let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [assetIdentifier], options: fetchOptions)
//                if let asset = fetchResult.firstObject {
//                    DispatchQueue.main.async {
//                        self.parent.selectedAsset = asset
//                    }
//                    
//                    // Get the actual file size from the asset with timeout protection
//                    print("🔍 Getting file size for asset: \(asset.localIdentifier)")
//                    
//                    // Create a flag to prevent multiple callbacks
//                    var hasCompleted = false
//                    
//                    self.getActualFileSize(for: asset) { fileSize in
//                        guard !hasCompleted else { return }
//                        hasCompleted = true
//                        
//                        DispatchQueue.main.async {
//                            print("📏 File size received: \(fileSize) bytes")
//                            self.parent.originalFileSize = fileSize
//                        }
//                    }
//                    
//                    // Backup timeout in case the method above fails
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
//                        if !hasCompleted && self.parent.originalFileSize == 0 {
//                            hasCompleted = true
//                            let estimatedSize = Int64(asset.pixelWidth * asset.pixelHeight * 4)
//                            print("⏰ Backup timeout: using estimated size \(estimatedSize) bytes")
//                            self.parent.originalFileSize = estimatedSize
//                        }
//                    }
//                }
//            }
//        }
//        
//        private func getActualFileSize(for asset: PHAsset, completion: @escaping (Int64) -> Void) {
//            // Method 1: Try to get file size from PHAssetResource first
//            let resources = PHAssetResource.assetResources(for: asset)
//            
//            // Look for the main photo resource
//            if let photoResource = resources.first(where: { $0.type == .photo }) {
//                // Try to get file size using private API (works in most cases)
//                let resourceSize = photoResource.value(forKey: "fileSize") as? NSNumber
//                if let size = resourceSize?.int64Value, size > 0 {
//                    print("✅ Got file size from photo resource: \(size) bytes")
//                    completion(size)
//                    return
//                }
//            }
//            
//            // Method 2: Request image data directly (most reliable)
//            print("⚠️ Using image data request for file size")
//            let manager = PHImageManager.default()
//            let options = PHImageRequestOptions()
//            options.isSynchronous = false
//            options.isNetworkAccessAllowed = true
//            options.deliveryMode = .highQualityFormat
//            options.resizeMode = .none
//            
//            // Set a timeout to prevent endless loading
//            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
//                // If we haven't got a result in 10 seconds, provide an estimate
//                let estimatedSize = Int64(asset.pixelWidth * asset.pixelHeight * 4) // RGBA estimate
//                print("⏰ Timeout reached, using estimated size: \(estimatedSize) bytes")
//                completion(estimatedSize)
//            }
//            
//            manager.requestImageDataAndOrientation(for: asset, options: options) { data, dataUTI, orientation, info in
//                if let data = data {
//                    let size = Int64(data.count)
//                    print("✅ Got file size from image data: \(size) bytes")
//                    completion(size)
//                } else {
//                    // Fallback: estimate based on asset dimensions
//                    let estimatedSize = Int64(asset.pixelWidth * asset.pixelHeight * 4) // RGBA estimate
//                    print("⚠️ Using estimated size: \(estimatedSize) bytes")
//                    completion(estimatedSize)
//                }
//            }
//        }
//    }
//}
//
//struct MediaCompressionView: View {
//    @State private var selectedQuality: CompressionQuality = .medium
//    @State private var sliderValue: CGFloat = 0.5
//    @State private var showingImagePicker = false
//    @State private var selectedImage: UIImage?
//    @State private var selectedAsset: PHAsset?
//    @State private var originalFileSize: Int64 = 0
//    @State private var showingPermissionAlert = false
//    @State private var isCompressing = false
//    @State private var showSuccessAlert = false
//    @State private var showErrorAlert = false
//    @State private var compressionResult = CompressionResult()
//    @EnvironmentObject var languageManager: LanguageManager
//
//    struct CompressionResult {
//        var originalSize: String = ""
//        var compressedSize: String = ""
//        var savedSpace: String = ""
//        var errorMessage: String = ""
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
//                    }
//                }
//
//                if selectedImage != nil {
//                    compressButton
//                        .padding()
//                        .background(Color(UIColor.systemBackground))
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
//            .alert("Image Replaced Successfully! ✅", isPresented: $showSuccessAlert) {
//                Button("OK") {
//                    selectedImage = nil
//                    selectedAsset = nil
//                    originalFileSize = 0
//                }
//            } message: {
//                Text("Original: \(compressionResult.originalSize)\nCompressed: \(compressionResult.compressedSize)\nSaved: \(compressionResult.savedSpace)")
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
//            }
//        }
//    }
//
//    private var qualitySection: some View {
//        VStack(alignment: .leading) {
//            Text("Quality")
//                .font(.headline)
//                .padding(.horizontal)
//
//            HStack(spacing: 8) {
//                ForEach(CompressionQuality.allCases, id: \.self) { quality in
//                    Button(action: {
//                        selectedQuality = quality
//                        sliderValue = quality.compressionRatio
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
//        ZStack {
//            if let image = selectedImage {
//                Image(uiImage: image)
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(height: 300)
//            } else {
//                RoundedRectangle(cornerRadius: 12)
//                    .fill(Color.gray.opacity(0.1))
//                    .frame(height: 300)
//                    .overlay(
//                        VStack {
//                            Image(systemName: "photo")
//                                .font(.system(size: 50))
//                            Text("Select an image to preview")
//                                .foregroundColor(.gray)
//                        }
//                    )
//            }
//
//            if selectedImage != nil {
//                GeometryReader { geometry in
//                    ZStack {
//                        Rectangle()
//                            .fill(Color.white)
//                            .frame(width: 2)
//                            .position(x: sliderValue * geometry.size.width, y: geometry.size.height / 2)
//
//                        Circle()
//                            .fill(Color.white)
//                            .frame(width: 30, height: 30)
//                            .overlay(
//                                Image(systemName: "arrow.left.and.right")
//                                    .foregroundColor(.black)
//                            )
//                            .position(x: sliderValue * geometry.size.width, y: geometry.size.height / 2)
//                            .gesture(
//                                DragGesture()
//                                    .onChanged { value in
//                                        let newValue = value.location.x / geometry.size.width
//                                        sliderValue = min(max(newValue, 0), 1)
//                                    }
//                            )
//                    }
//                }
//            }
//        }
//        .onTapGesture {
//            showingImagePicker = true
//        }
//        .padding()
//    }
//
//    private var sizeComparisonView: some View {
//        HStack {
//            VStack {
//                Text("Original")
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
//            
//            Image(systemName: "arrow.right")
//                .foregroundColor(.gray)
//            
//            Spacer()
//            
//            VStack {
//                Text("Compressed")
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
//        .background(
//            RoundedRectangle(cornerRadius: 12)
//                .fill(Color.gray.opacity(0.05))
//        )
//        .onChange(of: originalFileSize) { newSize in
//            if newSize > 0 {
//                print("✅ Original file size updated: \(formatBytes(newSize))")
//            }
//        }
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
//                    Image(systemName: "arrow.down.to.line")
//                    Text("Compress & Replace")
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
//            VStack {
//                ProgressView()
//                    .scaleEffect(1.5)
//                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
//                Text("Compressing...")
//                    .foregroundColor(.white)
//            }
//            .padding()
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
//        isCompressing = true
//
//        let originalSize = originalFileSize
//
//        DispatchQueue.global(qos: .userInitiated).async {
//            guard let compressedData = image.jpegData(compressionQuality: selectedQuality.compressionRatio),
//                  let compressedImage = UIImage(data: compressedData) else {
//                DispatchQueue.main.async {
//                    self.compressionResult.errorMessage = "Failed to compress image."
//                    self.showErrorAlert = true
//                    self.isCompressing = false
//                }
//                return
//            }
//
//            let compressedSize = Int64(compressedData.count)
//            let savedSpace = originalSize - compressedSize
//
//            PHPhotoLibrary.shared().performChanges({
//                PHAssetChangeRequest.creationRequestForAsset(from: compressedImage)
//            }) { success, error in
//                if success {
//                    if let originalAsset = self.selectedAsset {
//                        PHPhotoLibrary.shared().performChanges({
//                            PHAssetChangeRequest.deleteAssets([originalAsset] as NSArray)
//                        }) { deleteSuccess, deleteError in
//                            DispatchQueue.main.async {
//                                self.isCompressing = false
//                                if deleteSuccess {
//                                    self.compressionResult = CompressionResult(
//                                        originalSize: self.formatBytes(originalSize),
//                                        compressedSize: self.formatBytes(compressedSize),
//                                        savedSpace: self.formatBytes(savedSpace)
//                                    )
//                                    self.showSuccessAlert = true
//                                } else {
//                                    self.compressionResult.errorMessage = deleteError?.localizedDescription ?? "Failed to delete original image."
//                                    self.showErrorAlert = true
//                                }
//                            }
//                        }
//                    } else {
//                        DispatchQueue.main.async {
//                            self.isCompressing = false
//                            self.compressionResult = CompressionResult(
//                                originalSize: self.formatBytes(originalSize),
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
//    func deleteAsset(with localIdentifier: String) {
//        let assets = PHAsset.fetchAssets(withLocalIdentifiers: [localIdentifier], options: nil)
//        PHPhotoLibrary.shared().performChanges({
//            PHAssetChangeRequest.deleteAssets(assets)
//        }, completionHandler: { success, error in
//            if success {
//                print("🗑️ Original image deleted.")
//            } else if let error = error {
//                print("❌ Error deleting original image: \(error)")
//            }
//        })
//    }
//
//    private func getCompressedSizeText(for image: UIImage) -> String {
//        if let data = image.jpegData(compressionQuality: selectedQuality.compressionRatio) {
//            return formatBytes(Int64(data.count))
//        }
//        return "--"
//    }
//
//    private func formatBytes(_ bytes: Int64) -> String {
//        let formatter = ByteCountFormatter()
//        formatter.allowedUnits = [.useKB, .useMB, .useGB]
//        formatter.countStyle = .file
//        return formatter.string(fromByteCount: bytes)
//    }
//}
// MARK: - Compression Quality Enum
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
//    var compressionRatio: CGFloat {
//        switch self {
//        case .low: return 0.8
//        case .medium: return 0.5
//        case .high: return 0.2
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
//                                    print("📁 File size from URL: \(fileSize) bytes")
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
//                                    print("📁 File size from PHAsset: \(size) bytes")
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
//                    print("📁 Estimated file size from JPEG data: \(imageData.count) bytes")
//                }
//            } else {
//                // Last resort: calculate based on dimensions
//                let estimatedSize = self.calculateSmartFileSize(for: image)
//                DispatchQueue.main.async {
//                    self.parent.originalFileSize = estimatedSize
//                    print("📁 Calculated file size: \(estimatedSize) bytes")
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
//    @State private var sliderValue: CGFloat = 0.5
//    @State private var showingImagePicker = false
//    @State private var selectedImage: UIImage?
//    @State private var selectedAsset: PHAsset?
//    @State private var originalFileSize: Int64 = 0
//    @State private var showingPermissionAlert = false
//    @State private var isCompressing = false
//    @State private var showSuccessAlert = false
//    @State private var showErrorAlert = false
//    @State private var compressionResult = CompressionResult()
//    @EnvironmentObject var languageManager: LanguageManager
//
//    struct CompressionResult {
//        var originalSize: String = ""
//        var compressedSize: String = ""
//        var savedSpace: String = ""
//        var errorMessage: String = ""
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
//                    }
//                }
//
//                if selectedImage != nil {
//                    compressButton
//                        .padding()
//                        .background(Color(UIColor.systemBackground))
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
//            .alert("Image Replaced Successfully! ✅", isPresented: $showSuccessAlert) {
//                Button("OK") {
//                    selectedImage = nil
//                    selectedAsset = nil
//                    originalFileSize = 0
//                }
//            } message: {
//                Text("Original: \(compressionResult.originalSize)\nCompressed: \(compressionResult.compressedSize)\nSaved: \(compressionResult.savedSpace)")
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
//            }
//        }
//    }
//
//    private var qualitySection: some View {
//        VStack(alignment: .leading) {
//            Text("Quality")
//                .font(.headline)
//                .padding(.horizontal)
//
//            HStack(spacing: 8) {
//                ForEach(CompressionQuality.allCases, id: \.self) { quality in
//                    Button(action: {
//                        selectedQuality = quality
//                        sliderValue = quality.compressionRatio
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
//        ZStack {
//            if let image = selectedImage {
//                Image(uiImage: image)
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(height: 300)
//            } else {
//                RoundedRectangle(cornerRadius: 12)
//                    .fill(Color.gray.opacity(0.1))
//                    .frame(height: 300)
//                    .overlay(
//                        VStack {
//                            Image(systemName: "photo")
//                                .font(.system(size: 50))
//                            Text("Select an image to preview")
//                                .foregroundColor(.gray)
//                        }
//                    )
//            }
//
//            if selectedImage != nil {
//                GeometryReader { geometry in
//                    ZStack {
//                        Rectangle()
//                            .fill(Color.white)
//                            .frame(width: 2)
//                            .position(x: sliderValue * geometry.size.width, y: geometry.size.height / 2)
//
//                        Circle()
//                            .fill(Color.white)
//                            .frame(width: 30, height: 30)
//                            .overlay(
//                                Image(systemName: "arrow.left.and.right")
//                                    .foregroundColor(.black)
//                            )
//                            .position(x: sliderValue * geometry.size.width, y: geometry.size.height / 2)
//                            .gesture(
//                                DragGesture()
//                                    .onChanged { value in
//                                        let newValue = value.location.x / geometry.size.width
//                                        sliderValue = min(max(newValue, 0), 1)
//                                    }
//                            )
//                    }
//                }
//            }
//        }
//        .onTapGesture {
//            showingImagePicker = true
//        }
//        .padding()
//    }
//
//    private var sizeComparisonView: some View {
//        HStack {
//            VStack {
//                Text("Original")
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
//                Text("Compressed")
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
//                    Image(systemName: "arrow.down.to.line")
//                    Text("Compress & Replace")
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
//            VStack {
//                ProgressView()
//                    .scaleEffect(1.5)
//                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
//                Text("Compressing...")
//                    .foregroundColor(.white)
//            }
//            .padding()
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
//        isCompressing = true
//
//        // Use the ACTUAL file size, not calculated JPEG size
//        let originalSize = originalFileSize
//
//        DispatchQueue.global(qos: .userInitiated).async {
//            guard let compressedData = image.jpegData(compressionQuality: selectedQuality.compressionRatio),
//                  let compressedImage = UIImage(data: compressedData) else {
//                DispatchQueue.main.async {
//                    self.compressionResult.errorMessage = "Failed to compress image."
//                    self.showErrorAlert = true
//                    self.isCompressing = false
//                }
//                return
//            }
//
//            let compressedSize = Int64(compressedData.count)
//            let savedSpace = originalSize - compressedSize
//
//            PHPhotoLibrary.shared().performChanges({
//                PHAssetChangeRequest.creationRequestForAsset(from: compressedImage)
//            }) { success, error in
//                if success {
//                    if let originalAsset = self.selectedAsset {
//                        PHPhotoLibrary.shared().performChanges({
//                            PHAssetChangeRequest.deleteAssets([originalAsset] as NSArray)
//                        }) { deleteSuccess, deleteError in
//                            DispatchQueue.main.async {
//                                self.isCompressing = false
//                                if deleteSuccess {
//                                    self.compressionResult = CompressionResult(
//                                        originalSize: self.formatBytes(originalSize),
//                                        compressedSize: self.formatBytes(compressedSize),
//                                        savedSpace: self.formatBytes(savedSpace)
//                                    )
//                                    self.showSuccessAlert = true
//                                } else {
//                                    self.compressionResult.errorMessage = deleteError?.localizedDescription ?? "Failed to delete original image."
//                                    self.showErrorAlert = true
//                                }
//                            }
//                        }
//                    } else {
//                        DispatchQueue.main.async {
//                            self.isCompressing = false
//                            self.compressionResult = CompressionResult(
//                                originalSize: self.formatBytes(originalSize),
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
//        if let data = image.jpegData(compressionQuality: selectedQuality.compressionRatio) {
//            return formatBytes(Int64(data.count))
//        }
//        return "--"
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
//    var compressionRatio: CGFloat {
//        switch self {
//        case .low: return 0.2    // 20% quality = 80% compression
//        case .medium: return 0.5  // 50% quality = 50% compression
//        case .high: return 0.8    // 80% quality = 20% compression
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
//                                    print("📁 File size from URL: \(fileSize) bytes")
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
//                                    print("📁 File size from PHAsset: \(size) bytes")
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
//                    print("📁 Estimated file size from JPEG data: \(imageData.count) bytes")
//                }
//            } else {
//                // Last resort: calculate based on dimensions
//                let estimatedSize = self.calculateSmartFileSize(for: image)
//                DispatchQueue.main.async {
//                    self.parent.originalFileSize = estimatedSize
//                    print("📁 Calculated file size: \(estimatedSize) bytes")
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
//    @State private var sliderValue: CGFloat = 0.5
//    @State private var showingImagePicker = false
//    @State private var selectedImage: UIImage?
//    @State private var selectedAsset: PHAsset?
//    @State private var originalFileSize: Int64 = 0
//    @State private var showingPermissionAlert = false
//    @State private var isCompressing = false
//    @State private var showSuccessAlert = false
//    @State private var showErrorAlert = false
//    @State private var compressionResult = CompressionResult()
//    @EnvironmentObject var languageManager: LanguageManager
//
//    struct CompressionResult {
//        var originalSize: String = ""
//        var compressedSize: String = ""
//        var savedSpace: String = ""
//        var errorMessage: String = ""
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
//                    }
//                }
//
//                if selectedImage != nil {
//                    compressButton
//                        .padding()
//                        .background(Color(UIColor.systemBackground))
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
//            .alert("Image Replaced Successfully! ✅", isPresented: $showSuccessAlert) {
//                Button("OK") {
//                    selectedImage = nil
//                    selectedAsset = nil
//                    originalFileSize = 0
//                }
//            } message: {
//                Text("Original: \(compressionResult.originalSize)\nCompressed: \(compressionResult.compressedSize)\nSaved: \(compressionResult.savedSpace)")
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
//            }
//        }
//    }
//
//    private var qualitySection: some View {
//        VStack(alignment: .leading) {
//            Text("Quality")
//                .font(.headline)
//                .padding(.horizontal)
//
//            HStack(spacing: 8) {
//                ForEach(CompressionQuality.allCases, id: \.self) { quality in
//                    Button(action: {
//                        selectedQuality = quality
//                        sliderValue = quality.compressionRatio
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
//        ZStack {
//            if let image = selectedImage {
//                Image(uiImage: image)
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(height: 300)
//            } else {
//                RoundedRectangle(cornerRadius: 12)
//                    .fill(Color.gray.opacity(0.1))
//                    .frame(height: 300)
//                    .overlay(
//                        VStack {
//                            Image(systemName: "photo")
//                                .font(.system(size: 50))
//                            Text("Select an image to preview")
//                                .foregroundColor(.gray)
//                        }
//                    )
//            }
//
//            if selectedImage != nil {
//                GeometryReader { geometry in
//                    ZStack {
//                        Rectangle()
//                            .fill(Color.white)
//                            .frame(width: 2)
//                            .position(x: sliderValue * geometry.size.width, y: geometry.size.height / 2)
//
//                        Circle()
//                            .fill(Color.white)
//                            .frame(width: 30, height: 30)
//                            .overlay(
//                                Image(systemName: "arrow.left.and.right")
//                                    .foregroundColor(.black)
//                            )
//                            .position(x: sliderValue * geometry.size.width, y: geometry.size.height / 2)
//                            .gesture(
//                                DragGesture()
//                                    .onChanged { value in
//                                        let newValue = value.location.x / geometry.size.width
//                                        sliderValue = min(max(newValue, 0), 1)
//                                    }
//                            )
//                    }
//                }
//            }
//        }
//        .onTapGesture {
//            showingImagePicker = true
//        }
//        .padding()
//    }
//
//    private var sizeComparisonView: some View {
//        HStack {
//            VStack {
//                Text("Original")
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
//                Text("Compressed")
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
//                    Image(systemName: "arrow.down.to.line")
//                    Text("Compress & Replace")
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
//            VStack {
//                ProgressView()
//                    .scaleEffect(1.5)
//                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
//                Text("Compressing...")
//                    .foregroundColor(.white)
//            }
//            .padding()
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
//        isCompressing = true
//        let originalSize = originalFileSize
//
//        DispatchQueue.global(qos: .userInitiated).async {
//            // Calculate target size based on compression percentage
//            let targetSize: Int64
//            switch self.selectedQuality {
//            case .low:
//                targetSize = Int64(Double(originalSize) * 0.2)  // 20% of original
//            case .medium:
//                targetSize = Int64(Double(originalSize) * 0.5)  // 50% of original
//            case .high:
//                targetSize = Int64(Double(originalSize) * 0.8)  // 80% of original
//            }
//            
//            // Try different compression qualities to achieve target size
//            var compressionQuality: CGFloat = self.selectedQuality.compressionRatio
//            var compressedData: Data?
//            var attempts = 0
//            let maxAttempts = 10
//            
//            repeat {
//                compressedData = image.jpegData(compressionQuality: compressionQuality)
//                
//                if let data = compressedData {
//                    let currentSize = Int64(data.count)
//                    
//                    // If we're close enough to target (within 10%), accept it
//                    if abs(currentSize - targetSize) <= targetSize / 10 {
//                        break
//                    }
//                    
//                    // Adjust compression quality based on how far we are from target
//                    let ratio = Double(targetSize) / Double(currentSize)
//                    
//                    if currentSize > targetSize {
//                        // Need more compression
//                        compressionQuality *= CGFloat(ratio * 0.9) // Slightly aggressive adjustment
//                    } else {
//                        // Need less compression
//                        compressionQuality *= CGFloat(ratio * 1.1) // Slightly conservative adjustment
//                    }
//                    
//                    // Keep quality within valid range
//                    compressionQuality = max(0.01, min(1.0, compressionQuality))
//                }
//                
//                attempts += 1
//            } while attempts < maxAttempts && compressedData != nil
//            
//            guard let finalCompressedData = compressedData,
//                  let compressedImage = UIImage(data: finalCompressedData) else {
//                DispatchQueue.main.async {
//                    self.compressionResult.errorMessage = "Failed to compress image."
//                    self.showErrorAlert = true
//                    self.isCompressing = false
//                }
//                return
//            }
//
//            let compressedSize = Int64(finalCompressedData.count)
//            let savedSpace = originalSize - compressedSize
//
//            PHPhotoLibrary.shared().performChanges({
//                PHAssetChangeRequest.creationRequestForAsset(from: compressedImage)
//            }) { success, error in
//                if success {
//                    if let originalAsset = self.selectedAsset {
//                        PHPhotoLibrary.shared().performChanges({
//                            PHAssetChangeRequest.deleteAssets([originalAsset] as NSArray)
//                        }) { deleteSuccess, deleteError in
//                            DispatchQueue.main.async {
//                                self.isCompressing = false
//                                if deleteSuccess {
//                                    self.compressionResult = CompressionResult(
//                                        originalSize: self.formatBytes(originalSize),
//                                        compressedSize: self.formatBytes(compressedSize),
//                                        savedSpace: self.formatBytes(savedSpace)
//                                    )
//                                    self.showSuccessAlert = true
//                                } else {
//                                    self.compressionResult.errorMessage = deleteError?.localizedDescription ?? "Failed to delete original image."
//                                    self.showErrorAlert = true
//                                }
//                            }
//                        }
//                    } else {
//                        DispatchQueue.main.async {
//                            self.isCompressing = false
//                            self.compressionResult = CompressionResult(
//                                originalSize: self.formatBytes(originalSize),
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
//        if let data = image.jpegData(compressionQuality: selectedQuality.compressionRatio) {
//            return formatBytes(Int64(data.count))
//        }
//        return "--"
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

// MARK: - Compression Quality Enum
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
//    var compressionRatio: CGFloat {
//        switch self {
//        case .low: return 0.2    // 20% quality = 80% compression
//        case .medium: return 0.5  // 50% quality = 50% compression
//        case .high: return 0.8    // 80% quality = 20% compression
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
//                                    print("📁 File size from URL: \(fileSize) bytes")
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
//                                    print("📁 File size from PHAsset: \(size) bytes")
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
//                    print("📁 Estimated file size from JPEG data: \(imageData.count) bytes")
//                }
//            } else {
//                // Last resort: calculate based on dimensions
//                let estimatedSize = self.calculateSmartFileSize(for: image)
//                DispatchQueue.main.async {
//                    self.parent.originalFileSize = estimatedSize
//                    print("📁 Calculated file size: \(estimatedSize) bytes")
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
//    @State private var sliderValue: CGFloat = 0.5
//    @State private var showingImagePicker = false
//    @State private var selectedImage: UIImage?
//    @State private var selectedAsset: PHAsset?
//    @State private var originalFileSize: Int64 = 0
//    @State private var showingPermissionAlert = false
//    @State private var isCompressing = false
//    @State private var showSuccessAlert = false
//    @State private var showErrorAlert = false
//    @State private var compressionResult = CompressionResult()
//    @EnvironmentObject var languageManager: LanguageManager
//
//    struct CompressionResult {
//        var originalSize: String = ""
//        var compressedSize: String = ""
//        var savedSpace: String = ""
//        var errorMessage: String = ""
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
//                    }
//                }
//
//                if selectedImage != nil {
//                    compressButton
//                        .padding()
//                        .background(Color(UIColor.systemBackground))
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
//            .alert("Image Replaced Successfully! ✅", isPresented: $showSuccessAlert) {
//                Button("OK") {
//                    selectedImage = nil
//                    selectedAsset = nil
//                    originalFileSize = 0
//                }
//            } message: {
//                Text("Original: \(compressionResult.originalSize)\nCompressed: \(compressionResult.compressedSize)\nSaved: \(compressionResult.savedSpace)")
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
//            }
//        }
//    }
//
//    private var qualitySection: some View {
//        VStack(alignment: .leading) {
//            Text("Quality")
//                .font(.headline)
//                .padding(.horizontal)
//
//            HStack(spacing: 8) {
//                ForEach(CompressionQuality.allCases, id: \.self) { quality in
//                    Button(action: {
//                        selectedQuality = quality
//                        sliderValue = quality.compressionRatio
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
//        ZStack {
//            if let image = selectedImage {
//                Image(uiImage: image)
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(height: 300)
//            } else {
//                RoundedRectangle(cornerRadius: 12)
//                    .fill(Color.gray.opacity(0.1))
//                    .frame(height: 300)
//                    .overlay(
//                        VStack {
//                            Image(systemName: "photo")
//                                .font(.system(size: 50))
//                            Text("Select an image to preview")
//                                .foregroundColor(.gray)
//                        }
//                    )
//            }
//
//            if selectedImage != nil {
//                GeometryReader { geometry in
//                    ZStack {
//                        Rectangle()
//                            .fill(Color.white)
//                            .frame(width: 2)
//                            .position(x: sliderValue * geometry.size.width, y: geometry.size.height / 2)
//
//                        Circle()
//                            .fill(Color.white)
//                            .frame(width: 30, height: 30)
//                            .overlay(
//                                Image(systemName: "arrow.left.and.right")
//                                    .foregroundColor(.black)
//                            )
//                            .position(x: sliderValue * geometry.size.width, y: geometry.size.height / 2)
//                            .gesture(
//                                DragGesture()
//                                    .onChanged { value in
//                                        let newValue = value.location.x / geometry.size.width
//                                        sliderValue = min(max(newValue, 0), 1)
//                                    }
//                            )
//                    }
//                }
//            }
//        }
//        .onTapGesture {
//            showingImagePicker = true
//        }
//        .padding()
//    }
//
//    private var sizeComparisonView: some View {
//        HStack {
//            VStack {
//                Text("Original")
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
//                Text("Compressed")
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
//                    Image(systemName: "arrow.down.to.line")
//                    Text("Compress & Replace")
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
//            VStack {
//                ProgressView()
//                    .scaleEffect(1.5)
//                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
//                Text("Compressing...")
//                    .foregroundColor(.white)
//            }
//            .padding()
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
//        isCompressing = true
//        let originalSize = originalFileSize
//
//        DispatchQueue.global(qos: .userInitiated).async {
//            // Calculate target size based on compression percentage
//            let targetSize: Int64
//            switch self.selectedQuality {
//            case .low:
//                targetSize = Int64(Double(originalSize) * 0.2)  // 20% of original
//            case .medium:
//                targetSize = Int64(Double(originalSize) * 0.5)  // 50% of original
//            case .high:
//                targetSize = Int64(Double(originalSize) * 0.8)  // 80% of original
//            }
//            
//            // Try different compression qualities to achieve target size
//            var compressionQuality: CGFloat = self.selectedQuality.compressionRatio
//            var compressedData: Data?
//            var attempts = 0
//            let maxAttempts = 10
//            
//            repeat {
//                compressedData = image.jpegData(compressionQuality: compressionQuality)
//                
//                if let data = compressedData {
//                    let currentSize = Int64(data.count)
//                    
//                    // If we're close enough to target (within 10%), accept it
//                    if abs(currentSize - targetSize) <= targetSize / 10 {
//                        break
//                    }
//                    
//                    // Adjust compression quality based on how far we are from target
//                    let ratio = Double(targetSize) / Double(currentSize)
//                    
//                    if currentSize > targetSize {
//                        // Need more compression
//                        compressionQuality *= CGFloat(ratio * 0.9) // Slightly aggressive adjustment
//                    } else {
//                        // Need less compression
//                        compressionQuality *= CGFloat(ratio * 1.1) // Slightly conservative adjustment
//                    }
//                    
//                    // Keep quality within valid range
//                    compressionQuality = max(0.01, min(1.0, compressionQuality))
//                }
//                
//                attempts += 1
//            } while attempts < maxAttempts && compressedData != nil
//            
//            guard let finalCompressedData = compressedData,
//                  let compressedImage = UIImage(data: finalCompressedData) else {
//                DispatchQueue.main.async {
//                    self.compressionResult.errorMessage = "Failed to compress image."
//                    self.showErrorAlert = true
//                    self.isCompressing = false
//                }
//                return
//            }
//
//            let compressedSize = Int64(finalCompressedData.count)
//            let savedSpace = originalSize - compressedSize
//
//            PHPhotoLibrary.shared().performChanges({
//                // Create asset from JPEG data, not UIImage
//                let creationRequest = PHAssetCreationRequest.forAsset()
//                creationRequest.addResource(with: .photo, data: finalCompressedData, options: nil)
//            }) { success, error in
//                if success {
//                    if let originalAsset = self.selectedAsset {
//                        PHPhotoLibrary.shared().performChanges({
//                            PHAssetChangeRequest.deleteAssets([originalAsset] as NSArray)
//                        }) { deleteSuccess, deleteError in
//                            DispatchQueue.main.async {
//                                self.isCompressing = false
//                                if deleteSuccess {
//                                    self.compressionResult = CompressionResult(
//                                        originalSize: self.formatBytes(originalSize),
//                                        compressedSize: self.formatBytes(compressedSize),
//                                        savedSpace: self.formatBytes(savedSpace)
//                                    )
//                                    self.showSuccessAlert = true
//                                } else {
//                                    self.compressionResult.errorMessage = deleteError?.localizedDescription ?? "Failed to delete original image."
//                                    self.showErrorAlert = true
//                                }
//                            }
//                        }
//                    } else {
//                        DispatchQueue.main.async {
//                            self.isCompressing = false
//                            self.compressionResult = CompressionResult(
//                                originalSize: self.formatBytes(originalSize),
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
//        if let data = image.jpegData(compressionQuality: selectedQuality.compressionRatio) {
//            return formatBytes(Int64(data.count))
//        }
//        return "--"
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

    var compressionRatio: CGFloat {
        switch self {
        case .low: return 0.2    // 20% quality = 80% compression
        case .medium: return 0.5  // 50% quality = 50% compression
        case .high: return 0.8    // 80% quality = 20% compression
        }
    }
}

// MARK: - Image Picker
struct ImagePickerWithAsset: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Binding var selectedAsset: PHAsset?
    @Binding var originalFileSize: Int64
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
            }
            
            // Try to get file size directly from the item provider
            if result.itemProvider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
                result.itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.image.identifier) { url, error in
                    if let url = url {
                        do {
                            let resourceValues = try url.resourceValues(forKeys: [.fileSizeKey])
                            if let fileSize = resourceValues.fileSize {
                                DispatchQueue.main.async {
                                    self.parent.originalFileSize = Int64(fileSize)
                                    print("📁 File size from URL: \(fileSize) bytes")
                                }
                            }
                        } catch {
                            print("Error getting file size: \(error)")
                        }
                    }
                }
            }
            
            // Load image for display
            result.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                if let image = image as? UIImage {
                    DispatchQueue.main.async {
                        self.parent.selectedImage = image
                        
                        // If we couldn't get file size from URL, try from PHAsset
                        if self.parent.originalFileSize == 0 {
                            self.tryGetFileSizeFromAsset(result: result)
                        }
                    }
                }
            }
        }
        
        private func tryGetFileSizeFromAsset(result: PHPickerResult) {
            // Try to get PHAsset for metadata
            if let assetIdentifier = result.assetIdentifier {
                let fetchOptions = PHFetchOptions()
                let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [assetIdentifier], options: fetchOptions)
                if let asset = fetchResult.firstObject {
                    DispatchQueue.main.async {
                        self.parent.selectedAsset = asset
                        
                        // Get actual file size
                        self.getActualFileSize(from: asset) { size in
                            DispatchQueue.main.async {
                                if size > 0 {
                                    self.parent.originalFileSize = size
                                    print("📁 File size from PHAsset: \(size) bytes")
                                } else {
                                    // Fallback: estimate from image
                                    self.estimateFileSizeFromImage()
                                }
                            }
                        }
                    }
                } else {
                    // No asset found, estimate from image
                    self.estimateFileSizeFromImage()
                }
            } else {
                // No asset identifier, estimate from image
                self.estimateFileSizeFromImage()
            }
        }
        
        private func estimateFileSizeFromImage() {
            guard let image = self.parent.selectedImage else { return }
            
            // Try to get original data representation
            if let imageData = image.jpegData(compressionQuality: 1.0) {
                DispatchQueue.main.async {
                    self.parent.originalFileSize = Int64(imageData.count)
                    print("📁 Estimated file size from JPEG data: \(imageData.count) bytes")
                }
            } else {
                // Last resort: calculate based on dimensions
                let estimatedSize = self.calculateSmartFileSize(for: image)
                DispatchQueue.main.async {
                    self.parent.originalFileSize = estimatedSize
                    print("📁 Calculated file size: \(estimatedSize) bytes")
                }
            }
        }
        
        private func getActualFileSize(from asset: PHAsset, completion: @escaping (Int64) -> Void) {
            let resources = PHAssetResource.assetResources(for: asset)
            
            guard let resource = resources.first else {
                completion(0)
                return
            }
            
            // Try multiple approaches to get file size
            
            // Approach 1: Direct property access
            if let fileSize = resource.value(forKey: "fileSize") as? CLong {
                completion(Int64(fileSize))
                return
            }
            
            // Approach 2: Use uniformTypeIdentifier to check if it's available
            let resourceManager = PHAssetResourceManager.default()
            let options = PHAssetResourceRequestOptions()
            options.isNetworkAccessAllowed = true
            
            // Approach 3: Stream the data to calculate size
            var totalSize: Int64 = 0
            resourceManager.requestData(for: resource, options: options, dataReceivedHandler: { data in
                totalSize += Int64(data.count)
            }, completionHandler: { error in
                if error == nil && totalSize > 0 {
                    completion(totalSize)
                } else {
                    // Approach 4: Request the full data at once
                    var imageData = Data()
                    resourceManager.requestData(for: resource, options: options, dataReceivedHandler: { data in
                        imageData.append(data)
                    }, completionHandler: { error in
                        completion(Int64(imageData.count))
                    })
                }
            })
        }
        
        private func calculateSmartFileSize(for image: UIImage) -> Int64 {
            let width = Int(image.size.width * image.scale)
            let height = Int(image.size.height * image.scale)
            let totalPixels = width * height
            
            // More accurate estimation based on typical iOS photo compression
            let bytesPerPixel: Double
            
            if totalPixels > 10_000_000 { // Very high resolution (10MP+)
                bytesPerPixel = 0.3 // HEIF/JPEG compression
            } else if totalPixels > 5_000_000 { // High resolution (5-10MP)
                bytesPerPixel = 0.35
            } else if totalPixels > 2_000_000 { // Medium resolution (2-5MP)
                bytesPerPixel = 0.4
            } else { // Lower resolution
                bytesPerPixel = 0.5
            }
            
            let estimatedSize = Int64(Double(totalPixels) * bytesPerPixel)
            
            print("📐 Image: \(width)×\(height) (\(totalPixels) pixels)")
            print("📏 Estimated size: \(estimatedSize) bytes (\(String(format: "%.1f", Double(estimatedSize)/1024/1024)) MB)")
            
            return estimatedSize
        }
    }
}

// MARK: - Main View
struct MediaCompressionView: View {
    @State private var selectedQuality: CompressionQuality = .medium
    @State private var sliderValue: CGFloat = 0.5
    @State private var showingImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var selectedAsset: PHAsset?
    @State private var originalFileSize: Int64 = 0
    @State private var showingPermissionAlert = false
    @State private var isCompressing = false
    @State private var showSuccessAlert = false
    @State private var showErrorAlert = false
    @State private var compressionResult = CompressionResult()
    @EnvironmentObject var languageManager: LanguageManager

    struct CompressionResult {
        var originalSize: String = ""
        var compressedSize: String = ""
        var savedSpace: String = ""
        var errorMessage: String = ""
    }

    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack(spacing: 16) {
                        qualitySection
                        imageComparisonView
                        sizeComparisonView
                    }
                }

                if selectedImage != nil {
                    compressButton
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
                Button("OK") {
                    selectedImage = nil
                    selectedAsset = nil
                    originalFileSize = 0
                }
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
                    originalFileSize: $originalFileSize
                )
            }
        }
    }

    private var qualitySection: some View {
        VStack(alignment: .leading) {
            Text(LocalizedStrings.string(for: "quality", language: languageManager.currentLanguage))
                .font(.headline)
                .padding(.horizontal)

            HStack(spacing: 8) {
                ForEach(CompressionQuality.allCases, id: \.self) { quality in
                    Button(action: {
                        selectedQuality = quality
                        sliderValue = quality.compressionRatio
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
                            Text("Select an image to preview")
                                .foregroundColor(.gray)
                        }
                    )
            }

            if selectedImage != nil {
                GeometryReader { geometry in
                    ZStack {
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: 2)
                            .position(x: sliderValue * geometry.size.width, y: geometry.size.height / 2)

                        Circle()
                            .fill(Color.white)
                            .frame(width: 30, height: 30)
                            .overlay(
                                Image(systemName: "arrow.left.and.right")
                                    .foregroundColor(.black)
                            )
                            .position(x: sliderValue * geometry.size.width, y: geometry.size.height / 2)
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        let newValue = value.location.x / geometry.size.width
                                        sliderValue = min(max(newValue, 0), 1)
                                    }
                            )
                    }
                }
            }
        }
        .onTapGesture {
            showingImagePicker = true
        }
        .padding()
    }

    private var sizeComparisonView: some View {
        HStack {
            VStack {
                Text("Original")
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
                Text("Compressed")
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
        .disabled(isCompressing)
    }

    private var loadingOverlay: some View {
        ZStack {
            Color.black.opacity(0.3).ignoresSafeArea()
            VStack {
                ProgressView()
                    .scaleEffect(1.5)
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                Text("Compressing...")
                    .foregroundColor(.white)
            }
            .padding()
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

        isCompressing = true
        let originalSize = originalFileSize

        DispatchQueue.global(qos: .userInitiated).async {
            // Calculate target size based on compression percentage
            let targetSize: Int64
            switch self.selectedQuality {
            case .low:
                targetSize = Int64(Double(originalSize) * 0.2)  // 20% of original
            case .medium:
                targetSize = Int64(Double(originalSize) * 0.5)  // 50% of original
            case .high:
                targetSize = Int64(Double(originalSize) * 0.8)  // 80% of original
            }
            
            print("🎯 Target size: \(self.formatBytes(targetSize)) from original \(self.formatBytes(originalSize))")
            
            // Try different compression qualities to achieve target size
            var compressionQuality: CGFloat = self.selectedQuality.compressionRatio
            var compressedData: Data?
            var bestData: Data?
            var bestDifference = Int64.max
            var attempts = 0
            let maxAttempts = 20
            
            // Binary search for the best compression quality
            var minQuality: CGFloat = 0.01
            var maxQuality: CGFloat = 1.0
            
            while attempts < maxAttempts && maxQuality - minQuality > 0.01 {
                compressionQuality = (minQuality + maxQuality) / 2
                compressedData = image.jpegData(compressionQuality: compressionQuality)
                
                if let data = compressedData {
                    let currentSize = Int64(data.count)
                    let difference = abs(currentSize - targetSize)
                    
                    print("🔄 Attempt \(attempts + 1): Quality \(compressionQuality) → Size \(self.formatBytes(currentSize))")
                    
                    // Keep track of the best result so far
                    if difference < bestDifference {
                        bestDifference = difference
                        bestData = data
                    }
                    
                    // If we're within 5% of target, accept it
                    if difference <= targetSize / 20 {
                        bestData = data
                        break
                    }
                    
                    // Adjust search range
                    if currentSize > targetSize {
                        maxQuality = compressionQuality
                    } else {
                        minQuality = compressionQuality
                    }
                }
                
                attempts += 1
            }
            
            // Use the best result we found
            guard let finalCompressedData = bestData else {
                DispatchQueue.main.async {
                    self.compressionResult.errorMessage = "Failed to compress image."
                    self.showErrorAlert = true
                    self.isCompressing = false
                }
                return
            }

            let compressedSize = Int64(finalCompressedData.count)
            let savedSpace = originalSize - compressedSize
            
            print("✅ Final compressed size: \(self.formatBytes(compressedSize))")

            // Create resource options to ensure JPEG format
            let options = PHAssetResourceCreationOptions()
            options.uniformTypeIdentifier = "public.jpeg"
            
            PHPhotoLibrary.shared().performChanges({
                // Create asset from JPEG data with explicit type
                let creationRequest = PHAssetCreationRequest.forAsset()
                creationRequest.addResource(with: .photo, data: finalCompressedData, options: options)
            }) { success, error in
                if success {
                    if let originalAsset = self.selectedAsset {
                        PHPhotoLibrary.shared().performChanges({
                            PHAssetChangeRequest.deleteAssets([originalAsset] as NSArray)
                        }) { deleteSuccess, deleteError in
                            DispatchQueue.main.async {
                                self.isCompressing = false
                                if deleteSuccess {
                                    self.compressionResult = CompressionResult(
                                        originalSize: self.formatBytes(originalSize),
                                        compressedSize: self.formatBytes(compressedSize),
                                        savedSpace: self.formatBytes(savedSpace)
                                    )
                                    self.showSuccessAlert = true
                                } else {
                                    self.compressionResult.errorMessage = deleteError?.localizedDescription ?? "Failed to delete original image."
                                    self.showErrorAlert = true
                                }
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.isCompressing = false
                            self.compressionResult = CompressionResult(
                                originalSize: self.formatBytes(originalSize),
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
        let targetSize: Int64
        switch selectedQuality {
        case .low:
            targetSize = Int64(Double(originalFileSize) * 0.2)  // 20% of original
        case .medium:
            targetSize = Int64(Double(originalFileSize) * 0.5)  // 50% of original
        case .high:
            targetSize = Int64(Double(originalFileSize) * 0.8)  // 80% of original
        }
        
        return formatBytes(targetSize)
    }

    private func formatBytes(_ bytes: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useKB, .useMB, .useGB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: bytes)
    }
}

// MARK: - Preview
struct MediaCompressionView_Previews: PreviewProvider {
    static var previews: some View {
        MediaCompressionView()
            .environmentObject(LanguageManager())
    }
}



