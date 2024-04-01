//
//  Progress_Widget.swift
//  Progress Widget
//
//  Created by AA on 13/4/2023.
//

import WidgetKit
import SwiftUI
import Intents

let defaults = UserDefaults(suiteName: "group.com.Progress-Tracker.widgetdata")!

func getDayCount() -> Int {
    let calendar = Calendar.current
    let currentDate = calendar.startOfDay(for: Date())
    let startDate = calendar.startOfDay(for: defaults.object(forKey: "startDate") as? Date ?? Date())
    let components = calendar.dateComponents([.day], from: startDate, to: currentDate)
    let daysCount = components.day ?? 0
    
    return daysCount
}

struct EventWidgetView: View {
    var entry: EventEntry
    @State var eventName: String = UserDefaults.init(suiteName: "group.com.Progress-Tracker.widgetdata")?.string(forKey: "eventName") ?? "Event Name"
    @State private var startDate = defaults.object(forKey: "startDate") as? Date ?? Date()
    
    var body: some View {
        var daysCount = getDayCount()
        
        VStack(alignment: .leading) {
            Text(eventName)
                .font(.title2)
                .foregroundColor(.red)
            Text("Days since" + ": \(daysCount)")
                .font(.headline)
                .foregroundColor(.red)
        }
        .padding()
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("EventUpdatedNotification"))) { _ in
            self.eventName = UserDefaults.init(suiteName: "group.com.Progress-Tracker.widgetdata")?.string(forKey: "eventName") ?? ""
            self.startDate = (UserDefaults.init(suiteName: "group.com.Progress-Tracker.widgetdata")?.object(forKey: "startDate") as? Date) ?? Date()
            
            print("Received")
            
            daysCount = getDayCount()
        }
    }
}

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> EventEntry {
        EventEntry(date: Date(), daysCount: 0, eventName: "Event Name")
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (EventEntry) -> ()) {
        let entry = EventEntry(date: Date(), daysCount: 0, eventName: "Event Name")
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let eventName = defaults.string(forKey: "eventName") ?? "Event Name"
        let daysCount = getDayCount()
        
        let entry = EventEntry(date: Date(), daysCount: daysCount, eventName: eventName)
        
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct EventEntry: TimelineEntry {
    let date: Date
    var daysCount: Int
    var eventName: String
}

struct Progress_WidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var widgetFamily

    var body: some View {
        switch widgetFamily {
            case .accessoryCircular:
            let eventName = defaults.string(forKey: "eventName") ?? "Event Name"
            
                VStack {
                    Gauge(value: 1.0) {
                        VStack {
                            Text(eventName)
                            Text("\(getDayCount())")
                        }
                    }
                    .gaugeStyle(.accessoryCircularCapacity)
                }
            default:
                EventWidgetView(entry: entry)
        }
    }
}

struct Progress_Widget: Widget {
    let kind: String = "Progress_Widget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            Progress_WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.accessoryCircular, .systemSmall])
    }
}

struct Progress_Widget_Previews: PreviewProvider {
    static var previews: some View {
        Progress_WidgetEntryView(entry: EventEntry(date: Date(), daysCount: 0, eventName: "Event Name"))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .previewDisplayName("Home screen")
        Progress_WidgetEntryView(entry: EventEntry(date: Date(), daysCount: 0, eventName: "Event Name"))
            .previewContext(WidgetPreviewContext(family: .accessoryCircular))
            .previewDisplayName("Lock screen - circular")
    }
}
