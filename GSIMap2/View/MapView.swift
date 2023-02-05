//
//  MapView.swift
//  GSIMap2
//
//  Created by tasshy on 2021/05/05.
//

import SwiftUI
import MapKit
import Combine

struct MapView: UIViewRepresentable {
    @ObservedObject var model: MapModel
    
    typealias UIViewType = MKMapView
    let mapView = MKMapView()

    func makeUIView(context: Context) -> MKMapView {
        //LOG(#function)
        mapView.delegate = context.coordinator
        mapView.mapType = .mutedStandard
        mapView.isPitchEnabled = false
        mapView.isRotateEnabled = false
        mapView.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 35.681, longitude: 139.767),
                                            span: MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.0))
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    // MARK: - Coordinator
    // https://www.hackingwithswift.com/forums/swiftui/update-mapview-with-current-location-on-swiftui/1074
    // https://github.com/vvvegesna/MeetupReminder
    final class Coordinator: NSObject, MKMapViewDelegate {
        private let parent: MapView
        private var overlayType: GSITile { parent.model.overlayType }
        private var tileOverlay: MKOverlay?
        private var cancellables: Set<AnyCancellable> = []

        init(_ parent: MapView) {
            self.parent = parent
            super.init()
            
            parent.model.$selectedBasetime
                .sink { [weak self] item in
                    LOG("selectedBasetime updated")
                    self?.selectedTimeUpdated(basetime: item?.basetime ?? "")
                }
                .store(in: &cancellables)
        }
        
        private func selectedTimeUpdated(basetime: String) {
            if let tileOverlay {
                parent.mapView.removeOverlay(tileOverlay)
            }
            let newOverlay = overlayType.tileOverlay(basetime: basetime)
            parent.mapView.addOverlay(newOverlay)
            tileOverlay = newOverlay
        }
        
        func zoomInAction(_ sender: Any?) {
            guard parent.mapView.zoomLevel < Double(overlayType.maxZoomLevel) else { return }
            parent.mapView.zoomLevel += 1
        }
        
        func zoomOutAction(_ sender: Any?) {
            guard parent.mapView.zoomLevel > Double(overlayType.minZoomLevel) else { return }
            parent.mapView.zoomLevel -= 1
        }

        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
//            if parent.mapView.zoomLevel > Double(overlayType.maxZoomLevel) + 0.99 {
//                if case .photo = overlayType {
//                    overlayType = .ortho
//                } else {
//                    parent.mapView.zoomLevel = Double(overlayType.maxZoomLevel)
//                }
//            }
//            if parent.mapView.zoomLevel < Double(overlayType.minZoomLevel) {
//                if case .ortho = overlayType {
//                    overlayType = .photo
//                } else {
//                    parent.mapView.zoomLevel = Double(overlayType.minZoomLevel)
//                }
//            }

            parent.model.zoomLevel = parent.mapView.zoomLevel
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            MKTileOverlayRenderer(overlay: overlay)
        }
    }
}

//struct MapView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapView(zoomLevel: 15)
//    }
//}
