//
//  GSITile.swift
//  GSIMap
//
//  Created by tasshy on 2020/07/26.
//  Copyright © 2020 tasshy. All rights reserved.
//  国土地理院 タイル https://maps.gsi.go.jp/development/ichiran.html

import Foundation

enum GSITile {
    case standard      // 標準地図　　　　　　　　　zoomLevel 5-18
    case pale          // 淡色地図　　　　　　　　　zoomLevel 5-18
    case english       // 英語　　　　　　　　　　　zoomLevel 5-11
    case lcm25k        // 数値地図25000（土地条件）zoomLevel 10-16
    case photo         // シームレス空中写真　　　　zoomLevel 2-14
    case ortho         // オルソ画像　　　　　　　　zoomLevel 14-18
    case relief        // 色別標高図　　　　　　　　zoomLevel 5-15
    case hillShade     // 陰影起伏図　　　　　　　　zoomLevel 2-16
    case floodControl  // 治水地形分類図　　　　　　zoomLevel 11-16
    case satirJP       // ひまわり赤外線画像     zoomLevel 6
    case satirFD       // ひまわり赤外線画像     zoomLevel 3-5

    func tileOverlay(basetime: String) -> CustomTileOverlay {
        let overlay = CustomTileOverlay(urlTemplate: urlTemplate(basetime: basetime))
        overlay.minimumZ = minZoomLevel
        overlay.maximumZ = maxZoomLevel
        //overlay.canReplaceMapContent = true
        return overlay
    }
    
    private static let gsiBaseUrl = "https://cyberjapandata.gsi.go.jp/xyz"  // 国土地理院
    private static let jmaBaseUrl = "https://www.jma.go.jp/bosai/himawari/data"  // 気象庁

    var timeListURL: URL? {
        switch self {
        case .satirJP:
            return URL(string: Self.jmaBaseUrl + "/satimg/targetTimes_jp.json")
        case .satirFD:
            return URL(string: Self.jmaBaseUrl + "/satimg/targetTimes_fd.json")
        default:
            return nil
        }
    }
    
    func urlTemplate(basetime: String) -> String {
        switch self {
        case .standard:
            return Self.gsiBaseUrl + "/std/{z}/{x}/{y}.png"
        case .pale:
            return Self.gsiBaseUrl + "/pale/{z}/{x}/{y}.png"
        case .english:
            return Self.gsiBaseUrl + "/english/{z}/{x}/{y}.png"
        case .lcm25k:
            return Self.gsiBaseUrl + "/lcm25k_2012/{z}/{x}/{y}.png"
        case .photo:
            return Self.gsiBaseUrl + "/seamlessphoto/{z}/{x}/{y}.jpg"
        case .ortho:
            return Self.gsiBaseUrl + "/ort/{z}/{x}/{y}.jpg"
        case .relief:
            return Self.gsiBaseUrl + "/relief/{z}/{x}/{y}.png"
        case .hillShade:
            return Self.gsiBaseUrl + "/hillshademap/{z}/{x}/{y}.png"
        case .floodControl:
            return Self.gsiBaseUrl + "/lcmfc2/{z}/{x}/{y}.png"
        case .satirJP:
            let band = "B13"
            let prod = "TBB"
            return Self.jmaBaseUrl + "/satimg/\(basetime)/jp/\(basetime)/\(band)/\(prod)/{z}/{x}/{y}.jpg"
        case .satirFD:
            let band = "B13"
            let prod = "TBB"
            return Self.jmaBaseUrl + "/satimg/\(basetime)/fd/\(basetime)/\(band)/\(prod)/{z}/{x}/{y}.jpg"
        }
    }
    
    var maxZoomLevel: Int {
        switch self {
        case .standard, .pale:
            return 18
        case .english:
            return 11
        case .lcm25k:
            return 16
        case .photo:
            return 14
        case .ortho:
            return 18
        case .relief:
            return 15
        case .hillShade:
            return 16
        case .floodControl:
            return 16
        case .satirJP:
            return 6
        case .satirFD:
            return 5
        }
    }
    
    var minZoomLevel: Int {
        switch self {
        case .standard, .pale:
            return 5
        case .english:
            return 5
        case .lcm25k:
            return 10
        case .photo:
            return 2
        case .ortho:
            return 14
        case .relief:
            return 5
        case .hillShade:
            return 2
        case .floodControl:
            return 11
        case .satirJP:
            return 6
        case .satirFD:
            return 3
        }
    }
}
