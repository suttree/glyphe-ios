import WidgetKit
import SwiftUI

// Core logic
struct RandomIconsEntry: TimelineEntry {
    let date: Date
    let icon1: UIImage
    let icon2: UIImage
    let icon3: UIImage
    let icon4: UIImage
}

struct RandomIconsWidgetEntryView: View {
    var entry: RandomIconsEntry

    // This environment variable tells us what size the widget is
    @Environment(\.widgetFamily) var widgetFamily

    let dayString = Calendar.current.weekdaySymbols[Calendar.current.component(.weekday, from: Date()) - 1]
    
    var body: some View {
        Group {
            switch widgetFamily {
            case .systemSmall:
                // Small Widget - Show single icon
                Image(uiImage: entry.icon1)
                    .resizable()
                    .scaledToFit()
                Text(dayString)
                    .font(.system(.body, design: .serif).italic()) // Apply serif font in italic
                    .foregroundColor(Color(white: 0.2)) // Off-black color
                    .multilineTextAlignment(.center) // Center align text
                    .padding(.top, 5) // Optional padding from the image to the text

            case .systemMedium:
                // Medium Widget - Show 4 icons in a line
                HStack {
                    Image(uiImage: entry.icon1)
                        .resizable()
                        .scaledToFit()
                    Image(uiImage: entry.icon2)
                        .resizable()
                        .scaledToFit()
                    Image(uiImage: entry.icon3)
                        .resizable()
                        .scaledToFit()
                    Image(uiImage: entry.icon4)
                        .resizable()
                        .scaledToFit()
                }
                Text(dayString)
                    .font(.system(.body, design: .serif).italic()) // Apply serif font in italic
                    .foregroundColor(Color(white: 0.2)) // Off-black color
                    .multilineTextAlignment(.center) // Center align text
                    .padding(.top, 5) // Optional padding from the image to the text

            case .systemLarge:
                // Large Widget - Show 4 icons in a 2x2 grid
                VStack {
                    HStack {
                        Image(uiImage: entry.icon1)
                            .resizable()
                            .scaledToFit()
                        Image(uiImage: entry.icon2)
                            .resizable()
                            .scaledToFit()
                    }
                    HStack {
                        Image(uiImage: entry.icon3)
                            .resizable()
                            .scaledToFit()
                        Image(uiImage: entry.icon4)
                            .resizable()
                            .scaledToFit()
                    }
                }
                Text(dayString)
                    .font(.system(.body, design: .serif).italic()) // Apply serif font in italic
                    .foregroundColor(Color(white: 0.2)) // Off-black color
                    .multilineTextAlignment(.center) // Center align text
                    .padding(.top, 5) // Optional padding from the image to the text

            default:
                Image(uiImage: entry.icon1)
                    .resizable()
                    .scaledToFit()
            }
        }
        .containerBackground(for: .widget) {
            Color(white: 0.95)
        }
    }
}

// Data Fetching and Presentation
struct RandomIconsProvider: TimelineProvider {
    typealias Entry = RandomIconsEntry

    // UserDefaults to store the last update date
    let defaults = UserDefaults.standard
    let lastUpdateKey = "LastUpdateDate"

    func placeholder(in context: Context) -> RandomIconsEntry {
        print("placeholder called")
        // Load real icons from your bundle
        let icon1 = UIImage(named: "1.png") ?? UIImage()
        let icon2 = UIImage(named: "2.png") ?? UIImage()
        let icon3 = UIImage(named: "3.png") ?? UIImage()
        let icon4 = UIImage(named: "4.png") ?? UIImage()

        // Return an entry with these icons
        return RandomIconsEntry(date: Date(), icon1: icon1, icon2: icon2, icon3: icon3, icon4: icon4)
    }

    func getSnapshot(in context: Context, completion: @escaping (RandomIconsEntry) -> ()) {
        // Provide a snapshot entry
        print("getSnapshot called")
        //let snapshotIcon = UIImage() // Dummy icon for snapshot
        let icon1 = UIImage(named: "1.png") ?? UIImage()
        let icon2 = UIImage(named: "2.png") ?? UIImage()
        let icon3 = UIImage(named: "3.png") ?? UIImage()
        let icon4 = UIImage(named: "4.png") ?? UIImage()
        
        let entry = RandomIconsEntry(date: Date(), icon1: icon1, icon2: icon2, icon3: icon3, icon4: icon4)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        print("getTimeline called")
        var entries: [RandomIconsEntry] = []
        
        /*
        let currentDate = Date()
        let calendar = Calendar.current

        let hourOffset = calendar.component(.hour, from: currentDate)

        print(hourOffset)
        print("---0")
        print(calendar.date(byAdding: .hour, value: hourOffset, to: currentDate))
        print("---1")
         
         guard let entryDate = calendar.date(byAdding: .hour, value: hourOffset, to: currentDate) else {
             print("Error: Failed to calculate the entry date")
             // Handle the error, e.g., by logging or using a fallback date
             // Return from the function if there's no meaningful way to proceed
             return
         }

         print(entryDate)
         print(currentDate)
         print("---2")
         if calendar.isDate(entryDate, equalTo: currentDate, toGranularity: .day) && calendar.component(.hour, from: entryDate) == 12 {
        */
        
        
        
        let calendar = Calendar.current
        let currentDate = Date()

        // Extract the hour component from the current date
        let hourOffset = calendar.component(.hour, from: currentDate)
        print("Current hour offset: \(hourOffset)")

        // Get the start of the current day
        let startOfCurrentDay = calendar.startOfDay(for: currentDate)

        // Define entryDate
        let entryDate = calendar.date(byAdding: .day, value: 1, to: startOfCurrentDay) ?? currentDate

        // Now entryDate is non-optional and can be used directly
        // Check if the entryDate is midnight of the next day
        if calendar.isDate(entryDate, equalTo: currentDate, toGranularity: .day) && calendar.component(.hour, from: entryDate) == 0 {
            // This block will run if entryDate is midnight
            print("It's midnight: \(entryDate)")
            // Reset the last update date at midnight
            let lastUpdateDate = defaults.object(forKey: lastUpdateKey) as? Date ?? Date.distantPast
            print("Last update date: \(lastUpdateDate)")
            
            defaults.set(Date.distantPast, forKey: lastUpdateKey)
            
            let lastUpdateDate2 = defaults.object(forKey: lastUpdateKey) as? Date ?? Date.distantPast
            print("Last update date2: \(lastUpdateDate2)")
            print("---2.5")
        } else {
            // Handle the case for other times
            print("Current time: \(currentDate), Entry time (next midnight): \(entryDate)")
        }


        
        
        /*
        let calendar = Calendar.current
        let currentDate = Date()

        // Get the start of the current day
        let startOfCurrentDay = calendar.startOfDay(for: currentDate)

        // Add one day to get the start of the next day (which is midnight)
        let entryDate = calendar.date(byAdding: .day, value: 1, to: startOfCurrentDay)
    
        // Check if the entryDate is midnight of the next day
        if calendar.isDate(entryDate, equalTo: currentDate, toGranularity: .day) && calendar.component(.hour, from: entryDate) == 0 {
            // This block will run if entryDate is midnight
            
            
            // Reset the last update date at midnight
            let lastUpdateDate = defaults.object(forKey: lastUpdateKey) as? Date ?? Date.distantPast
            print("Last update date: \(lastUpdateDate)")
            
            defaults.set(Date.distantPast, forKey: lastUpdateKey)
            
            let lastUpdateDate2 = defaults.object(forKey: lastUpdateKey) as? Date ?? Date.distantPast
            print("Last update date2: \(lastUpdateDate2)")
            print("---2.5")
        }
        */
        
        // Fetch icons (this will fetch new ones if the date was reset)
        var icons = fetchRandomIconsIfNeeded(currentDate: entryDate)

        // Rotate the icons every 6 hours
        if hourOffset % 6 == 0 {
            print("rotate")
            icons.rotate()
        }

        let entry = RandomIconsEntry(date: entryDate, icon1: icons[0], icon2: icons[1], icon3: icons[2], icon4: icons[3])
        entries.append(entry)

        let timeline = Timeline(entries: entries, policy: .after(entries.last?.date ?? currentDate))
        completion(timeline)
    }

    func fetchRandomIconsIfNeeded(currentDate: Date) -> [UIImage] {
        print("fetchRandomIconsIfNeeded called")
        let lastUpdateDate = defaults.object(forKey: lastUpdateKey) as? Date ?? Date.distantPast
        print("Last update date: \(lastUpdateDate)")
        print("Current date: \(currentDate)")
        
        if !Calendar.current.isDate(lastUpdateDate, inSameDayAs: currentDate) {
            // New day, fetch new icons
            print("Fetching new icons for a new day")
            let iconNames = ["1.png", "2.png", "3.png", "4.png", "5.png", "6.png", "7.png", "8.png", "9.png", "10.png", "11.png", "12.png", "13.png", "14.png", "15.png", "16.png", "17.png", "18.png", "19.png", "20.png", "21.png", "22.png", "23.png", "24.png", "25.png", "26.png", "27.png", "28.png", "29.png", "30.png", "31.png", "32.png", "33.png", "34.png", "35.png", "36.png", "37.png", "38.png", "39.png", "40.png", "41.png", "42.png", "43.png", "44.png", "45.png", "46.png", "47.png", "48.png", "49.png", "50.png", "51.png", "52.png", "53.png", "54.png", "55.png", "56.png", "57.png", "58.png", "59.png", "60.png", "61.png", "62.png", "63.png", "64.png", "65.png", "66.png", "67.png", "68.png", "69.png", "70.png", "71.png", "72.png", "73.png", "74.png", "75.png", "76.png", "77.png", "78.png", "79.png", "80.png", "81.png", "82.png", "83.png", "84.png", "85.png", "86.png", "87.png", "88.png", "89.png", "90.png", "91.png", "92.png", "93.png", "94.png", "95.png", "96.png", "97.png", "98.png", "99.png", "100.png", "101.png", "102.png", "103.png", "104.png", "105.png", "106.png", "107.png", "108.png", "109.png", "110.png", "111.png", "112.png", "113.png", "114.png", "115.png", "116.png", "117.png", "118.png", "119.png", "120.png", "121.png", "122.png", "123.png", "124.png", "125.png", "126.png", "127.png", "128.png", "129.png", "130.png", "131.png", "132.png", "133.png", "134.png", "135.png", "136.png", "137.png", "138.png", "139.png", "140.png", "141.png", "142.png", "143.png", "144.png", "145.png", "146.png", "147.png", "148.png", "149.png", "150.png", "151.png", "152.png", "153.png", "154.png", "155.png", "156.png", "157.png", "158.png", "159.png", "160.png", "161.png", "162.png", "163.png", "164.png", "165.png", "166.png", "167.png", "168.png", "169.png", "170.png", "171.png", "172.png", "173.png", "174.png", "175.png", "176.png", "177.png", "178.png", "179.png", "180.png", "181.png", "182.png", "183.png", "184.png", "185.png", "186.png", "187.png", "188.png", "189.png", "190.png", "191.png", "192.png", "193.png", "194.png", "195.png", "196.png", "197.png", "198.png", "199.png", "200.png", "201.png", "202.png", "203.png", "204.png", "205.png", "206.png", "207.png", "208.png", "209.png", "210.png", "211.png", "212.png", "213.png", "214.png", "215.png", "216.png", "217.png", "218.png", "219.png", "220.png", "221.png", "222.png", "223.png", "224.png", "225.png", "226.png", "227.png", "228.png", "229.png", "230.png", "231.png", "232.png", "233.png", "234.png", "235.png", "236.png", "237.png", "238.png", "239.png", "240.png", "241.png", "242.png", "243.png", "244.png", "245.png", "246.png", "247.png", "248.png", "249.png", "250.png", "251.png", "252.png", "253.png", "254.png", "255.png", "256.png", "257.png", "258.png", "259.png", "260.png", "261.png", "262.png", "263.png", "264.png", "265.png", "266.png", "267.png", "268.png", "269.png", "270.png", "271.png", "272.png", "273.png", "274.png", "275.png", "276.png", "277.png", "278.png", "279.png", "280.png", "281.png", "282.png", "283.png", "284.png", "285.png", "286.png", "287.png", "288.png", "289.png", "290.png", "291.png", "292.png", "293.png", "294.png", "295.png", "296.png", "297.png", "298.png", "299.png", "300.png", "301.png", "302.png", "303.png", "304.png", "305.png", "306.png", "307.png", "308.png", "309.png", "310.png", "311.png", "312.png", "313.png", "314.png", "315.png", "316.png", "317.png", "318.png", "319.png", "320.png", "321.png", "322.png", "323.png", "324.png"].shuffled() // Your icon names array
            
            let firstFourIcons = Array(iconNames.prefix(4)) // Convert ArraySlice to Array
            defaults.set(firstFourIcons, forKey: "LastChosenIcons") // Save the array
            //defaults.set(iconNames.prefix(4), forKey: "LastChosenIcons") // Store first four chosen icons
            defaults.set(currentDate, forKey: lastUpdateKey)
            
            //print("New icons: \(iconNames)")
            
            return iconNames.prefix(4).map { UIImage(named: $0) ?? UIImage() }
        } else {
            // Return the previously chosen icons
            print("Using previously fetched icons")
            let storedIconNames = defaults.stringArray(forKey: "LastChosenIcons") ?? ["1.png", "2.png", "3.png", "4.png"]
            print("Stored icons: \(storedIconNames)")
            return storedIconNames.map { UIImage(named: $0) ?? UIImage() }
        }
    }
}

// Extension to rotate the elements of an array
extension Array {
    mutating func rotate() {
        if let firstElement = self.first {
            self.append(firstElement)
            self.removeFirst()
        }
    }
}
