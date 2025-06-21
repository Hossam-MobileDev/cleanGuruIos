//
//  mediaCompressionView.swift
//  GHGG
//
//  Created by test on 17/05/2025.
//
import Photos
import UIKit
import SwiftUI

struct MediaItem: Identifiable {
    let id = UUID()
    let asset: PHAsset
    var originalSize: Int64 = 0
    var compressedSize: Int64 = 0
    var isSelected: Bool = true
}

// MARK: - Compression Manager
class MediaCompressionManager: ObservableObject {
    @Published var mediaItems: [MediaItem] = []
    @Published var isLoading = false
    @Published var compressionProgress: Double = 0
    @Published var totalOriginalSize: Int64 = 0
    @Published var totalCompressedSize: Int64 = 0
    @Published var errorMessage: String?
    
    private let imageManager = PHImageManager.default()
    
    func requestPhotoLibraryAccess(completion: @escaping (Bool) -> Void) {
        PHPhotoLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                completion(status == .authorized)
            }
        }
    }
    
    func loadMediaItems() {
        isLoading = true
        mediaItems.removeAll()
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let results = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        results.enumerateObjects { asset, _, _ in
            var mediaItem = MediaItem(asset: asset)
            
            // Get original size
            let resources = PHAssetResource.assetResources(for: asset)
            if let resource = resources.first {
                mediaItem.originalSize = resource.value(forKey: "fileSize") as? Int64 ?? 0
            }
            
            self.mediaItems.append(mediaItem)
        }
        
        calculateTotalSizes()
        isLoading = false
    }
    
    func calculateTotalSizes() {
        totalOriginalSize = mediaItems.reduce(0) { $0 + $1.originalSize }
        totalCompressedSize = Int64(Double(totalOriginalSize) * getCompressionRatio())
    }
    
    func getCompressionRatio() -> Double {
        switch selectedQuality {
        case .low: return 0.8
        case .medium: return 0.5
        case .high: return 0.2
        }
    }
    
    @Published var selectedQuality: CompressionQuality = .medium
    
    func compressSelectedMedia(completion: @escaping (Bool) -> Void) {
        let selectedItems = mediaItems.filter { $0.isSelected }
        guard !selectedItems.isEmpty else {
            completion(false)
            return
        }
        
        isLoading = true
        compressionProgress = 0
        
        let group = DispatchGroup()
        var processedCount = 0
        let totalCount = selectedItems.count
        
        for item in selectedItems {
            group.enter()
            
            compressImage(asset: item.asset, quality: selectedQuality) { success in
                DispatchQueue.main.async {
                    processedCount += 1
                    self.compressionProgress = Double(processedCount) / Double(totalCount)
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.isLoading = false
            completion(true)
        }
    }
    
    private func compressImage(asset: PHAsset, quality: CompressionQuality, completion: @escaping (Bool) -> Void) {
        let options = PHImageRequestOptions()
        options.isSynchronous = false
        options.deliveryMode = .highQualityFormat
        
        imageManager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: options) { image, _ in
            guard let image = image else {
                completion(false)
                return
            }
            
            // Compress and save
            DispatchQueue.global(qos: .background).async {
                let compressionQuality: CGFloat = {
                    switch quality {
                    case .low: return 0.8
                    case .medium: return 0.5
                    case .high: return 0.2
                    }
                }()
                
                guard let compressedData = image.jpegData(compressionQuality: compressionQuality) else {
                    completion(false)
                    return
                }
                
                // Save to photo library
                PHPhotoLibrary.shared().performChanges({
                    let creationRequest = PHAssetCreationRequest.forAsset()
                    creationRequest.addResource(with: .photo, data: compressedData, options: nil)
                }) { success, error in
                    DispatchQueue.main.async {
                        if let error = error {
                            self.errorMessage = error.localizedDescription
                        }
                        completion(success)
                    }
                }
            }
        }
    }
}

// MARK: - Compression Quality Enum
enum CompressionQuality: String, CaseIterable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    
    var compressionPercentage: String {
        switch self {
        case .low: return "20% Compress"
        case .medium: return "50% Compress"
        case .high: return "80% Compress"
        }
    }
}

// MARK: - Main View
struct MediaCompressionView: View {
    @StateObject private var compressionManager = MediaCompressionManager()
    @State private var selectedQuality: CompressionQuality = .medium
    @State private var sliderValue: CGFloat = 0.5
    @State private var showingImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var showingPermissionAlert = false
    @State private var isCompressing = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    // Storage Info
                    storageInfoView
                    
                    // Quality section
                    Text("Quality")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                        .padding(.top)
                    
                    // Quality options
                    HStack(spacing: 15) {
                        ForEach(CompressionQuality.allCases, id: \.self) { quality in
                            qualityButton(quality)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Image comparison
                    imageComparisonView
                    
                    // Size comparison
                    sizeComparisonView
                    
                    // Action buttons
                    actionButtonsView
                    
                    // Media list
                    if !compressionManager.mediaItems.isEmpty {
                        mediaListView
                    }
                }
            }
            .navigationTitle("Media Compression")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                checkPhotoLibraryAccess()
            }
            .alert("Permission Required", isPresented: $showingPermissionAlert) {
                Button("Settings") {
                    if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(settingsUrl)
                    }
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Please allow access to your photo library to compress images.")
            }
            .overlay {
                if compressionManager.isLoading {
                    loadingOverlay
                }
            }
        }
    }
    
    // MARK: - View Components
    
    private var storageInfoView: some View {
        VStack(spacing: 10) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Original Size")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(formatBytes(compressionManager.totalOriginalSize))
                        .font(.headline)
                        .foregroundColor(.orange)
                }
                
                Spacer()
                
                Image(systemName: "arrow.right")
                    .foregroundColor(.gray)
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("After Compression")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(formatBytes(compressionManager.totalCompressedSize))
                        .font(.headline)
                        .foregroundColor(.green)
                }
            }
            
            // Savings
            Text("Save \(formatBytes(compressionManager.totalOriginalSize - compressionManager.totalCompressedSize))")
                .font(.subheadline)
                .foregroundColor(.blue)
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(20)
        }
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(12)
        .padding(.horizontal)
    }
    
    private var imageComparisonView: some View {
        ZStack(alignment: .center) {
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
                            Image(systemName: "photo.on.rectangle.angled")
                                .font(.system(size: 50))
                                .foregroundColor(.gray)
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
                            .shadow(color: Color.black.opacity(0.3), radius: 2, x: 0, y: 1)
                            .position(x: sliderValue * geometry.size.width, y: geometry.size.height / 2)
                        
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 30, height: 30)
                                .shadow(color: Color.black.opacity(0.3), radius: 2, x: 0, y: 1)
                            
                            Image(systemName: "arrow.left.and.right")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.black)
                        }
                        .position(x: sliderValue * geometry.size.width, y: geometry.size.height / 2)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    let newPosition = value.location.x / geometry.size.width
                                    sliderValue = min(max(newPosition, 0), 1)
                                }
                        )
                    }
                }
            }
        }
        .padding(.horizontal)
        .onTapGesture {
            showingImagePicker = true
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(selectedImage: $selectedImage)
        }
    }
    
    private var sizeComparisonView: some View {
        HStack {
            VStack {
                Text("Original")
                    .font(.subheadline)
                    .foregroundColor(.primary)
                
                if let image = selectedImage,
                   let imageData = image.jpegData(compressionQuality: 1.0) {
                    Text(formatBytes(Int64(imageData.count)))
                        .font(.subheadline)
                        .foregroundColor(.orange)
                } else {
                    Text("--")
                        .font(.subheadline)
                        .foregroundColor(.orange)
                }
            }
            
            Spacer()
            
            Image(systemName: "arrow.right")
                .font(.system(size: 18))
                .foregroundColor(.gray)
            
            Spacer()
            
            VStack {
                Text("Compressed")
                    .font(.subheadline)
                    .foregroundColor(.primary)
                
                if let image = selectedImage {
                    Text(getCompressedSizeText(for: image))
                        .font(.subheadline)
                        .foregroundColor(.green)
                } else {
                    Text("--")
                        .font(.subheadline)
                        .foregroundColor(.green)
                }
            }
        }
        .padding(.horizontal, 60)
        .padding(.vertical, 15)
    }
    
    private var actionButtonsView: some View {
        VStack(spacing: 12) {
            Button(action: {
                compressAllMedia()
            }) {
                HStack {
                    if isCompressing {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.8)
                    } else {
                        Image(systemName: "square.and.arrow.down")
                    }
                    Text(isCompressing ? "Compressing..." : "Compress All Media")
                        .font(.headline)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(12)
            }
            .disabled(isCompressing || compressionManager.mediaItems.isEmpty)
            
            if compressionManager.compressionProgress > 0 && compressionManager.compressionProgress < 1 {
                ProgressView(value: compressionManager.compressionProgress)
                    .progressViewStyle(LinearProgressViewStyle())
                    .padding(.horizontal)
            }
        }
        .padding(.horizontal)
    }
    
    private var mediaListView: some View {
        VStack(alignment: .leading) {
            Text("Select Media (\(compressionManager.mediaItems.filter { $0.isSelected }.count) selected)")
                .font(.headline)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(compressionManager.mediaItems.indices, id: \.self) { index in
                        MediaThumbnail(
                            mediaItem: compressionManager.mediaItems[index],
                            isSelected: compressionManager.mediaItems[index].isSelected
                        ) {
                            compressionManager.mediaItems[index].isSelected.toggle()
                            compressionManager.calculateTotalSizes()
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical)
    }
    
    private var loadingOverlay: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
                
                Text("Processing...")
                    .foregroundColor(.white)
                    .font(.headline)
            }
            .padding(40)
            .background(Color.black.opacity(0.7))
            .cornerRadius(20)
        }
    }
    
    // MARK: - Helper Methods
    
    private func checkPhotoLibraryAccess() {
        compressionManager.requestPhotoLibraryAccess { granted in
            if granted {
                compressionManager.loadMediaItems()
            } else {
                showingPermissionAlert = true
            }
        }
    }
    
    private func qualityButton(_ quality: CompressionQuality) -> some View {
        Button(action: {
            selectedQuality = quality
            compressionManager.selectedQuality = quality
            compressionManager.calculateTotalSizes()
            
            switch quality {
            case .low: sliderValue = 0.2
            case .medium: sliderValue = 0.5
            case .high: sliderValue = 0.8
            }
        }) {
            VStack(spacing: 4) {
                Text(quality.rawValue)
                    .font(.headline)
                    .foregroundColor(selectedQuality == quality ? .blue : .primary)
                
                Text(quality.compressionPercentage)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white)
                    .shadow(color: selectedQuality == quality ? Color.blue.opacity(0.2) : Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(selectedQuality == quality ? Color.blue.opacity(0.5) : Color.gray.opacity(0.1), lineWidth: 1)
                    )
            )
        }
    }
    
    private func getCompressedSizeText(for image: UIImage) -> String {
        let compressionQuality: CGFloat = {
            switch selectedQuality {
            case .low: return 0.8
            case .medium: return 0.5
            case .high: return 0.2
            }
        }()
        
        if let compressedData = image.jpegData(compressionQuality: compressionQuality) {
            return formatBytes(Int64(compressedData.count))
        }
        return "--"
    }
    
    private func compressAllMedia() {
        isCompressing = true
        compressionManager.compressSelectedMedia { success in
            isCompressing = false
            if success {
                // Show success message or refresh view
                compressionManager.loadMediaItems()
            }
        }
    }
    
    private func formatBytes(_ bytes: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useBytes, .useKB, .useMB, .useGB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: bytes)
    }
}

// MARK: - Media Thumbnail View
struct MediaThumbnail: View {
    let mediaItem: MediaItem
    let isSelected: Bool
    let onTap: () -> Void
    @State private var thumbnail: UIImage?
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            if let image = thumbnail {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipped()
                    .cornerRadius(8)
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 100, height: 100)
            }
            
            // Selection indicator
            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                .foregroundColor(isSelected ? .blue : .white)
                .background(Circle().fill(Color.black.opacity(0.5)))
                .padding(4)
        }
        .onTapGesture {
            onTap()
        }
        .onAppear {
            loadThumbnail()
        }
    }
    
    private func loadThumbnail() {
        let options = PHImageRequestOptions()
        options.isSynchronous = false
        options.deliveryMode = .fastFormat
        
        PHImageManager.default().requestImage(
            for: mediaItem.asset,
            targetSize: CGSize(width: 200, height: 200),
            contentMode: .aspectFill,
            options: options
        ) { image, _ in
            self.thumbnail = image
        }
    }
}

// MARK: - Image Picker
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) private var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

// MARK: - App Entry Point


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
