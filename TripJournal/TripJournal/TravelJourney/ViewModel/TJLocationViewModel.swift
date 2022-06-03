
import SwiftUI
import MapKit

class TJLocationViewModel: ObservableObject {
    @Published var locationComponents: [TJLocationComponentViewModel]
    
    // Current Location of map
    @Published var mapLocationComponent: TJLocationComponentViewModel {
        didSet {
            self.updateMapRegion(mapLocationComponent)
        }
    }
    
    @Published var mapRegion: MKCoordinateRegion = MKCoordinateRegion.init(center: CLLocationCoordinate2D(latitude: 19.01761, longitude: 72.8561643), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    private let mapSpan = MKCoordinateSpan.init(latitudeDelta: 0.1, longitudeDelta: 0.1)
    
    init() {
        self.locationComponents = []
        self.mapLocationComponent = TJLocationComponentViewModel.init("", "", "", 0, 0, nil)
    }
    
    func updateValues(_ locations: [TJLocationComponentViewModel]) {
        if locations.count > 0 {
            self.locationComponents = locations
            mapLocationComponent = locations.first!
        }
    }
    
    func updateMapRegion(_ component: TJLocationComponentViewModel) {
        withAnimation(.easeInOut) {
            mapRegion = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: component.latitude, longitude: component.longitude),
                span: mapSpan
            )
        }
    }
}
