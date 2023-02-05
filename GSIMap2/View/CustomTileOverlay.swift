//
//  CustomTileOverlay.swift
//  GSIMap2
//
//  Created by tasshy on 2023/02/05.
//

import MapKit

final class CustomTileOverlay: MKTileOverlay {
    enum CustomTileError: Error {
        case wrongImage
    }
    
    private var cache: [URL: Data] = [:]
    
    override func loadTile(at path: MKTileOverlayPath) async throws -> Data {
        let url = url(forTilePath: path)
        let data: Data
        if let cachedData = cache[url] {
            LOG("cache hit, start z:\(path.z), x:\(path.x), y:\(path.y)")
            data = cachedData
        } else {
            LOG("load start z:\(path.z), x:\(path.x), y:\(path.y), url:\(url)")
            data = try await super.loadTile(at: path)
            cache[url] = data
        }

        // 取得した画像を半透過にして赤枠を追加、
        let tileRect = CGRect(origin: .zero, size: tileSize)
        UIGraphicsBeginImageContextWithOptions(tileSize, false, 0.0)
        
        guard let image = UIImage(data: data) else {
            //LOG(#function + ", wrong image, z:\(path.z), x:\(path.x), y:\(path.y), url:\(url)")
            throw CustomTileError.wrongImage
        }
        image.draw(in: tileRect, blendMode: .copy, alpha: 0.7)

        // タイルに赤枠を描画
        UIColor.red.setStroke()
        UIBezierPath(rect: tileRect).stroke()
        
        // タイルの z/x/y を表示
        let margin: CGFloat = 5
        let text = String(format: "%d/%d/%d", path.z, path.x, path.y)
        let attributes: [NSAttributedString.Key: Any] = [ .font: UIFont.systemFont(ofSize: 24),
                                                          .foregroundColor: UIColor.red ]
        let textSize = text.size(withAttributes: attributes)
        text.draw(at: CGPoint(x: margin, y: tileSize.height - (textSize.height + margin)),
                  withAttributes: attributes)
        
        guard let outImage = UIGraphicsGetImageFromCurrentImageContext()?.pngData() else { throw CustomTileError.wrongImage }
        //LOG(#function + ", OK z:\(path.z), x:\(path.x), y:\(path.y), url:\(url)")
        UIGraphicsEndImageContext()
        return outImage
    }
}
