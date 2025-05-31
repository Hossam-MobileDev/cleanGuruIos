//
//  ContentView.swift
//  GHGG
//
//  Created by test on 11/05/2025.
//
import SwiftUI



struct ContentView: View {
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
                case .storage:
                    StorageOptimizationView()
                case .settings:
                    SettinappView(togglefullscreen: $showSettings)
                }
            }
            
            // Custom tab bar at the bottom
            CustomTabBar(selectedTab: $selectedTab)
        }
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: ContentView.Tab
    
    var body: some View {
        VStack(spacing: 0) {
            // Thin divider line at the top
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(Color.gray.opacity(0.3))
            
            // Tab bar items
            HStack(spacing: 0) {
                tabButton(tab: .dashboard, name: "Dashboard", icon: "house")
                tabButton(tab: .storage, name: "Storage", icon: "doc")
                tabButton(tab: .settings, name: "Settings", icon: "gearshape")
            }
            .frame(height: 50)
            .background(Color.white)
            
            // Selection indicator
            HStack {
                // Position the indicator based on selected tab
                if selectedTab == .dashboard {
                    selectionIndicator
                        .frame(width: UIScreen.main.bounds.width / 3)
                    Spacer()
                    Spacer()
                } else if selectedTab == .storage {
                    Spacer()
                    selectionIndicator
                        .frame(width: UIScreen.main.bounds.width / 3)
                    Spacer()
                } else {
                    Spacer()
                    Spacer()
                    selectionIndicator
                        .frame(width: UIScreen.main.bounds.width / 3)
                }
            }
            .frame(height: 2)
            .padding(.bottom, 2)
        }
    }
    
    private var selectionIndicator: some View {
        Rectangle()
            .foregroundColor(.black)
            .frame(height: 2)
    }
    
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

// Settings placeholder view
struct SettingsPlaceholderView: View {
    var body: some View {
        VStack {
            Text("Settings")
                .font(.largeTitle)
                .padding()
            
            Text("Settings screen would go here")
                .foregroundColor(.gray)
        }
    }
}

// Preview
struct MainContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
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
