//
//  emailCleanerView.swift
//  GHGG
//
//  Created by test on 17/05/2025.
//

import SwiftUI

struct EmailCategory: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let count: Int
    var isSelected: Bool = true
}

// Email Cleaner View
struct EmailCleanerView: View {
    @State private var emailCategories = [
        EmailCategory(name: "Social Media", icon: "bubble.left", count: 347),
        EmailCategory(name: "Promotions", icon: "megaphone", count: 347),
        EmailCategory(name: "Updates", icon: "clock", count: 347),
        EmailCategory(name: "Spam", icon: "exclamationmark.circle", count: 347),
        EmailCategory(name: "Drafts", icon: "doc.richtext", count: 347)
    ]
    
    @State private var allSelected: Bool = true
    
    var totalSelectedCount: Int {
        let selectedCategories = emailCategories.filter { $0.isSelected }
        return selectedCategories.reduce(0) { $0 + $1.count }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Selected count and deselect button
            HStack {
                Text("\(totalSelectedCount) Emails selected")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Spacer()
                Button("Deselect All") {
                    toggleAllSelection(selected: false)
                }
                .font(.subheadline)
                .foregroundColor(.blue)
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            
            // Email categories list
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(0..<emailCategories.count, id: \.self) { index in
                        EmailCategoryRow(
                            category: $emailCategories[index]
                        )
                        Divider()
                    }
                }
                .padding(.bottom, 100) // Add some space at the bottom
            }
            
            // Delete button
            Spacer()
            Button(action: {
                // Action to delete selected emails
                deleteSelectedEmails()
            }) {
                Text("Delete \(totalSelectedCount) Mails")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
    }
    
    private func toggleAllSelection(selected: Bool) {
        for index in 0..<emailCategories.count {
            emailCategories[index].isSelected = selected
        }
        allSelected = selected
    }
    
    private func deleteSelectedEmails() {
        // In a real app, you would delete the actual emails
        // This is just simulating the deletion by deselecting
        toggleAllSelection(selected: false)
    }
}

// Email Category Row
struct EmailCategoryRow: View {
    @Binding var category: EmailCategory
    
    var body: some View {
        HStack(spacing: 12) {
            // Category icon
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 40, height: 40)
                
                Image(systemName: category.icon)
                    .foregroundColor(.blue)
                    .font(.system(size: 18))
            }
            
            // Category name
            Text(category.name)
                .font(.system(size: 16))
                .foregroundColor(.primary)
            
            Spacer()
            
            // Mail count
            Text("\(category.count) Mails")
                .font(.system(size: 14))
                .foregroundColor(.gray)
            
            // Selection checkbox
            ZStack {
                Circle()
                    .fill(category.isSelected ? Color.blue : Color.clear)
                    .frame(width: 24, height: 24)
                
                if category.isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(.white)
                        .font(.system(size: 12, weight: .bold))
                } else {
                    Circle()
                        .strokeBorder(Color.gray, lineWidth: 1)
                        .frame(width: 24, height: 24)
                }
            }
            .onTapGesture {
                category.isSelected.toggle()
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
    }
}

// Preview
struct EmailCleanerView_Previews: PreviewProvider {
    static var previews: some View {
        EmailCleanerView()
    }
}
