//
//  TJMapView.swift
//  TravelJourney
//
//  Created by Avaneesh Singh on 25/05/22.
//

import SwiftUI
import MapKit

struct TJMapView: View {
    
    let coreDM: CoreDataService
    @EnvironmentObject private var viewModel: TJLocationViewModel
    @State var presentingModal = false

    var body: some View {
        NavigationView {
            VStack {
                Map.init(coordinateRegion: $viewModel.mapRegion, annotationItems: viewModel.locationComponents) { component in                    
                    MapAnnotation.init(coordinate: CLLocationCoordinate2D(latitude: component.latitude, longitude: component.longitude)) {
                        NavigationLink(destination: TJGridPhotosView()
                                        .environmentObject(component)
                        ) {
                            TJMapLocationAnnotationView()
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        presentingModal = true
                    }) {
                        Image(systemName: "plus")
                    }.sheet(isPresented: $presentingModal, content: {
                        TJAddContentView(showModal: $presentingModal, coreDM: coreDM)
                            .environmentObject(viewModel)
                    })
                }
            }
            .navigationTitle("Map")
        }
    }
    
    private func addItem() {
        
    }
}

struct TJMapView_Previews: PreviewProvider {
    static var previews: some View {
        TJMapView(coreDM: CoreDataService())
            .environmentObject(TJLocationViewModel())
    }
}

// MapMarker.init(coordinate: component.location.coordinates, tint: .blue)
