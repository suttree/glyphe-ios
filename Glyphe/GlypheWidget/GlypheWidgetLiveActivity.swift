//
//  GlypheWidgetLiveActivity.swift
//  GlypheWidget
//
//  Created by Duncan Gough on 23/11/2023.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct GlypheWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct GlypheWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: GlypheWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension GlypheWidgetAttributes {
    fileprivate static var preview: GlypheWidgetAttributes {
        GlypheWidgetAttributes(name: "World")
    }
}

extension GlypheWidgetAttributes.ContentState {
    fileprivate static var smiley: GlypheWidgetAttributes.ContentState {
        GlypheWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: GlypheWidgetAttributes.ContentState {
         GlypheWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: GlypheWidgetAttributes.preview) {
   GlypheWidgetLiveActivity()
} contentStates: {
    GlypheWidgetAttributes.ContentState.smiley
    GlypheWidgetAttributes.ContentState.starEyes
}
