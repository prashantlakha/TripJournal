
import SwiftUI
import PhotosUI

struct TJPhotoPickerService: UIViewControllerRepresentable {
    typealias UIViewControllerType = PHPickerViewController
    
    @ObservedObject var mediaItems: PickedMediaItems
    var didFinishPicking: (_ didSelectItems: Bool) -> Void
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .any(of: [.images, .videos])
        config.selectionLimit = 0
        config.preferredAssetRepresentationMode = .current
        
        let controller = PHPickerViewController(configuration: config)
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        
    }
    
    
    func makeCoordinator() -> Coordinator {
        Coordinator(with: self)
    }
    
    static func saveImageInDocumentDirectory(image: UIImage, url: URL) -> URL? {
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!;
        let fileURL = documentsUrl.appendingPathComponent(url.lastPathComponent)
        
        if let imageData = image.pngData() {
            do {
                try imageData.write(to: fileURL, options: .atomic)
                return fileURL
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    static func saveVideoInDocumentDirectory(url: URL) -> URL? {
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!;
        let fileURL = documentsUrl.appendingPathComponent(url.lastPathComponent)
        do {
            try FileManager.default.copyItem(at: url, to: fileURL)
            return fileURL
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    static func loadImageFromDocumentDirectory(fileName: String) -> (UIImage, URL)? {
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!;
        let fileURL = documentsUrl.appendingPathComponent(fileName)
        do {
            guard let imageData = try? Data(contentsOf: fileURL) else { return nil }
            if let ourImage = UIImage(data: imageData) {
                return (ourImage, fileURL)
            }
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    static func loadVideoFromDocumentDirectory(fileName: String) -> URL {
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!;
        let fileURL = documentsUrl.appendingPathComponent(fileName)
        return fileURL
    }
    
    
    class Coordinator: PHPickerViewControllerDelegate {
        var photoPicker: TJPhotoPickerService
        
        init(with photoPicker: TJPhotoPickerService) {
            self.photoPicker = photoPicker
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            photoPicker.didFinishPicking(!results.isEmpty)
            guard !results.isEmpty else {
                return
            }
            for result in results {
                let itemProvider = result.itemProvider
                guard let typeIdentifier = itemProvider.registeredTypeIdentifiers.first,
                      let utType = UTType(typeIdentifier)
                else { continue }
                if utType.conforms(to: .image) {
                    self.getFile(from: itemProvider, typeIdentifier: typeIdentifier, type: .image)
                } else if utType.conforms(to: .movie) {
                    self.getFile(from: itemProvider, typeIdentifier: typeIdentifier, type: .movie)
                }
            }
        }
        
        private func getFile(from itemProvider: NSItemProvider, typeIdentifier: String, type: UTType) {
            itemProvider.loadFileRepresentation(forTypeIdentifier: typeIdentifier) { url, error in
                if let error = error {
                    print(error.localizedDescription)
                }
                guard let url = url else { return }
                if type == .image {
                    if itemProvider.canLoadObject(ofClass: UIImage.self) {
                        itemProvider.loadObject(ofClass: UIImage.self) { object, error in
                            if let error = error {
                                print(error.localizedDescription)
                            }
                            if let image = object as? UIImage {
                                TJPhotoPickerService.saveImageInDocumentDirectory(image: image, url: url)
                                DispatchQueue.main.async {
                                    self.photoPicker.mediaItems.append(item: TJMedia(with: url, filename: url.lastPathComponent, type: .photo, selectedImage: image))
                                }
                            }
                        }
                    }
                } else {
                    guard let fileURL = TJPhotoPickerService.saveVideoInDocumentDirectory(url: url) else { return }
                    DispatchQueue.main.async {
                        self.photoPicker.mediaItems.append(item: TJMedia(with: fileURL, filename: url.lastPathComponent, type: .video, selectedImage: nil))
                    }
                }
            }
        }
    }
}
