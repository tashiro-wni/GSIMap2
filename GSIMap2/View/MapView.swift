//
//  MapView.swift
//  GSIMap2
//
//  Created by tasshy on 2021/05/05.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
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
        context.coordinator.registerAnnotationViews()
        
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
        private var annotations: [MKAnnotation] = []
        
        init(_ parent: MapView) {
            self.parent = parent
            super.init()
        }
        
        func registerAnnotationViews() {
//            for identifier in AmedasData.allIdentifiers {
//                parent.mapView.register(AmedasAnnotationView.self, forAnnotationViewWithReuseIdentifier: identifier)
//            }
        }
        
//        func updateAnnotations(viewModel: AmedasMapViewModel) {
//            parent.mapView.removeAnnotations(annotations)
//            annotations.removeAll()
//
//            for data in viewModel.amedasData {
//                if let point = viewModel.amedasPoints[data.pointID], data.hasValidData(for: parent.viewModel.displayElement) {
//                    annotations.append(AmedasAnnotation(point: point, data: data, element: parent.viewModel.displayElement))
//                }
//            }
//            LOG(#function + ", \(viewModel.dateText), \(parent.viewModel.displayElement), plot \(annotations.count) points.")
//            parent.mapView.addAnnotations(annotations)
//            parent.mapView.setNeedsDisplay()
//        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
