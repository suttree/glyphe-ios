import WidgetKit
import SwiftUI

// Core logic
struct RandomIconsEntry: TimelineEntry {
    let date: Date
    let icon1: UIImage
    let icon2: UIImage
}

struct RandomIconsWidgetEntryView: View {
    var entry: RandomIconsEntry

    var body: some View {
        VStack {
            Image(uiImage: entry.icon1)
                .resizable()
                .scaledToFit()
            Image(uiImage: entry.icon2)
                .resizable()
                .scaledToFit()
        }
    }
}

// Data Fetching and Presentation
struct RandomIconsProvider: TimelineProvider {
    typealias Entry = RandomIconsEntry
    
    func placeholder(in context: Context) -> RandomIconsEntry {
        RandomIconsEntry(date: Date(), icon1: UIImage(), icon2: UIImage())
    }

    func getSnapshot(in context: Context, completion: @escaping (RandomIconsEntry) -> ()) {
        let entry = RandomIconsEntry(date: Date(), icon1: UIImage(), icon2: UIImage())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [RandomIconsEntry] = []

        // Fetch two random icons
        let randomIcons = fetchRandomIcons()
        let entry = RandomIconsEntry(date: Date(), icon1: randomIcons.0, icon2: randomIcons.1)

        // Generate a timeline entry for the widget
        entries.append(entry)

        // Customize when the widget should be updated
        let nextUpdateDate = Calendar.current.date(byAdding: .hour, value: 1, to: entry.date)!
        let timeline = Timeline(entries: entries, policy: .after(nextUpdateDate))
        completion(timeline)
    }

    // Function to fetch random icons
    func fetchRandomIcons() -> (UIImage, UIImage) {
        // Assuming you have an array of image names in your 'Icons' folder
        let iconNames = ["noun-leaf-2333282.png", "noun-paint-roller-979605.png", "noun-art-picture-with-heart-4121589.png", "noun-horse-2586809.png"] // Replace with your icon names
        let randomIndexes = iconNames.indices.shuffled().prefix(2)
        let icons = randomIndexes.map { UIImage(named: iconNames[$0]) ?? UIImage() }
        return (icons[0], icons[1])
    }
}
