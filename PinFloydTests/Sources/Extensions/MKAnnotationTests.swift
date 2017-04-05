import XCTest
import MapKit
@testable import PinFloyd

class MKAnnotationTests: XCTestCase {

  var annotation: ClusterAnnotation!

  override func setUp() {
    super.setUp()
    let coordinate = CLLocationCoordinate2D(latitude: 59.932646, longitude: 10.756316)
    annotation = ClusterAnnotation(coordinate: coordinate, annotationsCount: 10)
  }

  func testMapPoint() {
    let mapPoint = annotation.mapPoint
    let expectedMapPoint = MKMapPointForCoordinate(annotation.coordinate)

    XCTAssertEqual(mapPoint.x, expectedMapPoint.x)
    XCTAssertEqual(mapPoint.y, expectedMapPoint.y)
  }
}
