//
//  MapModel.swift
//  GSIMap2
//
//  Created by tasshy on 2023/02/05.
//

import Foundation

final class MapModel: ObservableObject {
    @Published var zoomLevel: Double = 0
    @Published var overlayType: GSITile = .satirJP
    @Published private(set) var timeList: [TimeItem] = []
    @Published var sliderPosition: Double = 1.0 {
        didSet {
            guard timeList.count > 1 else { return }
            selectedIndex = min(Int(round(Double(timeList.count) * sliderPosition)), timeList.count - 1)
            selectedBasetime = timeList[selectedIndex]
        }
    }
    private(set) var selectedIndex: Int = 0
    @Published var selectedBasetime: TimeItem?

    init() {
        loadTimeList()
    }
    
    struct TimeItem: Decodable {
        let basetime: String
        let validtime: String
        
        var displayTime: String {
            let year = String(basetime.prefix(4))
            let mon = String(basetime.prefix(6).suffix(2))
            let day = String(basetime.prefix(8).suffix(2))
            let hour = String(basetime.prefix(10).suffix(2))
            let min = String(basetime.prefix(12).suffix(2))
            return String(format: "%@/%@/%@ %@:%@", year, mon, day, hour, min)
        }
    }
    
    enum LoadError: Error {
        case wrongURL
    }
    
    func loadTimeList() {
        Task { @MainActor in
            do {
                guard let url = overlayType.timeListURL else {
                    throw LoadError.wrongURL
                }
                let (data, _) = try await URLSession.shared.data(from: url)
                let list = try JSONDecoder().decode([TimeItem].self, from: data)
                timeList = list
                LOG("load timelist: \(list.count)")
                sliderPosition = 1.0
            } catch {
                timeList = []
                selectedBasetime = nil
            }
        }
    }
}

actor TileCache {
    static let shared = TileCache()
    private(set) var cache: [URL: Data] = [:]
    
    private init() {}
    
    func setCache(_ data: Data, for key: URL) {
        cache[key] = data
    }
}
