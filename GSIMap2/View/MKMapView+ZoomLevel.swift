//
//  MKMapView+ZoomLevel.swift
//  GSIMap2
//
//  Created by tasshy on 2021/05/05.
//  Copyright © 2020 tasshy. All rights reserved.
//

import MapKit

// https://stackoverflow.com/questions/4189621/setting-the-zoom-level-for-a-mkmapview
extension MKMapView {
    var zoomLevel: Int {
        get {
            Int(log2(360 * (Double(frame.width / 256) / region.span.longitudeDelta)) + 1)
        }
        set (newZoomLevel) {
            setCenter(coordinate: centerCoordinate, zoomLevel: newZoomLevel, animated: false)
        }
    }
    
    private func setCenter(coordinate: CLLocationCoordinate2D, zoomLevel: Int, animated: Bool) {
        let span = MKCoordinateSpan(latitudeDelta: 0, longitudeDelta: 360 / pow(2, Double(zoomLevel)) * Double(frame.width) / 256)
        setRegion(MKCoordinateRegion(center: coordinate, span: span), animated: animated)
    }
}
