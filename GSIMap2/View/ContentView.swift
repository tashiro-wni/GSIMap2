//
//  ContentView.swift
//  GSIMap2
//
//  Created by tasshy on 2021/05/05.
//

import SwiftUI

struct ContentView: View {
    @State var zoomLevel: Int = 5
    @State var overlayType: GSITile = .satirFD("20230205083000")
    
    var body: some View {
        ZStack {
            MapView(zoomLevel: $zoomLevel, overlayType: $overlayType)
                .edgesIgnoringSafeArea(.all)
            
            Text(String(format: "zoomLevel: %d", zoomLevel))
                .font(.title)
                .foregroundColor(.red)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
