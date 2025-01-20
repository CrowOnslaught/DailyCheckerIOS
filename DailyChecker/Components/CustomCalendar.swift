//
//  CustomCalendar.swift
//  DailyChecker
//
//  Created by Jaume García on 7/1/25.
//

import SwiftUI
import SwiftData
import HorizonCalendar

struct CustomCalendar: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) var colorScheme
    
    let startDate: Date
    
    @State private var selectedDate: Int?
    @State private var showingConfirmation = false
    @Query private var items: [Item]
    
    var didCheckToday: Bool {
        (items.first(where: {$0.timestamp.isToday()}) != nil)
    }
    
    private let calendar = Calendar.current
    private let today: DateComponents
    private let endDate = Date()

    init(startDate: Date = Date()) {
        self.startDate = startDate
        
        let t = Date()
        self.today = calendar.dateComponents([.day, .month, .year], from: t as Date)
    }
    
    private var actionButton: some View {
        Button {
            self.showingConfirmation = true
        } label: {
            Text(didCheckToday ? "Checked!" : "Check today")
                .font(.system(size: 20))
                .foregroundStyle(Color.white)
                .fontWeight(.black)
                .textCase(.uppercase)
                .padding(.top, 32)
                .frame(maxWidth: .infinity, alignment: .center)
                .background(didCheckToday ? Color.gray.gradient : Color.mint.gradient)
        }
        .disabled(didCheckToday)
    }
   
    var body: some View {
        VStack {            
            CalendarViewRepresentable(
                calendar: calendar,
                visibleDateRange: startDate...endDate,
                monthsLayout: .vertical(
                    options: VerticalMonthsLayoutOptions()
                ),
                dataDependency: nil
            )
            .days { day in
                ZStack {
                    Text("\(day.day)")
                        .foregroundStyle(dayColor(day.components))
                        .fontWeight(dayWeight(day.components))
                        .onTapGesture {
                            print(day.day)
                            withAnimation {
                                if selectedDate == day.day {
                                    self.selectedDate = nil
                                } else {
                                    self.selectedDate = day.day
                                }
                            }
                        }

                    if selectedDate == day.day, let date = items.first(where: {day.components.isSameDay(of: $0.timestamp)}) {
                        Text(date.timestamp.formatDate("dd/MM"))
                            .offset(y: 16)
                    }
                }
                   
            }
            .layoutMargins(.init(top: 8, leading: 8, bottom: 8, trailing: 8))
           .padding(.horizontal, 16)

            Text("\(self.selectedDate ?? 0)")
            
            if didCheckToday {
                Text("CHECK!")
                    .help("check")
            }
            
            ForEach(items, id: \.id) { item in
                Text(item.timestamp.formatDate("hh:mm a"))
                    .padding()
                    .background(item.timestamp.isToday() ? Color.mint : Color.blue)
            }
            
            actionButton
        }
        .confirmationDialog("Confirm today's check", isPresented: $showingConfirmation) {
            Button("Confirm") { onConfirm() }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Confirm today's check")
        }
    }
}

extension CustomCalendar {
    private func onConfirm() {
        modelContext.insert(Item(timestamp: Date()))
    }

    private func dayColor(_ day: DateComponents) -> Color {
        if day > today {
            return .gray
        } else if day < today {
            return colorScheme == .dark ? .white : .black
        } else {
            return .mint
        }
    }

    private func dayWeight (_ day: DateComponents) -> Font.Weight {
        if day > today || day < today {
            return .thin
        }

        return .black
    }
}

#Preview {
    CustomCalendar()
        .modelContainer(for: Item.self, inMemory: true)
}
