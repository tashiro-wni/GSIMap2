//
//  ContentView.swift
//  GSIMap2
//
//  Created by tasshy on 2021/05/05.
//

import SwiftUI

struct ContentView: View {
    @StateObject var model = MapModel()
    
    var body: some View {
        ZStack {
            MapView(model: model)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                if model.timeList.count > 1 {
                    Text(String(format: "%@ (%d)", model.selectedBasetime?.displayTime ?? "", model.selectedIndex))
                        .font(.title)
                        .foregroundColor(.red)
                    Slider(value: $model.sliderPosition, in: 0 ... 1)
                }
                
                Text(String(format: "zoomLevel: %.2f", model.zoomLevel))
                    .font(.title)
                    .foregroundColor(.red)
            }
            .frame(maxWidth: 300, maxHeight: .infinity, alignment: .bottom)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
