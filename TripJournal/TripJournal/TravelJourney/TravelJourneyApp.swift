import SwiftUI

@main
struct TravelJourneyApp: App {

    var body: some Scene {
        WindowGroup {
            TJContentView(coreDM: CoreDataService())
        }
    }
}
