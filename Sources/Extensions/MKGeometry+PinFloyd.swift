import MapKit

// MARK: - MKMapPoint

extension MKMapPoint {

  var coordinate: CLLocationCoordinate2D {
    return MKCoordinateForMapPoint(self)
  }
}

// MARK: - MKMapSize

extension MKMapSize {

  var halfSize: MKMapSize {
    return MKMapSize(
      width: width / 2,
      height: height / 2
    )
  }
}

// MARK: - MKMapRect

extension MKMapRect {

  var minX: Double {
    return origin.x
  }

  var maxX: Double {
    return origin.x + size.width
  }

  var minY: Double {
    return origin.y
  }

  var maxY: Double {
    return origin.y + size.height
  }

  var northWestRect: MKMapRect {
    return MKMapRect(origin: origin, size: size.halfSize)
  }

  var northEastRect: MKMapRect {
    return MKMapRect(
      origin: MKMapPoint(x: origin.x + size.halfSize.width, y: origin.y),
      size: size.halfSize
    )
  }

  var southWestRect: MKMapRect {
    return MKMapRect(
      origin: MKMapPoint(x: origin.x, y: origin.y + size.halfSize.height),
      size: size.halfSize
    )
  }

  var southEastRect: MKMapRect {
    return MKMapRect(
      origin: MKMapPoint(x: origin.x + size.halfSize.width, y: origin.y + size.halfSize.height),
      size: size.halfSize
    )
  }

  private func contains(x: Double) -> Bool {
    return minX <= x && x <= maxX
  }

  private func contains(y: Double) -> Bool {
    return minY <= y && y <= maxY
  }

  private func contains(point: MKMapPoint) -> Bool {
    return contains(x: point.x) && contains(y: point.y)
  }

  func contains(annotation: MKAnnotation) -> Bool {
    let point = annotation.mapPoint
    return contains(point: point)
  }

  func intersects(rect: MKMapRect) -> Bool {
    // Horizontal segment
    if !(max(minX, rect.minX) <= min(maxX, rect.maxX)) {
      return false
    }
    // Vertical segment
    return max(minY, rect.minY) <= min(maxY, rect.maxY)
  }
}

// MARK: - MKAnnotation

extension MKAnnotation {

  var mapPoint: MKMapPoint {
    return MKMapPointForCoordinate(coordinate)
  }
}

// MARK: - CLLocationCoordinate2D

extension CLLocationCoordinate2D: Equatable {}

public func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
  return fabs(lhs.latitude - rhs.latitude) <= .ulpOfOne
    && fabs(lhs.longitude - rhs.longitude) <= .ulpOfOne
}
