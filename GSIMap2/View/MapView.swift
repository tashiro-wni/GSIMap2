//
//  MapView.swift
//  GSIMap2
//
//  Created by tasshy on 2021/05/05.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    @Binding var zoomLevel: Int
    
    typealias UIViewType = MKMapView
    let mapView = MKMapView()

    func makeUIView(context: Context) -> MKMapView {
        //LOG(#function)
        mapView.delegate = context.coordinator
        mapView.mapType = .standard
        mapView.isPitchEnabled = false
        mapView.isRotateEnabled = false
        mapView.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 35.681, longitude: 139.767),
                                            span: MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.0))
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        //LOG(#function)
        //context.coordinator.updateAnnotations(viewModel: viewModel)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    // MARK: - Coordinator
    // https://www.hackingwithswift.com/forums/swiftui/update-mapview-with-current-location-on-swiftui/1074
    // https://github.com/vvvegesna/MeetupReminder
    final class Coordinator: NSObject, MKMapViewDelegate {
        private let parent: MapView
        private var tileOverlays: [MKOverlay] = []
        private var overlayType: GSITile = .photo {
            didSet {
                parent.mapView.removeOverlays(tileOverlays)
                parent.mapView.addOverlay(overlayType.tileOverlay)
                tileOverlays = [overlayType.tileOverlay]
                
                if parent.mapView.zoomLevel > overlayType.maxZoomLevel {
                    parent.mapView.zoomLevel = overlayType.maxZoomLevel
                }
                if parent.mapView.zoomLevel < overlayType.minZoomLevel {
                    parent.mapView.zoomLevel = overlayType.minZoomLevel
                }
            }
        }

        init(_ parent: MapView) {
            self.parent = parent
            super.init()
            
            parent.mapView.addOverlay(overlayType.tileOverlay)
            tileOverlays = [ overlayType.tileOverlay ]
        }
        
        func zoomInAction(_ sender: Any?) {
            guard parent.mapView.zoomLevel < overlayType.maxZoomLevel else { return }
            parent.mapView.zoomLevel += 1
        }
        
        func zoomOutAction(_ sender: Any?) {
            guard parent.mapView.zoomLevel > overlayType.minZoomLevel else { return }
            parent.mapView.zoomLevel -= 1
        }

        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            if parent.mapView.zoomLevel > overlayType.maxZoomLevel {
                if overlayType == .photo {
                    overlayType = .ortho
                } else {
                    parent.mapView.zoomLevel = overlayType.maxZoomLevel
                }
            }
            if parent.mapView.zoomLevel < overlayType.minZoomLevel {
                if overlayType == .ortho {
                    overlayType = .photo
                } else {
                    parent.mapView.zoomLevel = overlayType.minZoomLevel
                }
            }

            parent.zoomLevel = parent.mapView.zoomLevel
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
