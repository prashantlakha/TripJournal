

import SwiftUI
import Photos

enum MediaType: String {
    case photo, video
}

struct TJMedia {
    let id: String
    var url: URL
    var mediaType: MediaType = .photo
    var fileName: String
    var encodedURL: String
    var image: UIImage?
    
    init(with locationURL: URL, filename: String, type: MediaType, selectedImage: UIImage?) {
        id = UUID().uuidString
        url = locationURL
        mediaType = type
        encodedURL = filename + "#$" + type.rawValue
        image = selectedImage
        fileName = filename
    }
    
    init(_ decodeURL: String) {
        id = UUID().uuidString
        encodedURL = decodeURL
        let components = decodeURL.components(separatedBy: "#$")
        let urlString = components.first ?? ""
        fileName = urlString
        mediaType = MediaType(rawValue: components.last ?? "") ?? .photo
        url = URL(fileURLWithPath: "")
        if mediaType == .photo {
            if let savedImage = TJPhotoPickerService.loadImageFromDocumentDirectory(fileName: fileName) {
                self.image = savedImage.0
                url = savedImage.1
            }
        } else {
            url = TJPhotoPickerService.loadVideoFromDocumentDirectory(fileName: fileName)
        }
    }
}


class PickedMediaItems: ObservableObject {
    @Published var items = [TJMedia]()
    
    func append(item: TJMedia) {
        items.append(item)
    }
}
