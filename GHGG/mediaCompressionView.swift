//
//  mediaCompressionView.swift
//  GHGG
//
//  Created by test on 17/05/2025.
//

import SwiftUI

struct MediaCompressionView: View {
    @State private var selectedQuality: CompressionQuality = .medium
    @State private var sliderValue: CGFloat = 0.5 // Start in the middle
    
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
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
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
                ZStack(alignment: .center) {
                    // Original image (using a placeholder in a real app)
                    // This would be replaced with actual user image
                    Image("compression_demo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 400)
                    
                    // Slider implementation
                    GeometryReader { geometry in
                        ZStack {
                            // Vertical divider line
                            Rectangle()
                                .fill(Color.white)
                                .frame(width: 2)
                                .shadow(color: Color.black.opacity(0.3), radius: 2, x: 0, y: 1)
                                .position(x: sliderValue * geometry.size.width, y: geometry.size.height / 2)
                            
                            // Drag indicator
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
                .padding(.top, 20)
                
                // Original vs Compressed labels
                HStack {
                    VStack {
                        Text("Original")
                            .font(.subheadline)
                            .foregroundColor(.primary)
                        
                        Text("18.7 MB")
                            .font(.subheadline)
                            .foregroundColor(.orange)
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
                        
                        // Show different sizes based on compression level
                        Text(compressedSizeText())
                            .font(.subheadline)
                            .foregroundColor(.green)
                    }
                }
                .padding(.horizontal, 60)
                .padding(.top, 15)
                .padding(.bottom, 30)
                
                // Compress All button
                Button(action: {
                    // Action for compression
                    print("Compressing with \(selectedQuality.rawValue) quality")
                }) {
                    Text("Compress All Media")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding(.horizontal)
            }
        }
    }
    
    private func compressedSizeText() -> String {
        switch selectedQuality {
        case .low:
            return "14.9 MB"
        case .medium:
            return "9.3 MB"
        case .high:
            return "2.4 MB"
        }
    }
    
    private func qualityButton(_ quality: CompressionQuality) -> some View {
        Button(action: {
            selectedQuality = quality
            
            // Update slider value based on quality
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
}

// Preview for SwiftUI Canvas
struct MediaCompressionView_Previews: PreviewProvider {
    static var previews: some View {
        MediaCompressionView()
    }
}
