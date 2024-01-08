import WidgetKit
import SwiftUI

struct ContentView: View {
    @State private var selectedOption: String
    @State private var isButtonPressed = false

    let options: [DisplayOption] = [.daysOfWeek, .smallSeasons]

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
        seasonData = hieroscope.loadSeasonData(for: .large)  // Choose the appropriate size
    }

    var body: some View {
        NavigationView {
            List {
                // First section for the options
                Section {
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
                        .padding(.vertical, 8)
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

                // Separate section for the season card
                Section {
                    if !seasonData.kanji.isEmpty {
                        SeasonCardView(seasonData: seasonData)
                    }
                }
            }
            .navigationBarTitle("Hieroglype", displayMode: .inline)
            .onAppear {
                loadSeasonData()
            }
        }
    }
}

// Custom card view for the season data
struct SeasonCardView: View {
    var seasonData: (id: String, kanji: String, notes: String?, description: String?)
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(seasonData.id)
                .font(.headline)
                .foregroundColor(.primary) // Adapts to light/dark mode
            Text(seasonData.kanji)
                .foregroundColor(.primary) // Adapts to light/dark mode
            if let description = seasonData.description {
                Text(description)
                    .foregroundColor(.primary) // Adapts to light/dark mode
            }
            Link(destination: URL(string: "https://smallseasons.guide")!) {
                Text("smallseasons.guide")
                    .foregroundColor(.primary) // Adapts to light/dark mode
                    .underline()
            }
        }
        .padding(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16))
        .background(Color(UIColor.systemGroupedBackground)) // Match the system's grouped background color
        .cornerRadius(10)
        .shadow(radius: 5)
        .listRowInsets(EdgeInsets()) // Remove default list row padding
    }
}

// Make sure to update DisplayOption enum to remove 'mantras' if it's there.
// Also, update any other parts of the code that might depend on the 'mantras' option.
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
