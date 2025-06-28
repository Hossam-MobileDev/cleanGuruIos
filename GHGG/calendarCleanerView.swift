//
//  calendarCleanerView.swift
//  GHGG
//
//  Created by test on 17/05/2025.
//

import SwiftUI
import EventKit

struct CalendarItem: Identifiable {
    let id = UUID()
    let name: String
    let date: String
    let time: String
    var isSelected: Bool = true
}

struct CalendarCleanerView: View {
    // EventKit event store for calendar access
    private let eventStore = EKEventStore()
    
    // State variables
    @State private var calendarEvents: [EKEvent] = []
    @State private var selectedEventIds: Set<String> = []
    @State private var isLoading = true
    @State private var showPermissionAlert = false
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    @State private var isDeleting = false
    @EnvironmentObject var languageManager: LanguageManager

    // Computed properties
    var selectedCount: Int {
        return selectedEventIds.count
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Selected count and deselect button
            HStack {
//                Text("\(selectedCount) Old events selected")
//                    .font(.subheadline)
//                    .foregroundColor(.gray)
                Spacer()
                Button(LocalizedStrings.string(for: "Deselect All", language: languageManager.currentLanguage)) {
                    selectedEventIds.removeAll()
                }
               
                .font(.subheadline)
                .foregroundColor(.blue)
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            
            if isLoading {
                // Loading indicator
                VStack {
                    ProgressView()
                        .padding()
                    Text("Loading events...")
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                // Calendar items list
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(calendarEvents, id: \.eventIdentifier) { event in
                            CalendarEventRow(
                                event: event,
                                isSelected: selectedEventIds.contains(event.eventIdentifier),
                                onToggle: { toggleEventSelection(event: event) }
                            )
                            Divider()
                        }
                    }
                    .padding(.bottom, 100) // Add some space at the bottom
                }
                
                // Delete button
                Spacer()
                Button(action: {
                    deleteSelectedEvents()
                }) {
                    if isDeleting {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 15)
                            .background(Color.blue)
                            .cornerRadius(8)
                    } else {
                        let removeFormat = LocalizedStrings.string(
                            for: "Remove Events Count",
                            language: languageManager.currentLanguage
                        )
                        Text(String(format: removeFormat, "\(selectedCount)"))
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 15)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                }

                .disabled(selectedCount == 0 || isDeleting)
                .opacity(selectedCount == 0 ? 0.6 : 1.0)
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
        }
        .onAppear {
            requestCalendarAccess()
        }
        .alert("Permission Required", isPresented: $showPermissionAlert) {
            Button("Open Settings", role: .destructive) {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This app needs permission to access your calendar to help clean up old events.")
        }
        .alert("Error", isPresented: $showErrorAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
    
    // Request calendar access
    private func requestCalendarAccess() {
        isLoading = true
        
        // For iOS 17+, use the async requestFullAccessToEvents method
        if #available(iOS 17.0, *) {
            Task {
                do {
                    let granted = try await eventStore.requestFullAccessToEvents()
                    if granted {
                        await fetchCalendarEvents()
                    } else {
                        await MainActor.run {
                            isLoading = false
                            showPermissionAlert = true
                        }
                    }
                } catch {
                    await MainActor.run {
                        isLoading = false
                        errorMessage = "Error requesting calendar access: \(error.localizedDescription)"
                        showErrorAlert = true
                    }
                }
            }
        } else {
            // Older iOS versions use the completion handler version
            eventStore.requestAccess(to: .event) { (granted, error) in
                DispatchQueue.main.async {
                    if let error = error {
                        self.isLoading = false
                        self.errorMessage = "Error requesting calendar access: \(error.localizedDescription)"
                        self.showErrorAlert = true
                        return
                    }
                    
                    if granted {
                        self.fetchCalendarEvents()
                    } else {
                        self.isLoading = false
                        self.showPermissionAlert = true
                    }
                }
            }
        }
    }
    
    // Fetch events from the user's calendars
    private func fetchCalendarEvents() {
        // Create a date range for old events (e.g., older than 6 months)
        let endDate = Date() // Today
        let startDate = Calendar.current.date(byAdding: .month, value: -6, to: endDate)! // 6 months ago
        
        // Create a predicate for old events
        let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)
        
        // Fetch the events
        let events = eventStore.events(matching: predicate)
        
        // Sort events by date
        let sortedEvents = events.sorted { $0.startDate > $1.startDate }
        
        DispatchQueue.main.async {
            self.calendarEvents = sortedEvents
            self.isLoading = false
        }
    }
    
    // Toggle event selection
    private func toggleEventSelection(event: EKEvent) {
        if selectedEventIds.contains(event.eventIdentifier) {
            selectedEventIds.remove(event.eventIdentifier)
        } else {
            selectedEventIds.insert(event.eventIdentifier)
        }
    }
    
    // Delete selected events - simplified version to avoid concurrency issues
    private func deleteSelectedEvents() {
        guard !selectedEventIds.isEmpty else { return }
        
        isDeleting = true
        
        // For each selected event ID, find the event and delete it
        var hadError = false
        
        for eventId in selectedEventIds {
            if let eventToRemove = eventStore.event(withIdentifier: eventId) {
                do {
                    try eventStore.remove(eventToRemove, span: .thisEvent, commit: false)
                } catch {
                    hadError = true
                    print("Error removing event: \(error)")
                }
            }
        }
        
        // Commit all changes at once
        do {
            try eventStore.commit()
            
            if hadError {
                errorMessage = "Some events could not be deleted."
                showErrorAlert = true
            }
            selectedEventIds.removeAll()
            fetchCalendarEvents()
            isDeleting = false
        } catch {
            isDeleting = false
            errorMessage = "Error deleting events: \(error.localizedDescription)"
            showErrorAlert = true
        }
    }
}

// Calendar Event Row
struct CalendarEventRow: View {
    let event: EKEvent
    let isSelected: Bool
    let onToggle: () -> Void
    
    var body: some View {
        Button(action: onToggle) {
            HStack(spacing: 12) {
                // Calendar icon
                ZStack {
                    Circle()
                        .fill(Color.blue.opacity(0.1))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: "calendar")
                        .foregroundColor(.blue)
                        .font(.system(size: 18))
                }
                
                // Event details
                VStack(alignment: .leading, spacing: 2) {
                    Text(event.title ?? "Event Name")
                        .font(.system(size: 16))
                        .foregroundColor(.primary)
                    
                    Text(formattedDate)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                // Selection indicator - changed to square checkbox
                ZStack {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(isSelected ? Color.blue : Color.clear)
                        .frame(width: 24, height: 24)
                    
                    if isSelected {
                        Image(systemName: "checkmark")
                            .foregroundColor(.white)
                            .font(.system(size: 12, weight: .bold))
                    } else {
                        RoundedRectangle(cornerRadius: 4)
                            .strokeBorder(Color.gray, lineWidth: 1)
                            .frame(width: 24, height: 24)
                    }
                }
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // Format the date to match the design
    private var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.string(from: event.startDate)
    }
}

// Preview provider
struct CalendarCleanerView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarCleanerView()
    }
}
