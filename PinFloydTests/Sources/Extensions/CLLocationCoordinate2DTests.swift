import XCTest
import MapKit
@testable import PinFloyd

class CLLocationCoordinate2DTests: XCTestCase {

  func testEqual() {
    let coordinate1 = CLLocationCoordinate2D(latitude: 59.932646, longitude: 10.756316)
    let coordinate2 = CLLocationCoordinate2D(latitude: 59.932646, longitude: 10.756316)
    XCTAssertEqual(coordinate1, coordinate2)
  }

  func testNotEqual() {
    let coordinate1 = CLLocationCoordinate2D(latitude: 59.932646, longitude: 10.756316)
    let coordinate2 = CLLocationCoordinate2D(latitude: 69.932646, longitude: 20.756316)
    XCTAssertNotEqual(coordinate1, coordinate2)
  }
}
