import WidgetKit
import SwiftUI

struct IconWidgetEntryView: View {
    var entry: IconWidgetProvider.Entry

    var body: some View {
        HStack {
            Image(entry.icon1)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
            
            Image(entry.icon2)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
        }
        .padding()
    }
}

@main
struct IconWidgetApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    var body: some View {
        IconWidgetEntryView(entry: IconEntry(date: Date(), icon1: "default_icon", icon2: "default_icon"))
            .widgetURL(URL(string: "your-app-url-here"))
    }
}

struct IconEntry: TimelineEntry {
    let date: Date
    let icon1: String
    let icon2: String
}

struct IconWidget: Widget {
    private let kind: String = "IconWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: IconWidgetProvider()) { entry in
            IconWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Random Icons")
        .description("Displays two random icons from the 'icons' folder.")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}

struct IconWidget_Previews: PreviewProvider {
    static var previews: some View {
        IconWidgetEntryView(entry: IconEntry(date: Date(), icon1: "default_icon", icon2: "default_icon"))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
