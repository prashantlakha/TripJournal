

import SwiftUI

struct TJListView: View {
    
    let coreDM: CoreDataService
    @EnvironmentObject private var viewModel: TJLocationViewModel
    @State var presentingModal = false

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.locationComponents) { component in
                    NavigationLink(destination: TJGridPhotosView()
                                    .environmentObject(component)
                    ) {
                        TJListComponentView()
                            .environmentObject(component)
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
            .navigationTitle("List")
        }
    }
}

struct TJListView_Previews: PreviewProvider {
    static var previews: some View {
        TJListView(coreDM: CoreDataService())
            .environmentObject(TJLocationViewModel())
    }
}
