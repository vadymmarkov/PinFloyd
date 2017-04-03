import XCTest
import MapKit
@testable import PinFloyd

class MapSizeTests: XCTestCase {

  var mapSize: MKMapSize!

  override func setUp() {
    super.setUp()
    mapSize = MKMapSize(width: 50, height: 100)
  }

  func testHalfSize() {
    let halfSize = mapSize.halfSize

    XCTAssertEqual(halfSize.width, 25)
    XCTAssertEqual(halfSize.height, 50)
  }
}
