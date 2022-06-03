//
//  TJGridPhotosView.swift
//  TravelJourney
//
//  Created by Avaneesh Singh on 25/05/22.
//

import SwiftUI
import MapKit
import AVKit

struct TJGridPhotosView: View {
    
    @EnvironmentObject private var viewModel: TJLocationComponentViewModel

    var gridItems: [GridItem] {
        return Array(repeating: GridItem(.flexible(), spacing: 15), count: 2)
    }
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVGrid(columns: gridItems) {
                ForEach(viewModel.media ?? [], id: \.id) { selectedMedia in
                    if selectedMedia.mediaType == .photo {
                        if let image = selectedMedia.image {
                            TJGridCellView(imageName: image)
                        } else { EmptyView() }
                    } else {
                        let width = (UIScreen.main.bounds.width - 45)/2
                        VideoPlayer(player: AVPlayer(url: selectedMedia.url))
                            .frame(width: width, height: width)
                            .cornerRadius(10)
                    }
                 }
            }.padding()
        }
        .navigationTitle("Images")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct TJGridPhotosView_Previews: PreviewProvider {
    static var previews: some View {
        TJGridPhotosView()
            .environmentObject(TJLocationComponentViewModel.init("", "", "", 0, 0, nil))
    }
}
