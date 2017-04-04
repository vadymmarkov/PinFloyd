import MapKit
@testable import PinFloyd

class Annotation: NSObject, MKAnnotation {

  let coordinate: CLLocationCoordinate2D
  var title: String?
  var subtitle: String?

  init(mapPoint: MKMapPoint) {
    self.coordinate = mapPoint.coordinate
  }
}
