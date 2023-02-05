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
    
    override func loadTile(at path: MKTileOverlayPath) async throws -> Data {
        let data = try await loadIfNeeded(at: path)
        
        guard let image = UIImage(data: data) else {
            //LOG(#function + ", wrong image, z:\(path.z), x:\(path.x), y:\(path.y), url:\(url)")
            throw CustomTileError.wrongImage
        }
        
        let text = String(format: "%d/%d/%d", path.z, path.x, path.y)
        let debugImage = addDebugInfo(image: image, text: text)
        return debugImage?.pngData() ?? data
    }
    
    // キャッシュがあれば利用、なければAPIから取得
    private func loadIfNeeded(at path: MKTileOverlayPath) async throws -> Data {
        let url = url(forTilePath: path)
        let data: Data
        if let cachedData = await TileCache.shared.cache[url] {
            LOG("cache hit, z:\(path.z), x:\(path.x), y:\(path.y)")
            data = cachedData
        } else {
            LOG("load start, z:\(path.z), x:\(path.x), y:\(path.y), url:\(url)")
            data = try await super.loadTile(at: path)
            await TileCache.shared.setCache(data, for: url)
        }
        return data
    }
    
    // 画像を半透明にして、赤枠、タイル番号を描画
    private func addDebugInfo(image: UIImage, text: String) -> UIImage? {
        // 取得した画像を半透過にして赤枠を追加、
        let tileRect = CGRect(origin: .zero, size: tileSize)
        UIGraphicsBeginImageContextWithOptions(tileSize, false, 0.0)
        image.draw(in: tileRect, blendMode: .copy, alpha: 0.7)
        
        // タイルに赤枠を描画
        UIColor.red.setStroke()
        UIBezierPath(rect: tileRect).stroke()
        
        // タイルの z/x/y を表示
        let margin: CGFloat = 5
        let attributes: [NSAttributedString.Key: Any] = [ .font: UIFont.systemFont(ofSize: 24),
                                                          .foregroundColor: UIColor.red ]
        let textSize = text.size(withAttributes: attributes)
        text.draw(at: CGPoint(x: margin, y: tileSize.height - (textSize.height + margin)),
                  withAttributes: attributes)
        
        let outImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return outImage
    }
}

//extension MKTileOverlayPath {
//    func getParentPath(pz: Int) -> MKTileOverlayPath? {
//        guard pz < z else { return nil }
//        let diff = z - pz
//        let factor = Int(truncating: NSDecimalNumber(decimal: pow(2, diff)))
//        let px = x % factor
//        let py = y % factor
//        return MKTileOverlayPath(x: px, y: py, z: pz, contentScaleFactor: contentScaleFactor)
//    }
//}
