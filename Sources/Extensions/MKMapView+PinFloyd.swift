import MapKit

// MARK: - Tile bounding box

struct MapTileBoundingBox {
  let minX: Int
  let maxX: Int
  let minY: Int
  let maxY: Int
}

// MARK: - MKMapView

extension MKMapView {

  var zoomLevel: Int {
    let maxZoomTileWidth = 256.0
    return Int(
      log2(360 * (Double(frame.size.width) / maxZoomTileWidth / region.span.longitudeDelta)) + 1
    )
  }

  var zoomScale: Double {
    return Double(bounds.size.width) / visibleMapRect.size.width
  }

  var scaleFactor: Double {
    return zoomScale / tileSize
  }

  var tileSize: Double {
    switch zoomLevel {
    case 13...15:
      return 64
    case 16...18:
      return 32
    case 18..<Int.max:
      return 16
    default:
      return 88
    }
  }

  var tileBoundingBox: MapTileBoundingBox {
    let regionRect = visibleMapRect
    return MapTileBoundingBox(
      minX: scaledIntCoordinate(from: regionRect.minX),
      maxX: scaledIntCoordinate(from: regionRect.maxX),
      minY: scaledIntCoordinate(from: regionRect.minY),
      maxY: scaledIntCoordinate(from: regionRect.maxY)
    )
  }

  private func scaledIntCoordinate(from coordinate: Double) -> Int {
    return Int(floor(coordinate * scaleFactor))
  }
}
