//
//  ContentView.swift
//  GSIMap2
//
//  Created by tasshy on 2021/05/05.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            MapView()
                .edgesIgnoringSafeArea(.all)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
