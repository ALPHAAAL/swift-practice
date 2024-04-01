import SwiftUI
import WidgetKit

let defaults = UserDefaults(suiteName: "group.com.Progress-Tracker.widgetdata")!

struct HomePage: View {
    // Define a variable to store the number of days
    @State private var startDate = defaults.object(forKey: "startDate") as? Date ?? Date()
    @State private var daysCount = 0
    @State private var eventName = defaults.string(forKey: "eventName") ?? "Marriage"
    
    var body: some View {
        VStack {
            Text("Days Since")
                .font(.custom("Helvetica Neue", size: 50))
                .foregroundColor(Color("TitleTextColor"))
                .padding(.bottom, 20)
            Text(eventName)
                .font(.title2)
                .foregroundColor(Color("TitleTextColor"))
                .padding(.bottom, 50)
            Text("\(daysCount)")
                .font(.custom("Helvetica Neue", size: 100))
                .foregroundColor(Color("TitleTextColor"))
                .padding(.bottom, 40)

            
            DatePickerView(startDate: $startDate)
                .onChange(of: startDate) { _ in
                    defaults.set(startDate, forKey: "startDate")
                    defaults.synchronize()
                    updateDaysCount()
                    WidgetCenter.shared.reloadTimelines(ofKind: "Progress_Widget")
                    NotificationCenter.default.post(name: Notification.Name("EventUpdatedNotification"), object: nil, userInfo: ["eventName": eventName, "daysCount": daysCount])
                }

            NameInputView(eventName: $eventName)
                .padding(.vertical)
                .onChange(of: eventName) { _ in
                    defaults.set(eventName, forKey: "eventName")
                    defaults.synchronize()
                    WidgetCenter.shared.reloadTimelines(ofKind: "Progress_Widget")
                    NotificationCenter.default.post(name: Notification.Name("EventUpdatedNotification"), object: nil, userInfo: ["eventName": eventName, "daysCount": daysCount])
                }
            
            // Button to reset the count
            Button(action: {
                daysCount = 0
                defaults.set(Date(), forKey: "startDate")
            }) {
                Text("Reset")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.bottom, 50)
        }
        .onAppear {
            // Calculate the number of days
            updateDaysCount()
        }
    }
    
    private func updateDaysCount() {
        let calendar = Calendar.current
        let currentDate = calendar.startOfDay(for: Date())
        let startDate = calendar.startOfDay(for: self.startDate)
        let components = calendar.dateComponents([.day], from: startDate, to: currentDate)
        daysCount = components.day ?? 0
    }
}

struct DatePickerView: View {
    @Binding var startDate: Date
    
    var body: some View {
        HStack(spacing: 10) {
            Text("Start Date")
                .font(.headline)
            DatePicker("", selection: $startDate, displayedComponents: .date)
                .font(.headline)
                .font(.custom("Montserrat-Regular", size: 16))
                .padding()
        }
        .padding(.horizontal)
    }
}

struct NameInputView: View {
    @Binding var eventName: String
    
    var body: some View {
        HStack(spacing: 10) {
            Text("Event Name")
                .font(.headline)
            TextField("Enter event name", text: $eventName)
                .font(.custom("Montserrat-Regular", size: 16))
                .padding(.vertical, 5)
                .padding(.horizontal, 10)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
        }
        .padding(.horizontal)
    }
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
