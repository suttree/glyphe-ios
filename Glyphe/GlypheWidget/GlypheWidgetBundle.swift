//
//  GlypheWidgetBundle.swift
//  GlypheWidget
//
//  Created by Duncan Gough on 23/11/2023.
//

import WidgetKit
import SwiftUI

@main
struct GlypheWidgetBundle: WidgetBundle {
    var body: some Widget {
        GlypheWidget()
        GlypheWidgetLiveActivity()
    }
}

// Widget and Provider Registration
struct GlypheWidget: Widget {
    let kind: String = "Small seasons"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: SmallSeasonsProvider()) { entry in
            SmallSeasonsEntry(entry: entry)
        }
        .configurationDisplayName("Small seasons")
        .description("Small seaons")
    }
}
