//
//  ContentView.swift
//  Glyphe
//
//  Created by Duncan Gough on 23/11/2023.
//


import WidgetKit
import SwiftUI

// Define this constant at the top of your file or in a shared constants file
//let appGroupUserDefaultsID = "group.com.yourcompany.yourapp"

struct ContentView: View {
    @State private var selectedOption: String
    let options: [DisplayOption] = [.daysOfWeek, .mantras, .smallSeasons]

    // Initialize with shared UserDefaults
    init() {
        if let sharedDefaults = UserDefaults(suiteName: appGroupUserDefaultsID) {
            _selectedOption = State(initialValue: sharedDefaults.string(forKey: "displayOption") ?? DisplayOption.smallSeasons.rawValue)
        } else {
            _selectedOption = State(initialValue: DisplayOption.smallSeasons.rawValue)
        }
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("Welcome to Hieroscope!")
                    .font(.title)
                    .padding(.top)
                    .padding(.horizontal)
                
                Text("Choose your preferred display option for the widget:")
                    .padding(.bottom, 20)
                    .padding(.horizontal)

                List {
                    ForEach(options, id: \.self) { option in
                        HStack {
                            Text(option.rawValue)
                                .font(.headline)
                            Spacer()
                            if selectedOption == option.rawValue {
                                Image(systemName: "checkmark")
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedOption = option.rawValue
                        }
                        .padding(.vertical, 8) // Increase spacing
                    }

                    Button("Save Choice") {
                        if let sharedDefaults = UserDefaults(suiteName: appGroupUserDefaultsID) {
                            sharedDefaults.set(self.selectedOption, forKey: "displayOption")
                            // Refresh the widget
                            WidgetCenter.shared.reloadAllTimelines()
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center) // Align the button in the center
                }
            }
            .navigationBarTitle("hieroscope", displayMode: .inline)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
