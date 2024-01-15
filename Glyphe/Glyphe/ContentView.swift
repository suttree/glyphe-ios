import WidgetKit
import SwiftUI

struct ContentView: View {
    @State private var selectedOption: String
    @State private var isButtonPressed = false

    let options: [DisplayOption] = [.daysOfWeek]

    var body: some View {
        
    }
}

// Make sure to update DisplayOption enum to remove 'mantras' if it's there.
// Also, update any other parts of the code that might depend on the 'mantras' option.
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
