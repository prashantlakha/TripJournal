//
//  TJGridCellView.swift
//  TravelJourney
//
//  Created by Avaneesh Singh on 29/05/22.
//

import SwiftUI

struct TJGridCellView: View {
    
    var imageName: UIImage?
    let width = (UIScreen.main.bounds.width - 45)/2
    
    var body: some View {
        if let image = imageName {
            Image(uiImage: image)
                .resizable()
                .frame(height: width)
                .cornerRadius(10)
        } else { EmptyView() }
    }
}
