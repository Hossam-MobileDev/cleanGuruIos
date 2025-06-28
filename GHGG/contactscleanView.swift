//
//  contactscleanView.swift
//  GHGG
//
//  Created by test on 13/05/2025.
//

import SwiftUI
import Contacts

struct ContactsCleanupView: View {
    @State private var selectedContacts: Set<String> = []
    @State private var duplicateGroups: [String: [CNContact]] = [:]
    @State private var isLoading = true
    @State private var permissionDenied = false
    @State private var showBackupSuccessAlert = false
    @State private var showRestoreSuccessAlert = false
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    @EnvironmentObject var languageManager: LanguageManager

    var body: some View {
        VStack(spacing: 0) {
            // Action buttons section
            HStack(spacing: 20) {
                // Backup Contacts button
                Button(action: {
                    backupContacts()
                }) {
                    VStack(spacing: 8) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white)
                                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                                .frame(width: 140, height: 80)
                            
                            Image(systemName: "arrow.clockwise.icloud")
                                .font(.system(size: 24))
                                .foregroundColor(.blue)
                        }
//                        
//                        Text("Backup Contacts")
//                            .font(.subheadline)
//                            .foregroundColor(.primary)
                        Text(LocalizedStrings.string(for: "Backup Contacts", language: languageManager.currentLanguage))
                            .font(.subheadline)
                            .foregroundColor(.primary)
                    }
                }
                
                // Restore Contacts button
                Button(action: {
                    restoreContacts()
                }) {
                    VStack(spacing: 8) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white)
                                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                                .frame(width: 140, height: 80)
                            
                            Image(systemName: "arrow.counterclockwise.icloud")
                                .font(.system(size: 24))
                                .foregroundColor(.blue)
                        }
                        
//                        Text("Restore Contacts")
//                            .font(.subheadline)
//                            .foregroundColor(.primary)
                        Text(LocalizedStrings.string(for: "Restore Contacts", language: languageManager.currentLanguage))
                            .font(.subheadline)
                            .foregroundColor(.primary)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 15)
            .padding(.bottom, 10)
            
            if isLoading {
                // Loading indicator
                ProgressView("Loading contacts...")
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if permissionDenied {
                // Permission denied view
                VStack(spacing: 20) {
                    Image(systemName: "person.crop.circle.badge.exclamationmark")
                        .font(.system(size: 48))
                        .foregroundColor(.gray)
                    
                    Text("Contacts Access Required")
                        .font(.headline)
                    
                    Text("Please allow access to your contacts to use this feature.")
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Button("Open Settings") {
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url)
                        }
                    }
                    .foregroundColor(.blue)
                    .padding(.top, 10)
                }
                .padding()
            } else {
                // Selected count and deselect button
                HStack {
                    let totalDuplicates = duplicateGroups.values.filter { $0.count > 1 }.count
                    
//                    Text("\(selectedContacts.count) Duplicates Contacts selected")
//                        .font(.subheadline)
//                        .foregroundColor(.gray)
                    Text("\(selectedContacts.count) \(LocalizedStrings.string(for: "Duplicates Contacts selected", language: languageManager.currentLanguage))")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Spacer()
                    if !selectedContacts.isEmpty {
                        Button(LocalizedStrings.string(for: "Deselect All", language: languageManager.currentLanguage)) {
                            selectedContacts.removeAll()
                        }
                        .font(.subheadline)
                        .foregroundColor(.blue)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                
                // Contacts list
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(Array(duplicateGroups.keys), id: \.self) { name in
                            if let contacts = duplicateGroups[name], contacts.count > 1 {
                                ContactDuplicateGroup(
                                    name: name,
                                    contacts: contacts,
                                    selectedContacts: $selectedContacts
                                )
                                Divider()
                            }
                        }
                    }
                    .padding(.bottom, !selectedContacts.isEmpty ? 80 : 20)
                }
                
                // Bottom action buttons - Only show when contacts are selected
                if !selectedContacts.isEmpty {
                    HStack(spacing: 16) {
                        // Merge Contacts Button
                        Button(action: {
                            mergeSelectedContacts()
                        }) {
                            Text(LocalizedStrings.string(for: "Merge Contacts", language: languageManager.currentLanguage))
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.vertical, 12)
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .cornerRadius(8)
                        }
                        
                        // Delete Contacts Button
                        Button(action: {
                            deleteSelectedContacts()
                        }) {
                            Text(LocalizedStrings.string(for: "Delete Contacts", language: languageManager.currentLanguage))
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.blue)
                                .padding(.vertical, 12)
                                .frame(maxWidth: .infinity)
                                .background(Color.white)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.blue, lineWidth: 1)
                                )
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                    .transition(.opacity)
                    .animation(.easeInOut, value: !selectedContacts.isEmpty)
                }
            }
        }
        .onAppear {
            requestContactsAccess()
        }
        .alert("Backup Successful", isPresented: $showBackupSuccessAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Your contacts have been successfully backed up.")
        }
        .alert("Restore Successful", isPresented: $showRestoreSuccessAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Your contacts have been successfully restored.")
        }
        .alert("Error", isPresented: $showErrorAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
    
    // MARK: - Contact Access and Fetching
    
    private func requestContactsAccess() {
        isLoading = true
        
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .authorized:
            fetchContacts()
        case .notDetermined:
            CNContactStore().requestAccess(for: .contacts) { granted, _ in
                DispatchQueue.main.async {
                    if granted {
                        fetchContacts()
                    } else {
                        permissionDenied = true
                        isLoading = false
                    }
                }
            }
        default:
            DispatchQueue.main.async {
                permissionDenied = true
                isLoading = false
            }
        }
    }
    
    private func fetchContacts() {
        DispatchQueue.global(qos: .userInitiated).async {
            let contactStore = CNContactStore()
            let keysToFetch: [CNKeyDescriptor] = [
                CNContactGivenNameKey as CNKeyDescriptor,
                CNContactFamilyNameKey as CNKeyDescriptor,
                CNContactPhoneNumbersKey as CNKeyDescriptor,
                CNContactThumbnailImageDataKey as CNKeyDescriptor,
                CNContactIdentifierKey as CNKeyDescriptor
            ]
            
            // Get all contacts
            var contacts: [CNContact] = []
            let request = CNContactFetchRequest(keysToFetch: keysToFetch)
            do {
                try contactStore.enumerateContacts(with: request) { contact, _ in
                    contacts.append(contact)
                }
                
                // Group contacts by name to find duplicates
                var duplicateGroups: [String: [CNContact]] = [:]
                
                for contact in contacts {
                    let fullName = "\(contact.givenName) \(contact.familyName)".trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    // Skip contacts with no name
                    guard !fullName.isEmpty else { continue }
                    
                    if duplicateGroups[fullName] != nil {
                        duplicateGroups[fullName]?.append(contact)
                    } else {
                        duplicateGroups[fullName] = [contact]
                    }
                }
                
                DispatchQueue.main.async {
                    self.duplicateGroups = duplicateGroups
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.errorMessage = "Error fetching contacts: \(error.localizedDescription)"
                    self.showErrorAlert = true
                    print("Error fetching contacts: \(error)")
                }
            }
        }
    }
    
    // MARK: - Backup and Restore Functionality
    
    private func backupContacts() {
        isLoading = true
        
        DispatchQueue.global(qos: .userInitiated).async {
            let contactStore = CNContactStore()
            let keysToFetch: [CNKeyDescriptor] = [
                CNContactGivenNameKey as CNKeyDescriptor,
                CNContactFamilyNameKey as CNKeyDescriptor,
                CNContactPhoneNumbersKey as CNKeyDescriptor,
                CNContactIdentifierKey as CNKeyDescriptor
            ]
            
            // Get all contacts with essential details
            var contacts: [CNContact] = []
            let request = CNContactFetchRequest(keysToFetch: keysToFetch)
            
            do {
                try contactStore.enumerateContacts(with: request) { contact, _ in
                    contacts.append(contact)
                }
                
                // Instead of archiving the contacts directly, extract essential data
                var contactsData: [[String: Any]] = []
                
                for contact in contacts {
                    var contactDict: [String: Any] = [
                        "givenName": contact.givenName,
                        "familyName": contact.familyName,
                        "identifier": contact.identifier
                    ]
                    
                    // Store phone numbers
                    var phoneNumbers: [[String: String]] = []
                    for phoneNumber in contact.phoneNumbers {
                        phoneNumbers.append([
                            "label": phoneNumber.label ?? CNLabelHome,
                            "value": phoneNumber.value.stringValue
                        ])
                    }
                    contactDict["phoneNumbers"] = phoneNumbers
                    
                    contactsData.append(contactDict)
                }
                
                // Save this dictionary to UserDefaults
                UserDefaults.standard.set(contactsData, forKey: "ContactsBackupData")
                
                // Save the backup date
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
                let dateString = dateFormatter.string(from: Date())
                UserDefaults.standard.set(dateString, forKey: "LastContactsBackupDate")
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.showBackupSuccessAlert = true
                }
            } catch {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.errorMessage = "Error backing up contacts: \(error.localizedDescription)"
                    self.showErrorAlert = true
                    print("Error backing up contacts: \(error)")
                }
            }
        }
    }
    
    private func restoreContacts() {
        // First check if we have a backup
        guard let lastBackupDate = UserDefaults.standard.string(forKey: "LastContactsBackupDate"),
              let contactsData = UserDefaults.standard.array(forKey: "ContactsBackupData") as? [[String: Any]] else {
            errorMessage = "No backup found to restore"
            showErrorAlert = true
            return
        }
        
        isLoading = true
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                // Create new contacts from the backup data
                let contactStore = CNContactStore()
                let saveRequest = CNSaveRequest()
                
                for contactDict in contactsData {
                    let newContact = CNMutableContact()
                    
                    // Set basic properties
                    if let givenName = contactDict["givenName"] as? String {
                        newContact.givenName = givenName
                    }
                    
                    if let familyName = contactDict["familyName"] as? String {
                        newContact.familyName = familyName
                    }
                    
                    // Add phone numbers
                    if let phoneNumbers = contactDict["phoneNumbers"] as? [[String: String]] {
                        for phoneNumber in phoneNumbers {
                            if let label = phoneNumber["label"], let value = phoneNumber["value"] {
                                let phoneNumberValue = CNPhoneNumber(stringValue: value)
                                let labeledValue = CNLabeledValue(label: label, value: phoneNumberValue)
                                newContact.phoneNumbers.append(labeledValue)
                            }
                        }
                    }
                    
                    // Add the contact
                    saveRequest.add(newContact, toContainerWithIdentifier: nil)
                }
                
                // Save the changes
                try contactStore.execute(saveRequest)
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.showRestoreSuccessAlert = true
                    // Refresh the contacts list
                    self.fetchContacts()
                }
            } catch {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.errorMessage = "Error restoring contacts: \(error.localizedDescription)"
                    self.showErrorAlert = true
                    print("Error restoring contacts: \(error)")
                }
            }
        }
    }
    
    // MARK: - Merge and Delete Functionality
    
    private func mergeSelectedContacts() {
        // Group selected contacts by name
        var contactsToMergeByName: [String: [CNContact]] = [:]
        
        for contactID in selectedContacts {
            // Find the contact with this ID
            for (name, contacts) in duplicateGroups {
                if let contact = contacts.first(where: { $0.identifier == contactID }) {
                    if contactsToMergeByName[name] != nil {
                        contactsToMergeByName[name]?.append(contact)
                    } else {
                        contactsToMergeByName[name] = [contact]
                    }
                }
            }
        }
        
        // For each group of contacts with the same name
        for (name, contacts) in contactsToMergeByName {
            if contacts.count > 1 {
                // Perform the merge
                mergeContacts(name: name, contacts: contacts)
            }
        }
        
        // Clear selections after merging
        selectedContacts.removeAll()
        
        // Refresh the contacts list after merging
        fetchContacts()
    }
    
    private func mergeContacts(name: String, contacts: [CNContact]) {
        let contactStore = CNContactStore()
        let saveRequest = CNSaveRequest()
        
        guard !contacts.isEmpty else { return }
        
        // Create a mutable copy of the first contact to use as the base
        guard let firstContact = contacts.first,
              let mutableContact = firstContact.mutableCopy() as? CNMutableContact else {
            return
        }
        
        // Collect all unique phone numbers from all contacts
        var allPhoneNumbers = Set<String>()
        for contact in contacts {
            for phoneNumber in contact.phoneNumbers {
                allPhoneNumbers.insert(phoneNumber.value.stringValue)
            }
        }
        
        // Clear existing phone numbers and add all unique ones
        mutableContact.phoneNumbers.removeAll()
        for phoneNumber in allPhoneNumbers {
            let phoneNumberValue = CNPhoneNumber(stringValue: phoneNumber)
            let labeledValue = CNLabeledValue(label: CNLabelHome, value: phoneNumberValue)
            mutableContact.phoneNumbers.append(labeledValue)
        }
        
        // Update the base contact
        saveRequest.update(mutableContact)
        
        // Delete the other duplicate contacts (skip the first one which we kept)
        for i in 1..<contacts.count {
            if let contactToDelete = contacts[i].mutableCopy() as? CNMutableContact {
                saveRequest.delete(contactToDelete)
            }
        }
        
        // Save the changes
        do {
            try contactStore.execute(saveRequest)
            
            // Success - update UI or show confirmation
            DispatchQueue.main.async {
                // Show a success message or update UI
                print("Successfully merged \(contacts.count) contacts")
                
                // Refresh contacts list
                self.fetchContacts()
            }
        } catch {
            // Handle error
            DispatchQueue.main.async {
                self.errorMessage = "Error merging contacts: \(error.localizedDescription)"
                self.showErrorAlert = true
                print("Error merging contacts: \(error)")
            }
        }
    }
    
    private func deleteSelectedContacts() {
        let contactStore = CNContactStore()
        let saveRequest = CNSaveRequest()
        
        for contactID in selectedContacts {
            // Find the contact with this ID in our duplicate groups
            for (_, contacts) in duplicateGroups {
                if let contact = contacts.first(where: { $0.identifier == contactID }),
                   let mutableContact = contact.mutableCopy() as? CNMutableContact {
                    // Delete the contact
                    saveRequest.delete(mutableContact)
                }
            }
        }
        
        // Save the changes
        do {
            try contactStore.execute(saveRequest)
            
            // Success - update UI or show confirmation
            print("Successfully deleted contacts")
            
            // Clear selections after deleting
            selectedContacts.removeAll()
            
            // Refresh contacts list
            fetchContacts()
        } catch {
            // Handle error
            DispatchQueue.main.async {
                self.errorMessage = "Error deleting contacts: \(error.localizedDescription)"
                self.showErrorAlert = true
                print("Error deleting contacts: \(error)")
            }
        }
    }
}

struct ContactDuplicateGroup: View {
    let name: String
    let contacts: [CNContact]
    @Binding var selectedContacts: Set<String>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            // Group header
            Text(name)
                .font(.headline)
                .padding(.horizontal, 16)
                .padding(.top, 12)
            
            // List of duplicate contacts
            ForEach(contacts, id: \.identifier) { contact in
                ContactRow(
                    contact: contact,
                    isSelected: selectedContacts.contains(contact.identifier),
                    onTap: { toggleSelection(contact: contact) }
                )
                
                if contact.identifier != contacts.last?.identifier {
                    Divider()
                        .padding(.leading, 68) // Indent divider to align with content
                }
            }
            .padding(.bottom, 8)
        }
        .background(Color.gray.opacity(0.05))
    }
    
    private func toggleSelection(contact: CNContact) {
        if selectedContacts.contains(contact.identifier) {
            selectedContacts.remove(contact.identifier)
        } else {
            selectedContacts.insert(contact.identifier)
        }
    }
}

//struct ContactRow: View {
//    let contact: CNContact
//    let isSelected: Bool
//    let onTap: () -> Void
//    
//    var body: some View {
//        Button(action: onTap) {
//            HStack(spacing: 12) {
//                // Contact avatar
//                if let thumbnailData = contact.thumbnailImageData, let uiImage = UIImage(data: thumbnailData) {
//                    Image(uiImage: uiImage)
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                        .frame(width: 40, height: 40)
//                        .clipShape(Circle())
//                } else {
//                    // Default avatar
//                    Circle()
//                        .fill(Color.gray.opacity(0.2))
//                        .frame(width: 40, height: 40)
//                        .overlay(
//                            Image(systemName: "person.fill")
//                                .foregroundColor(.gray)
//                        )
//                }
//                
//                // Contact details
//                VStack(alignment: .leading, spacing: 2) {
//                    // Only showing the phone numbers
//                    if let phoneNumber = contact.phoneNumbers.first?.value.stringValue {
//                        Text(phoneNumber)
//                            .font(.system(size: 16))
//                            .foregroundColor(.primary)
//                    }
//                }
//                
//                Spacer()
//                
//                // Selection indicator
//                ZStack {
//                    RoundedRectangle(cornerRadius: 4)
//                        .fill(isSelected ? Color.blue : Color.clear)
//                        .frame(width: 20, height: 20)
//                    
//                    if isSelected {
//                        Image(systemName: "checkmark")
//                            .foregroundColor(.white)
//                            .font(.system(size: 12, weight: .bold))
//                    } else {
//                        RoundedRectangle(cornerRadius: 4)
//                            .strokeBorder(Color.gray, lineWidth: 1)
//                            .frame(width: 20, height: 20)
//                    }
//                }
//            }
//            .padding(.vertical, 12)
//            .padding(.horizontal, 16)
//        }
//        .buttonStyle(PlainButtonStyle())
//    }
//}
struct ContactRow: View {
    let contact: CNContact
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            // Contact avatar
            if let thumbnailData = contact.thumbnailImageData,
               let uiImage = UIImage(data: thumbnailData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
            } else {
                Circle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Image(systemName: "person.fill")
                            .foregroundColor(.gray)
                    )
            }

            // Contact details
            VStack(alignment: .leading, spacing: 2) {
                if let phoneNumber = contact.phoneNumbers.first?.value.stringValue {
                    Text(phoneNumber)
                        .font(.system(size: 16))
                        .foregroundColor(.primary)
                }
            }

            Spacer()

            // Selection checkbox
            ZStack {
                RoundedRectangle(cornerRadius: 4)
                    .fill(isSelected ? Color.blue : Color.clear)
                    .frame(width: 20, height: 20)

                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(.white)
                        .font(.system(size: 12, weight: .bold))
                } else {
                    RoundedRectangle(cornerRadius: 4)
                        .strokeBorder(Color.gray, lineWidth: 1)
                        .frame(width: 20, height: 20)
                }
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .contentShape(Rectangle()) // 🔹 Makes the entire HStack tappable
        .onTapGesture {
            onTap()
        }
    }
}
