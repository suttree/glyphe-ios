import WidgetKit
import SwiftUI

struct IconWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> IconEntry {
        return IconEntry(date: Date(), icon1: "default_icon", icon2: "default_icon")
    }

    func getSnapshot(in context: Context, completion: @escaping (IconEntry) -> Void) {
        let entry = IconEntry(date: Date(), icon1: "default_icon", icon2: "default_icon")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<IconEntry>) -> Void) {
        var entries: [IconEntry] = []

        // Replace "icons" with the actual folder name in your project
        if let iconFolderURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            do {
                let iconURLs = try FileManager.default.contentsOfDirectory(at: iconFolderURL, includingPropertiesForKeys: nil)
                let shuffledIcons = iconURLs.shuffled()
                
                if shuffledIcons.count >= 2 {
                    let icon1 = shuffledIcons[0].lastPathComponent
                    let icon2 = shuffledIcons[1].lastPathComponent
                    
                    let entry = IconEntry(date: Date(), icon1: icon1, icon2: icon2)
                    entries.append(entry)
                }
            } catch {
                // Handle any errors while accessing or loading icons
                print("Error loading icons: \(error)")
            }
        }

        // Update the widget every 3 hours (adjust the refresh rate as needed)
        let refreshDate = Calendar.current.date(byAdding: .hour, value: 3, to: Date()) ?? Date()
        let timeline = Timeline(entries: entries, policy: .after(refreshDate))
        completion(timeline)
    }
}
