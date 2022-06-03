//
//  TJMapLocationAnnotationView.swift
//  TravelJourney
//
//  Created by Avaneesh Singh on 26/05/22.
//

import SwiftUI

struct TJMapLocationAnnotationView: View {
    var body: some View {
        VStack(spacing: 0) {
            Image(systemName: "map.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .font(.headline)
                .foregroundColor(.white)
                .padding(6)
                .background(Color.blue)
                .cornerRadius(36)
            Image(systemName: "triangle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 10, height: 10)
                .foregroundColor(.blue)
                .rotationEffect(Angle(degrees: 180))
                .offset(y: -3)
                .padding(.bottom, 40)
        }
    }
}

struct TJMapLocationAnnotationView_Previews: PreviewProvider {
    static var previews: some View {
        TJMapLocationAnnotationView()
    }
}
