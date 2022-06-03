

import SwiftUI

struct TJContentView: View {
    
    @StateObject private var viewModel = TJLocationViewModel()
    let coreDM: CoreDataService

    var body: some View {
        TabView {
            TJListView(coreDM: coreDM)
                .environmentObject(viewModel)
                .tabItem {
                    Image(systemName: "house")
                    Text("List")
                }

            TJMapView(coreDM: coreDM)
                .environmentObject(viewModel)
                .tabItem {
                    Image(systemName: "gear")
                    Text("Map")
                }
        }.onAppear {
            viewModel.updateValues(coreDM.getAllLocations())
        }
    }
}

struct TJContentView_Previews: PreviewProvider {
    static var previews: some View {
        TJContentView(coreDM: CoreDataService())
    }
}
