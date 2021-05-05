//
//  ContentView.swift
//  GSIMap2
//
//  Created by tasshy on 2021/05/05.
//

import SwiftUI

struct ContentView: View {
    @State var zoomLevel: Int = 15
    
    var body: some View {
        ZStack {
            MapView(zoomLevel: $zoomLevel)
                .edgesIgnoringSafeArea(.all)
            
            Text(String(format: "zoomLevel: %d", zoomLevel))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
