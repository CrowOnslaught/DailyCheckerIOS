//
//  CustomTimePicker.swift
//  DailyChecker
//
//  Created by Jaume García on 7/1/25.
//

import SwiftUI

struct CustomTimePicker: View {
    @Binding var notifTime: Date
    @State private var isEnabled: Bool = false
    
    @State private var showAlert: Bool = false
    private let NOTIF_ID = "dailyCheckerNotification"

    var body: some View {
        VStack {
            Label("set daily reminder", systemImage: "clock")
                HStack(spacing: 16) {
                    Toggle("enabled", isOn: $isEnabled)
                        .toggleStyle(.switch)
                    DatePicker(
                        "time", selection: $notifTime,
                        displayedComponents: .hourAndMinute
                    )
                    .datePickerStyle(.wheel)
                }
                .labelsHidden()
        }
        .padding()
        .onChange(of: notifTime, { scheduleLocalNotification() })
        .onChange(of: isEnabled, {
            scheduleLocalNotification()
        })
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(isEnabled ?
                            "Reminder set for \(notifTime, format: Date.FormatStyle(date: .omitted, time: .shortened))" : "Reminder disabled"
                           )
            )
        }
    }
    
    func scheduleLocalNotification() {
        guard isEnabled else {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [NOTIF_ID])
            return
        }
        
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            if settings.authorizationStatus == UNAuthorizationStatus.authorized {
                //contents
                let content = UNMutableNotificationContent()
                    content.title = "Daily reminder"
                    content.body = "Check your pills"
                    content.sound = UNNotificationSound.default
                
                //trigger
                let dateInfo = Calendar.current.dateComponents([.hour,.minute], from: self.notifTime)
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: true)
                //request
                let request = UNNotificationRequest(identifier: NOTIF_ID, content: content, trigger: trigger)

                let notificationCenter = UNUserNotificationCenter.current()

                notificationCenter.add(request) { (error) in
                   if error != nil{
                      print("error in notification! ")
                   }
                }
                
                self.showAlert = true
              }
              else {
                  print("user denied")
              }
          }
    }
}

#Preview {
    CustomTimePicker(notifTime: .constant(Date()))
}
