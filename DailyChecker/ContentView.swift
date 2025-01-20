//
//  ContentView.swift
//  DailyChecker
//
//  Created by Jaume García on 7/1/25.
//

import SwiftUI
import SwiftData
import UserNotifications

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Namespace private var namespace

    @State private var notifTime: Date = Date()

    private var navigationClock: some View {
        VStack(alignment: .leading, spacing: 4){
            NavigationLink {
                CustomTimePicker(notifTime: $notifTime)
                    .navigationTransition(.zoom(sourceID: "zoom", in: namespace))

            } label: {
                HStack(spacing: 12) {
                    Text(String(format: "%02d", notifTime.hour))
                    Text(String(format: "%02d", notifTime.minute))
                }
                .font(.system(size: 18))
                .fontWeight(.bold)
                .foregroundStyle(Color.primary)
                .frame(maxWidth: .infinity, minHeight: 40)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .matchedTransitionSource(
                    id: "zoom",
                    in: namespace
                )
            }
            .padding(.horizontal, 32)
        }
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            navigationClock
                .padding(.vertical, 120)
            CustomCalendar(startDate: Date())
        }
     
    }
  
}

#Preview {
    NavigationStack {
        ContentView()
            .modelContainer(for: Item.self, inMemory: true)
    }
}


//        NavigationSplitView {
//            List {
//                ForEach(items) { item in
//                    NavigationLink {
//                        Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
//                    } label: {
//                        Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
//                    }
//                }
//                .onDelete(perform: deleteItems)
//            }
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    EditButton()
//                }
//                ToolbarItem {
//                    Button(action: addItem) {
//                        Label("Add Item", systemImage: "plus")
//                    }
//                }
//            }
//        } detail: {
//            Text("Select an item")
//        }
//private func addItem() {
//    withAnimation {
//        let newItem = Item(timestamp: Date())
//        modelContext.insert(newItem)
//    }
//}
//private func deleteItems(offsets: IndexSet) {
//    withAnimation {
//        for index in offsets {
//            modelContext.delete(items[index])
//        }
//    }
//}

