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

    @State private var showingConfirmation = false
    
    private let calendar = Calendar.current
    private let today: DateComponents
    private let endDate = Date()

    init(startDate: Date = Date()) {
        self.startDate = startDate
        
        let t = Date()
        self.today = calendar.dateComponents([.day, .month, .year], from: t as Date)
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
                Text("\(day.day)")
                    .foregroundStyle(dayColor(day.components))
                    .fontWeight(dayWeight(day.components))
                    .onTapGesture {
                        print(day.day)
                    }
            }
            .layoutMargins(.init(top: 8, leading: 8, bottom: 8, trailing: 8))
           .padding(.horizontal, 16)
           .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Button {
                self.showingConfirmation = true
            } label: {
                Text("Check today")
                    .font(.system(size: 20))
                    .foregroundStyle(Color.white)
                    .fontWeight(.black)
                    .textCase(.uppercase)
                    .padding(.top, 32)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(Color.mint)
            }
        }
        .confirmationDialog("Confirm today's check", isPresented: $showingConfirmation) {
            Button("Confirm") { onConfirm() }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Confirm today's check")
        }
    }
            
    private func onConfirm() {
        modelContext.insert(Item(timestamp: Date()))
    }
    
    private func dayColor(_ day: DateComponents) -> Color {
        if day > today {
            return .gray
        } else if day < today {
            return colorScheme == .dark ? .white : .black
        } else {
            return .blue
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

extension Date {
    var hour: Int { Calendar.current.component(.hour, from: self) }
    var minute: Int { Calendar.current.component(.minute, from: self) }
    
    func formatDate(_ format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func isSameDay(of otherDate: Date) -> Bool {
        let components = Calendar.current.dateComponents([.day, .year, .month], from: self)
        let otherDateComponents = Calendar.current.dateComponents([.day, .year, .month], from: otherDate)

        return (components.day == otherDateComponents.day && components.month == otherDateComponents.month && components.year == otherDateComponents.year)
    }
    func isToday() -> Bool {
        return isSameDay(of: Date())
    }
}

extension DateComponents: @retroactive Comparable {
    public static func < (lhs: DateComponents, rhs: DateComponents) -> Bool {
        let now = Date()
        let calendar = Calendar.current
        return calendar.date(byAdding: lhs, to: now)! < calendar.date(byAdding: rhs, to: now)!
    }
}
