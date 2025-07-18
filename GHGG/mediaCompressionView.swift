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
        case .low: return 0.8
        case .medium: return 0.5
        case .high: return 0.2
        }
    }
}

struct ImagePickerWithAsset: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Binding var selectedAsset: PHAsset?
    @Environment(\.presentationMode) private var presentationMode

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1

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

            if let assetIdentifier = result.assetIdentifier {
                let fetchOptions = PHFetchOptions()
                let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [assetIdentifier], options: fetchOptions)
                parent.selectedAsset = fetchResult.firstObject
            }

            result.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                if let image = image as? UIImage {
                    DispatchQueue.main.async {
                        self.parent.selectedImage = image
                    }
                }
            }
        }
    }
}

struct MediaCompressionView: View {
    @State private var selectedQuality: CompressionQuality = .medium
    @State private var sliderValue: CGFloat = 0.5
    @State private var showingImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var selectedAsset: PHAsset?
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
           // .navigationBarTitle("Media Compression", displayMode: .inline)
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
            .alert("Image Replaced Successfully! ✅", isPresented: $showSuccessAlert) {
                Button("OK") {
                    selectedImage = nil
                    selectedAsset = nil
                }
            } message: {
                Text("Original: \(compressionResult.originalSize)\nCompressed: \(compressionResult.compressedSize)\nSaved: \(compressionResult.savedSpace)")
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
                ImagePickerWithAsset(selectedImage: $selectedImage, selectedAsset: $selectedAsset)
            }
        }
    }

//    private var qualitySection: some View {
//        VStack(alignment: .leading) {
//            Text("Quality")
//                .font(.headline)
//                .padding(.horizontal)
//
//            HStack {
//                ForEach(CompressionQuality.allCases, id: \.self) { quality in
//                    Button(action: {
//                        selectedQuality = quality
//                        sliderValue = quality.compressionRatio
//                    }) {
//                        VStack {
//                            Text(quality.localizedTitle(language: languageManager.currentLanguage))
//                            Text(quality.compressionPercentage(language: languageManager.currentLanguage))
//                                .font(.caption)
//                                .foregroundColor(.gray)
//                        }
//                        .padding()
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

    private var qualitySection: some View {
            VStack(alignment: .leading) {
                Text("Quality")
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
                            .frame(maxWidth: .infinity) // This makes all buttons equal width
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
                if let image = selectedImage, let data = image.jpegData(compressionQuality: 1.0) {
                    Text(formatBytes(Int64(data.count)))
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
                if let image = selectedImage {
                    Text(getCompressedSizeText(for: image))
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
                } else {
                    Image(systemName: "arrow.down.to.line")
                    Text("Compress & Replace")
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

        let originalData = image.jpegData(compressionQuality: 1.0) ?? Data()
        let originalSize = Int64(originalData.count)

        DispatchQueue.global(qos: .userInitiated).async {
            guard let compressedData = image.jpegData(compressionQuality: selectedQuality.compressionRatio),
                  let compressedImage = UIImage(data: compressedData) else {
                DispatchQueue.main.async {
                    self.compressionResult.errorMessage = "Failed to compress image."
                    self.showErrorAlert = true
                    self.isCompressing = false
                }
                return
            }

            let compressedSize = Int64(compressedData.count)
            let savedSpace = originalSize - compressedSize

            PHPhotoLibrary.shared().performChanges({
                // Save compressed image
                PHAssetChangeRequest.creationRequestForAsset(from: compressedImage)
            }) { success, error in
                if success {
                    // Delete the original image if asset is available
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

    func deleteAsset(with localIdentifier: String) {
        let assets = PHAsset.fetchAssets(withLocalIdentifiers: [localIdentifier], options: nil)
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.deleteAssets(assets)
        }, completionHandler: { success, error in
            if success {
                print("🗑️ Original image deleted.")
            } else if let error = error {
                print("❌ Error deleting original image: \(error)")
            }
        })
    }
    private func getCompressedSizeText(for image: UIImage) -> String {
        if let data = image.jpegData(compressionQuality: selectedQuality.compressionRatio) {
            return formatBytes(Int64(data.count))
        }
        return "--"
    }

    private func formatBytes(_ bytes: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useKB, .useMB, .useGB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: bytes)
    }
}
