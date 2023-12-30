//
//  ContentView.swift
//  Glyphe
//
//  Created by Duncan Gough on 23/11/2023.
//


import WidgetKit
import SwiftUI

struct ContentView: View {
    @State private var selectedOption: String
    @State private var isButtonPressed = false

    let options: [DisplayOption] = [.daysOfWeek, .mantras, .smallSeasons]

    // Initialize with shared UserDefaults
    init() {
        if let sharedDefaults = UserDefaults(suiteName: appGroupUserDefaultsID) {
            _selectedOption = State(initialValue: sharedDefaults.string(forKey: "displayOption") ?? DisplayOption.smallSeasons.rawValue)
        } else {
            _selectedOption = State(initialValue: DisplayOption.smallSeasons.rawValue)
        }
    }

    // State to store the season data
    @State private var seasonData: (id: String, kanji: String, notes: String?, description: String?) = ("", "", nil, nil)

    // Load season data when the view appears
    private func loadSeasonData() {
        // Assuming loadSeasonData is a static function or can be accessed here
        seasonData = hieroscope.loadSeasonData(for: .large)  // Choose the appropriate size
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("hieroscope!")
                    .font(.title)
                    .padding(.top)
                    .padding(.horizontal)
                
                Text("Thee horoscope of hieroglyphes")
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

                Button(action: {
                            if let sharedDefaults = UserDefaults(suiteName: appGroupUserDefaultsID) {
                                sharedDefaults.set(self.selectedOption, forKey: "displayOption")
                                WidgetCenter.shared.reloadAllTimelines()
                            }
                            isButtonPressed = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                isButtonPressed = false
                            }
                }) {
                        if isButtonPressed {
                            Label("Saved!", systemImage: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        } else {
                            Text("Save")
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .transition(.scale)
                }
                
                // Display smallseason data
                Spacer()
                if !seasonData.kanji.isEmpty {
                    VStack(alignment: .leading) {
                        Text("This season")
                            .font(.headline)
                            .padding(.bottom, 5)

                        Text("\(seasonData.id)")
                            .padding(.bottom, 2)
                        
                        Text("\(seasonData.kanji)")
                            .padding(.bottom, 2)
                        
                        if let notes = seasonData.notes {
                            Text("\(notes)")
                                .padding(.bottom, 2)
                        }

                        if let description = seasonData.description {
                            Text("\(description)")
                                .padding(.bottom, 2)
                        }
                        
                        Link("https://smallseasons.guide", destination: URL(string: "https://smallseasons.guide")!)
                            .padding(.top, 5)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading) // Align to leading edge
                }
                Spacer()
            }
            .navigationBarTitle("hieroscope", displayMode: .inline)
            .onAppear {
                loadSeasonData()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
