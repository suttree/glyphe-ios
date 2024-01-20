import Foundation
import WidgetKit
import SwiftUI

// Define the App Group UserDefaults ID
let appGroupUserDefaultsID = "group.com.suttree.smallseasons"

// Core logic
struct SmallSeasonsEntry: Decodable {
    let id: String
    let kanji: String
    let notes: String
    let description: String
    let startDate: String
}

struct Sekki: Decodable {
    let id: String
    let kanji: String
    let notes: String
    let description: String
    let startDate: String
}

struct SeasonsData: Decodable {
    let sekki: [Sekki]
}

enum WidgetSize {
    case small, medium, large
}

func loadSeasonData(for size: WidgetSize) -> (id: String, kanji: String, notes: String?, description: String?) {
    guard let url = Bundle.main.url(forResource: "content", withExtension: "json"),
          let data = try? Data(contentsOf: url),
          let seasonsData = try? JSONDecoder().decode(SeasonsData.self, from: data) else {
        return ("", "", nil, nil)
    }

    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    let currentYear = Calendar.current.component(.year, from: Date())
    let today = Date()  // Use current date

    var mostRecentSeason: Sekki? = nil
    for season in seasonsData.sekki {
        guard let seasonStartDateThisYear = formatter.date(from: "\(currentYear)-\(season.startDate)") else {
            continue
        }

        if seasonStartDateThisYear <= today {
            mostRecentSeason = season
            // Additional break condition when today's date matches the start date of a season
            if formatter.string(from: seasonStartDateThisYear) == formatter.string(from: today) {
                break
            }
        }
    }

    // If no season matches, default to the last season of the previous year
    if mostRecentSeason == nil {
        mostRecentSeason = seasonsData.sekki.last
    }

    guard let season = mostRecentSeason else {
        return ("", "", nil, nil)
    }

    switch size {
    case .small:
        return (season.id, season.kanji, nil, nil)
    case .medium:
        return (season.id, season.kanji, season.notes, nil)
    case .large:
        return (season.id, season.kanji, season.notes, season.description)
    }
}

func textForUserChoice(widgetSize: WidgetSize) -> String {
    switch widgetSize {
    case .small:
        let smallWidgetData = loadSeasonData(for: .small)
        return smallWidgetData.id
    case .medium:
        let mediumWidgetData = loadSeasonData(for: .medium)
        let mediumWidgetText = """
        \(mediumWidgetData.id) \n\
        \(mediumWidgetData.notes ?? "")
        """
        return mediumWidgetText
    case .large:
        let largeWidgetData = loadSeasonData(for: .large)
        let largeWidgetText = """
        \(largeWidgetData.kanji) \n\
        \(largeWidgetData.id) \n\
        \(largeWidgetData.notes ?? "")
        """
        return largeWidgetText
    }
}

struct SmallSeasonsWidgetEntryView: View {
    var entry: SmallSeasonsEntry

    // This environment variable tells us what size the widget is
    @Environment(\.widgetFamily) var widgetFamily

    var body: some View {
            Group {
                switch widgetFamily {
                case .systemSmall:
                    // Small Widget - Show single icon
                    let smallWidgetText = textForUserChoice(widgetSize: .small)

                    Text(smallWidgetText)
                        .font(.system(.body, design: .serif).italic()) // Apply serif font in italic
                        .foregroundColor(Color(white: 0.2)) // Off-black color
                        .multilineTextAlignment(.center) // Center align text
                        .padding(.top, 5) // Optional padding from the image to the text

                case .systemMedium:
                    // Medium Widget - Show 4 icons in a line
                    let mediumWidgetText = textForUserChoice(widgetSize: .medium)
                    
                    Text(mediumWidgetText)
                        .font(.system(.body, design: .serif).italic()) // Apply serif font in italic
                        .foregroundColor(Color(white: 0.2)) // Off-black color
                        .padding(.top, 5) // Optional padding from the image to the text

                case .systemLarge:
                    // Large Widget - Show 4 icons in a 2x2 grid
                    let largeWidgetText = textForUserChoice(widgetSize: .large)
                    
                    Text(largeWidgetText)
                        .font(.system(.body, design: .serif).italic()) // Apply serif font in italic
                        .foregroundColor(Color(white: 0.2)) // Off-black color
                        .padding(.top, 5) // Optional padding from the image to the text
                default:
                    Text("Small seasons")
                        .font(.system(.body, design: .serif).italic()) // Apply serif font in italic
                        .foregroundColor(Color(white: 0.2)) // Off-black color
                        .padding(.top, 5) // Optional padding from the image to the text
            }
        .containerBackground(for: .widget) {
            Color(white: 0.95)
        }
    }
}

// Data Fetching and Presentation
struct SmallSeasonsProvider: TimelineProvider {
    typealias Entry = SmallSeasonsEntry

    func placeholder(in context: Context) -> SmallSeasonsEntry {
        let sekki = loadSeasonData(for: .large)
        
        return SmallSeasonsEntry(id:sekki.id, kanji: sekki.kanji, notes: sekki.notes, description: sekki.description, startDate:sekki.startDate)
    }

    func getSnapshot(in context: Context, completion: @escaping (SmallSeasonsEntry) -> ()) {
        let entry = SmallSeasonsEntry(date: Date(), icon1: icons[0], icon2: icons[1], icon3: icons[2], icon4: icons[3])
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SmallSeasonsEntry] = []

        let calendar = Calendar.current
        let currentDate = Date()

        // Create an entry for each six-hour interval in the next 24 hours
        for hourOffset in stride(from: 0, to: 24, by: 6) {
            guard let entryDate = calendar.date(byAdding: .hour, value: hourOffset, to: currentDate) else { continue }

            let entry = SmallSeasonsEntry(date: entryDate, icon1: icons[0], icon2: icons[1], icon3: icons[2], icon4: icons[3])
            entries.append(entry)
        }

        // Set the timeline to refresh at the start of the next day
        let timeline = Timeline(entries: entries, policy: .after(startOfNextDay))
        completion(timeline)
    }
}
