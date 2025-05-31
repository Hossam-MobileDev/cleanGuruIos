//
//  cleanMediaView.swift
//  GHGG
//
//  Created by test on 19/05/2025.
//

import SwiftUI
import Photos

struct CleanMediaView: View {
    @Binding var photoAssets: PHFetchResult<PHAsset>?
    @Binding var isLoading: Bool
    @Binding var photoAccessGranted: Bool
    @Binding var selectedMediaCategory: String
    @Binding var selectedMediaItems: Set<String>
    
    let mediaCategories = ["Photos", "Videos", "Audio"]
    
    var body: some View {
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
                ProgressView("Loading \(selectedMediaCategory.lowercased())...")
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if !photoAccessGranted {
                // View for when access is not yet granted
                // We'll trigger the access request with onAppear
                ProgressView("Accessing media...")
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .onAppear {
                        autoRequestAccess()
                    }
            } else if let assets = photoAssets, assets.count > 0 {
                // Selected count and media list
                HStack {
                    let selectedCount = selectedMediaItems.count
                    Text("\(selectedCount) \(selectedMediaCategory.singular()) selected")
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
                // No media found
                Text("No \(selectedMediaCategory.lowercased()) found")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .onAppear {
            if photoAssets == nil || photoAssets?.count == 0 {
                // Auto-fetch media when the view appears if we don't have any
                fetchAppropriateMedia()
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
                    fetchAppropriateMedia()
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
    
    // Auto-request access without showing permission UI
    private func autoRequestAccess() {
        // This would normally show permission UI, but here we just
        // assume we have access and try to fetch
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            photoAccessGranted = true
            fetchAppropriateMedia()
        }
    }
    
    // Fetch media based on the selected category
    private func fetchAppropriateMedia() {
        isLoading = true
        
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        DispatchQueue.global(qos: .userInitiated).async {
            let mediaType: PHAssetMediaType
            
            switch selectedMediaCategory {
            case "Photos":
                mediaType = .image
            case "Videos":
                mediaType = .video
            case "Audio":
                mediaType = .audio
            default:
                mediaType = .image
            }
            
            // Fetch assets directly without permission checks
            let assets = PHAsset.fetchAssets(with: mediaType, options: options)
            
            DispatchQueue.main.async {
                photoAssets = assets
                isLoading = false
            }
        }
    }
}

// Extension to get singular form of media type
extension String {
    func singular() -> String {
        if self == "Audio" {
            return "audio file"
        }
        // Remove last character (s) to get singular form
        return self.dropLast().lowercased()
    }
}
