//
//  DAUWidgetExtension.swift
//  DAUWidgetExtension
//
//  Created by Francesco Vezzani on 23/06/24.
//

import WidgetKit
import SwiftUI

struct DAUWidgetEntry: TimelineEntry {
    let date: Date
    let sessions: Int
    let locales: [String: Int]
    let logs: [LogEvent]
}

struct DAUProvider: TimelineProvider {
    func placeholder(in context: Context) -> DAUWidgetEntry {
        DAUWidgetEntry(date: Date(), sessions: 0, locales: [:], logs: [])
    }
    
    func getSnapshot(in context: Context, completion: @escaping (DAUWidgetEntry) -> Void) {
        let entry = DAUWidgetEntry(date: Date(), sessions: 0, locales: [:], logs: [])
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<DAUWidgetEntry>) -> Void) {
        NetworkManager.shared.fetchDAUData { result in
            var entries: [DAUWidgetEntry] = []
            
            switch result {
            case .success(let data):
                let entry = DAUWidgetEntry(date: Date(), sessions: data.sessions, locales: data.locales, logs: data.logs)
                entries.append(entry)
                
            case .failure(let error):
                print("Error fetching data: \(error.localizedDescription)")
                let entry = DAUWidgetEntry(date: Date(), sessions: 0, locales: [:], logs: [])
                entries.append(entry)
            }
            
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
    }
}

struct DAUWidgetView: View {
    var entry: DAUProvider.Entry
    
    var body: some View {
        HStack {
            ChartView(forLocales: entry.locales, chartType: .horizontalBar)
            VStack{
                Text("Today")
                    .font(.headline)
                Spacer()
                Text("Country: \(entry.locales.count)")
                    .font(.subheadline)
                Spacer()
                Text("Sessions: \(entry.sessions)")
                    .font(.subheadline)
                Spacer()
                Text("Logs: \(entry.logs.count)")
                    .font(.subheadline)
            }
        }.widgetBackground(Color.clear)
    }
}
extension View {
    func widgetBackground(_ backgroundView: some View) -> some View {
        if #available(iOSApplicationExtension 17.0, *) {
            return containerBackground(for: .widget) {
                backgroundView
            }
        } else {
            return background(backgroundView)
        }
    }
}


@main
struct DAUWidget: Widget {
    let kind: String = "DAUWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: DAUProvider()) { entry in
            DAUWidgetView(entry: entry)
        }
        .configurationDisplayName("DAU Widget")
        .description("Displays the number of active users and a list of locales.")
    }
}
