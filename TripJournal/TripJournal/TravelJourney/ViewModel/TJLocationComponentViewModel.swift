

import SwiftUI

class TJLocationComponentViewModel: ObservableObject, Identifiable {
    let title, desc, address, id: String
    let latitude, longitude: Double
    let media: [TJMedia]?
    
    init(_ title: String, _ desc: String, _ address: String, _ lat: Double, _ lng: Double,_ savedMedia: [TJMedia]?) {
        self.title = title
        self.desc = desc
        self.address = address
        self.latitude = lat
        self.longitude = lng
        self.media = savedMedia
        self.id = UUID().uuidString
    }
}
