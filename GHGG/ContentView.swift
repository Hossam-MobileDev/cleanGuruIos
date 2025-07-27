//
//  ContentView.swift
//  GHGG
//
//  Created by test on 11/05/2025.
//
import SwiftUI
import Photos
import GoogleMobileAds
import UIKit

class StorageOptimizationState: ObservableObject {
    // Duplicate detection states
    @Published var duplicateGroups: [DuplicatePhotoGroup] = []
    @Published var selectedDuplicates: Set<String> = []
    @Published var isAnalyzingDuplicates = false
    @Published var duplicatesAccessGranted = false
    @Published var hasCheckedDuplicatesAccess = false
    @Published var hasAnalyzedDuplicates = false
    @Published var analyzedPhotosCount = 0
    @Published var totalPhotosCount = 0
    
    @Published var audioFiles: [URL] = []

    @Published var mediaAssetsArray: [PHAsset] = []

    // Clean Media states
    @Published var photoAssets: PHFetchResult<PHAsset>?
    @Published var photoAccessGranted = false
    @Published var isLoading = true
    @Published var selectedMediaItems: Set<String> = []
    @Published var selectedMediaCategory = "Photos"
    
    // Other states
    @Published var selectedTab = "Duplicates"
    @Published var selectedContacts: Set<String> = []
    @Published var totalStorage: Int64 = 0
    @Published var usedStorage: Int64 = 0
    @Published var freeStorage: Int64 = 0
    
    init() {
            checkCurrentPhotoAuthorizationStatus()
        }
        
        // ADD THIS METHOD
        private func checkCurrentPhotoAuthorizationStatus() {
            let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
            
            DispatchQueue.main.async {
                switch status {
                case .authorized, .limited:
                    self.duplicatesAccessGranted = true
                    self.photoAccessGranted = true
                    self.hasCheckedDuplicatesAccess = true
                    self.isLoading = false
                case .denied, .restricted:
                    self.duplicatesAccessGranted = false
                    self.photoAccessGranted = false
                    self.hasCheckedDuplicatesAccess = true
                    self.isLoading = false
                case .notDetermined:
                    self.duplicatesAccessGranted = false
                    self.photoAccessGranted = false
                    self.hasCheckedDuplicatesAccess = false
                    self.isLoading = false
                @unknown default:
                    self.duplicatesAccessGranted = false
                    self.photoAccessGranted = false
                    self.hasCheckedDuplicatesAccess = false
                    self.isLoading = false
                }
            }
        }
}

struct ContentView: View {
    // Use @EnvironmentObject instead of creating a new instance
    @EnvironmentObject var languageManager: LanguageManager
    @StateObject private var storageState = StorageOptimizationState() // Create once and persist

    // Explicitly set dashboard as the default selected tab
    @State private var selectedTab: Tab = .dashboard
    @State private var showSettings: Bool = false

    enum Tab {
        case dashboard
        case storage
        case settings
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Main content area - takes all available space
            ZStack {
                // Different views based on selected tab
                switch selectedTab {
                case .dashboard:
                    StorageAnalyticsView()
                        .environmentObject(languageManager)
                        .padding(.top, 15) // Add spacing from status bar

                case .storage:
                    StorageOptimizationView()
                        .environmentObject(languageManager)
                        .environmentObject(storageState) // Pass the persistent state
                        .padding(.top, 15) // Add spacing from status bar

                case .settings:
                    SettinappView(togglefullscreen: $showSettings)
                        .environmentObject(languageManager)
                        .padding(.top, 15)
                }
            }
            
            // Custom tab bar at the bottom (without indicator line)
            LocalizedCustomTabBar(selectedTab: $selectedTab)
                .environmentObject(languageManager)

            BannerAdView()
                .frame(height: 50) // Standard banner height
                .background(Color.white)
        }
        .background(Color(hex: "F2F9FF"))
        .edgesIgnoringSafeArea([.top, .bottom]) // Extend to cover status bar and bottom
        .preferredColorScheme(.light) // Ensures dark status bar content
        .environment(\.layoutDirection, languageManager.isArabic ? .rightToLeft : .leftToRight)
        .id(languageManager.currentLanguage) // Force complete view refresh when language changes
    }
}

struct BannerAdView: UIViewRepresentable {
    let adUnitID: String
    
    init(adUnitID: String = "ca-app-pub-1439642083038769/4773340793") { // Test ad unit ID
        self.adUnitID = adUnitID
    }
    
    func makeUIView(context: Context) -> GADBannerView {
        let bannerView = GADBannerView(adSize: GADAdSizeBanner)
        bannerView.adUnitID = adUnitID
        
        // Find root view controller to set as banner's root view controller
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            bannerView.rootViewController = rootViewController
        }
        
        bannerView.load(GADRequest())
        return bannerView
    }
    
    func updateUIView(_ uiView: GADBannerView, context: Context) {}
}

// Updated LocalizedCustomTabBar without indicator line
struct LocalizedCustomTabBar: View {
    @Binding var selectedTab: ContentView.Tab
    @EnvironmentObject var languageManager: LanguageManager
    
    var body: some View {
        VStack(spacing: 0) {
            // Thin divider line at the top
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(Color.gray.opacity(0.3))
            
            // Tab bar items (without indicator)
            HStack(spacing: 0) {
                tabButton(
                    tab: .dashboard,
                    name: LocalizedStrings.string(for: "dashboard", language: languageManager.currentLanguage),
                    icon: "house"
                )
                tabButton(
                    tab: .storage,
                    name: LocalizedStrings.string(for: "storage", language: languageManager.currentLanguage),
                    icon: "doc"
                )
                tabButton(
                    tab: .settings,
                    name: LocalizedStrings.string(for: "settings", language: languageManager.currentLanguage),
                    icon: "gearshape"
                )
            }
            .frame(height: 50)
            .background(Color.white)
            
            // Removed the selection indicator section completely
        }
        .environment(\.layoutDirection, languageManager.isArabic ? .rightToLeft : .leftToRight)
    }
    
    // Removed getIndicatorOffset function since it's no longer needed
    
    private func tabButton(tab: ContentView.Tab, name: String, icon: String) -> some View {
        Button(action: {
            selectedTab = tab
        }) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                Text(name)
                    .font(.caption)
            }
            .foregroundColor(selectedTab == tab ? .blue : .gray)
            .frame(maxWidth: .infinity)
        }
    }
}

// Alternative implementation with animation (also without indicator)
struct LocalizedCustomTabBarAnimated: View {
    @Binding var selectedTab: ContentView.Tab
    @EnvironmentObject var languageManager: LanguageManager
    @Namespace private var animation
    
    var body: some View {
        VStack(spacing: 0) {
            // Thin divider line at the top
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(Color.gray.opacity(0.3))
            
            // Tab bar items without animated indicator
            HStack(spacing: 0) {
                ForEach([ContentView.Tab.dashboard, .storage, .settings], id: \.self) { tab in
                    tabButtonWithoutIndicator(
                        tab: tab,
                        name: getLocalizedName(for: tab),
                        icon: getIcon(for: tab)
                    )
                }
            }
            .frame(height: 50) // Reduced height since no indicator
            .background(Color.white)
        }
        .environment(\.layoutDirection, languageManager.isArabic ? .rightToLeft : .leftToRight)
    }
    
    private func getLocalizedName(for tab: ContentView.Tab) -> String {
        switch tab {
        case .dashboard:
            return LocalizedStrings.string(for: "dashboard", language: languageManager.currentLanguage)
        case .storage:
            return LocalizedStrings.string(for: "storage", language: languageManager.currentLanguage)
        case .settings:
            return LocalizedStrings.string(for: "settings", language: languageManager.currentLanguage)
        }
    }
    
    private func getIcon(for tab: ContentView.Tab) -> String {
        switch tab {
        case .dashboard:
            return "house"
        case .storage:
            return "doc"
        case .settings:
            return "gearshape"
        }
    }
    
    // Updated tab button without indicator
    private func tabButtonWithoutIndicator(tab: ContentView.Tab, name: String, icon: String) -> some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedTab = tab
            }
        }) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                Text(name)
                    .font(.caption)
            }
            .foregroundColor(selectedTab == tab ? .blue : .gray)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
        }
    }
}

// Settings placeholder view
struct SettingsPlaceholderView: View {
    @EnvironmentObject var languageManager: LanguageManager
    
    var body: some View {
        VStack {
            Text(LocalizedStrings.string(for: "settings", language: languageManager.currentLanguage))
                .font(.largeTitle)
                .padding()
            
            Text("Settings screen would go here")
                .foregroundColor(.gray)
        }
        .environment(\.layoutDirection, languageManager.isArabic ? .rightToLeft : .leftToRight)
    }
}

// Extension for rounded specific corners
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

// Add placeholder image extension
extension Image {
    static func placeholder(_ color: Color = .gray) -> some View {
        Rectangle()
            .fill(color)
            .opacity(0.2)
            .overlay(
                Image(systemName: "photo")
                    .foregroundColor(.gray)
            )
        }
    }

