import XCTest
import CoreLocation
@testable import PinFloyd

class ClusterAnnotationTests: XCTestCase {

  func testInit() {
    let coordinate = CLLocationCoordinate2D(latitude: 59.932646, longitude: 10.756316)
    let annotation = ClusterAnnotation(coordinate: coordinate, annotationsCount: 10)

    XCTAssertEqual(annotation.coordinate.latitude, coordinate.latitude)
    XCTAssertEqual(annotation.coordinate.longitude, coordinate.longitude)
    XCTAssertEqual(annotation.annotationsCount, 10)
  }
}
