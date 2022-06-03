
import SwiftUI
import MapKit
import AVKit

struct TJAddContentView: View {
    
    @Binding var showModal: Bool
    
    let coreDM: CoreDataService
    @EnvironmentObject private var viewModel: TJLocationViewModel
    @StateObject var locationManager = TJLocationService()
    @State private var title: String = ""
    @State private var desc: String = ""
    @State private var descPlaceholder: String = "Enter description "
    
    @State private var showSheet = false
    @ObservedObject var mediaItems = PickedMediaItems()
    @State private var showImagePicker: Bool = false {
        didSet {
            self.showSheet = !showImagePicker
        }
    }
    private let width = (UIScreen.main.bounds.width - 100)/2
    
    var gridItems: [GridItem] {
        return Array(repeating: GridItem(.flexible(), spacing: 15), count: 2)
    }

    var userLatitude: Double {
        return locationManager.lastLocation?.coordinate.latitude ?? 0
    }
    
    var userLongitude: Double {
        return locationManager.lastLocation?.coordinate.longitude ?? 0
    }
    
    var userAddress: String {
        return locationManager.lastLocationAddress ?? "Not Found"
    }
    
    var body: some View {
        VStack {
            Form {
                Section {
                    TextField("Enter title", text: $title)
                        .disableAutocorrection(true)
                    ZStack {
                        if self.desc.isEmpty {
                            TextEditor(text: $descPlaceholder)
                                .font(.body)
                                .foregroundColor(Color(red: 199/255, green: 199/255, blue: 205/255))
                                .disabled(true)
                        }
                        TextEditor(text: $desc)
                            .opacity(self.desc.isEmpty ? 0.25 : 1)
                    }
                    Text("Your location: \(userAddress)")
                    Text("Your location coordinates: \(userLatitude), \(userLongitude)")
                }
                Section {
                    HStack {
                        Text("Images")
                        Spacer()
                        Button(action: {
                            self.showSheet = true
                        }) {
                            Image(systemName: "plus")
                        }
                    }
                    LazyVGrid(columns: gridItems) {
                        ForEach(mediaItems.items, id: \.id) { item in
                            if item.mediaType == .photo {
                                if let image = item.image {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: width, height: width)
                                        .cornerRadius(10)
                                } else { EmptyView() }
                            } else {
                                VideoPlayer(player: AVPlayer(url: item.url))
                                    .frame(width: width, height: width)
                                    .cornerRadius(10)
                            }
                        }
                    }.padding()

                }
            }
            Button("Save") {
                var arr: [String] = []
                for _item in mediaItems.items {
                    arr.append(_item.encodedURL)
                }
                let stringRepresentation = arr.joined(separator: ",")
                print(stringRepresentation)
                coreDM.saveLocation(title: title, desc: desc, address: userAddress, lat: userLatitude, lng: userLongitude, media: stringRepresentation)
                viewModel.updateValues(coreDM.getAllLocations())
                self.showModal.toggle()
            }
            .background(Color.white)
            .foregroundColor(Color.blue).padding()
        }
        .navigationTitle("Create new")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showSheet, content: {
            TJPhotoPickerService(mediaItems: mediaItems) { didSelectItem in
                // Handle didSelectItems value here...
                showSheet = false
            }
        })
    }
}
