//
//  cleanMediaView.swift
//  GHGG
//
//  Created by test on 19/05/2025.
//

import SwiftUI
import Photos

//struct CleanMediaView: View {
//    @Binding var photoAssets: PHFetchResult<PHAsset>?
//    @Binding var isLoading: Bool
//    @Binding var photoAccessGranted: Bool
//    @Binding var selectedMediaCategory: String
//    @Binding var selectedMediaItems: Set<String>
//    
//    let mediaCategories = ["Photos", "Videos", "Audio"]
//    
//    var body: some View {
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
//                ProgressView("Loading \(selectedMediaCategory.lowercased())...")
//                    .padding()
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//            } else if !photoAccessGranted {
//                // View for when access is not yet granted
//                // We'll trigger the access request with onAppear
//                ProgressView("Accessing media...")
//                    .padding()
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//                    .onAppear {
//                        autoRequestAccess()
//                    }
//            } else if let assets = photoAssets, assets.count > 0 {
//                // Selected count and media list
//                HStack {
//                    let selectedCount = selectedMediaItems.count
//                    Text("\(selectedCount) \(selectedMediaCategory.singular()) selected")
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
//                // No media found
//                Text("No \(selectedMediaCategory.lowercased()) found")
//                    .font(.headline)
//                    .foregroundColor(.gray)
//                    .padding()
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//            }
//        }
//        .onAppear {
//            if photoAssets == nil || photoAssets?.count == 0 {
//                // Auto-fetch media when the view appears if we don't have any
//                fetchAppropriateMedia()
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
//                    fetchAppropriateMedia()
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
//    
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
//    // Auto-request access without showing permission UI
//    private func autoRequestAccess() {
//        // This would normally show permission UI, but here we just
//        // assume we have access and try to fetch
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            photoAccessGranted = true
//            fetchAppropriateMedia()
//        }
//    }
//    
//    // Fetch media based on the selected category
//    private func fetchAppropriateMedia() {
//        isLoading = true
//        
//        let options = PHFetchOptions()
//        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
//        
//        DispatchQueue.global(qos: .userInitiated).async {
//            let mediaType: PHAssetMediaType
//            
//            switch selectedMediaCategory {
//            case "Photos":
//                mediaType = .image
//            case "Videos":
//                mediaType = .video
//            case "Audio":
//                mediaType = .audio
//            default:
//                mediaType = .image
//            }
//            
//            // Fetch assets directly without permission checks
//            let assets = PHAsset.fetchAssets(with: mediaType, options: options)
//            
//            DispatchQueue.main.async {
//                photoAssets = assets
//                isLoading = false
//            }
//        }
//    }
//}
//
//// Extension to get singular form of media type
//extension String {
//    func singular() -> String {
//        if self == "Audio" {
//            return "audio file"
//        }
//        // Remove last character (s) to get singular form
//        return self.dropLast().lowercased()
//    }
//}

//struct CleanMediaView: View {
//    @Binding var photoAssets: PHFetchResult<PHAsset>?
//    @Binding var isLoading: Bool
//    @Binding var photoAccessGranted: Bool
//    @Binding var selectedMediaCategory: String
//    @Binding var selectedMediaItems: Set<String>
//    @StateObject private var languageManager = LanguageManager()
//    
//    var mediaCategories: [String] {
//        [
//            LocalizedStrings.string(for: "photos", language: languageManager.currentLanguage),
//            LocalizedStrings.string(for: "videos", language: languageManager.currentLanguage),
//            LocalizedStrings.string(for: "audio", language: languageManager.currentLanguage)
//        ]
//    }
//    
//    var body: some View {
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
//                VStack {
//                    ProgressView()
//                    LocalizedText("loading_media")
//                        .padding(.top)
//                }
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//            } else if !photoAccessGranted {
//                // Permission view
//                VStack(spacing: 20) {
//                    Image(systemName: "photo.on.rectangle.angled")
//                        .font(.system(size: 48))
//                        .foregroundColor(.gray)
//                    
//                    LocalizedText("photo_access_required")
//                        .font(.headline)
//                    
//                    LocalizedText("allow_access_photos_settings")
//                        .multilineTextAlignment(.center)
//                        .padding(.horizontal)
//                    
//                    Button(LocalizedStrings.string(for: "open_settings", language: languageManager.currentLanguage)) {
//                        if let url = URL(string: UIApplication.openSettingsURLString) {
//                            UIApplication.shared.open(url)
//                        }
//                    }
//                    .foregroundColor(.blue)
//                }
//                .padding()
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                .onAppear {
//                    autoRequestAccess()
//                }
//            } else if let assets = photoAssets, assets.count > 0 {
//                // Selected count and media list
//                HStack {
//                    let selectedCount = selectedMediaItems.count
//                    if languageManager.isArabic {
//                        if selectedCount > 0 {
//                            Button(LocalizedStrings.string(for: "deselect_all", language: languageManager.currentLanguage)) {
//                                selectedMediaItems.removeAll()
//                            }
//                            .font(.subheadline)
//                            .foregroundColor(.blue)
//                        }
//                        
//                        Spacer()
//                        
//                        Text("\(selectedCount) \(selectedMediaCategory.singularForm(language: languageManager.currentLanguage)) \(LocalizedStrings.string(for: "selected", language: languageManager.currentLanguage))")
//                            .font(.subheadline)
//                            .foregroundColor(.gray)
//                    } else {
//                        Text("\(selectedCount) \(selectedMediaCategory.singularForm(language: languageManager.currentLanguage)) \(LocalizedStrings.string(for: "selected", language: languageManager.currentLanguage))")
//                            .font(.subheadline)
//                            .foregroundColor(.gray)
//                        
//                        Spacer()
//                        
//                        if selectedCount > 0 {
//                            Button(LocalizedStrings.string(for: "deselect_all", language: languageManager.currentLanguage)) {
//                                selectedMediaItems.removeAll()
//                            }
//                            .font(.subheadline)
//                            .foregroundColor(.blue)
//                        }
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
//                            LocalizedAssetRow(
//                                asset: asset,
//                                isSelected: selectedMediaItems.contains(asset.localIdentifier),
//                                languageManager: languageManager,
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
//                // No media found
//                VStack {
//                    LocalizedText("no_media_found")
//                        .font(.headline)
//                        .foregroundColor(.gray)
//                }
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//            }
//        }
//        .environment(\.layoutDirection, languageManager.isArabic ? .rightToLeft : .leftToRight)
//        .onAppear {
//            if photoAssets == nil || photoAssets?.count == 0 {
//                // Auto-fetch media when the view appears if we don't have any
//                fetchAppropriateMedia()
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
//                    fetchAppropriateMedia()
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
//    
//    // Helper function to get icon for category
//    private func categoryIcon(for category: String) -> String {
//        // Map localized category names to English for icon lookup
//        if category == LocalizedStrings.string(for: "photos", language: languageManager.currentLanguage) {
//            return "photo"
//        } else if category == LocalizedStrings.string(for: "videos", language: languageManager.currentLanguage) {
//            return "video"
//        } else if category == LocalizedStrings.string(for: "audio", language: languageManager.currentLanguage) {
//            return "music.note"
//        } else {
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
//    // Auto-request access
//    private func autoRequestAccess() {
//        PHPhotoLibrary.requestAuthorization { status in
//            DispatchQueue.main.async {
//                if status == .authorized || status == .limited {
//                    self.photoAccessGranted = true
//                    self.fetchAppropriateMedia()
//                } else {
//                    self.photoAccessGranted = false
//                    self.isLoading = false
//                }
//            }
//        }
//    }
//    
//    // Fetch media based on the selected category
//    private func fetchAppropriateMedia() {
//        isLoading = true
//        
//        let options = PHFetchOptions()
//        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
//        
//        DispatchQueue.global(qos: .userInitiated).async {
//            let mediaType: PHAssetMediaType
//            
//            // Map localized category to PHAssetMediaType
//            if self.selectedMediaCategory == LocalizedStrings.string(for: "photos", language: self.languageManager.currentLanguage) {
//                mediaType = .image
//            } else if self.selectedMediaCategory == LocalizedStrings.string(for: "videos", language: self.languageManager.currentLanguage) {
//                mediaType = .video
//            } else if self.selectedMediaCategory == LocalizedStrings.string(for: "audio", language: self.languageManager.currentLanguage) {
//                mediaType = .audio
//            } else {
//                mediaType = .image
//            }
//            
//            // Fetch assets directly
//            let assets = PHAsset.fetchAssets(with: mediaType, options: options)
//            
//            DispatchQueue.main.async {
//                self.photoAssets = assets
//                self.isLoading = false
//            }
//        }
//    }
//}
