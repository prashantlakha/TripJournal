

import SwiftUI
import MapKit
import AVKit

struct TJListComponentView: View {
    
    @EnvironmentObject private var viewModel: TJLocationComponentViewModel
    
    var body: some View {
        HStack {
            if let media = viewModel.media?.first {
                if media.mediaType == .photo {
                    if let image = media.image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 60)
                            .cornerRadius(10)
                        } else { EmptyView() }
                    } else {
                        VideoPlayer(player: AVPlayer(url: media.url))
                            .frame(width: 60, height: 60)
                            .cornerRadius(10)
                    }
                }
                VStack(alignment: .leading) {
                    Text(viewModel.title)
                        .font(.headline)
                    Text(viewModel.address)
                        .font(.subheadline)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            
        }
    }
}
