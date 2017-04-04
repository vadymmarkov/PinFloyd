import XCTest
import MapKit
@testable import PinFloyd

class MapRectTests: XCTestCase {

  var mapRect: MKMapRect!

  override func setUp() {
    super.setUp()
    mapRect = MKMapRect(origin: MKMapPoint(x: 10, y: 20), size: MKMapSize(width: 50, height: 20))
  }

  func testMinX() {
    XCTAssertEqual(mapRect.minX, 10)
  }

  func testMaxX() {
    XCTAssertEqual(mapRect.maxX, 60)
  }

  func testMinY() {
    XCTAssertEqual(mapRect.minY, 20)
  }

  func testMaxY() {
    XCTAssertEqual(mapRect.maxY, 40)
  }

  func testNorthWestRect() {
    XCTAssertEqual(mapRect.northWestRect.origin.x, 10)
    XCTAssertEqual(mapRect.northWestRect.origin.y, 20)
    XCTAssertEqual(mapRect.northWestRect.size.width, 25)
    XCTAssertEqual(mapRect.northWestRect.size.height, 10)
  }

  func testNorthEastRect() {
    XCTAssertEqual(mapRect.northEastRect.origin.x, 35)
    XCTAssertEqual(mapRect.northEastRect.origin.y, 20)
    XCTAssertEqual(mapRect.northEastRect.size.width, 25)
    XCTAssertEqual(mapRect.northEastRect.size.height, 10)
  }

  func testSouthWestRect() {
    XCTAssertEqual(mapRect.southWestRect.origin.x, 10)
    XCTAssertEqual(mapRect.southWestRect.origin.y, 30)
    XCTAssertEqual(mapRect.southWestRect.size.width, 25)
    XCTAssertEqual(mapRect.southWestRect.size.height, 10)
  }

  func testSouthEastRect() {
    XCTAssertEqual(mapRect.southEastRect.origin.x, 35)
    XCTAssertEqual(mapRect.southEastRect.origin.y, 30)
    XCTAssertEqual(mapRect.southEastRect.size.width, 25)
    XCTAssertEqual(mapRect.southEastRect.size.height, 10)
  }

  func testContainsAnnotation() {
    var point = MKMapPoint(x: 142238218.52872249, y: 78053903.484172195)
    mapRect = MKMapRect(
      origin: point,
      size: MKMapSize(width: 50, height: 20)
    )
    var annotation = ClusterAnnotation(coordinate: point.coordinate, annotationsCount: 10)
    XCTAssertTrue(mapRect.contains(annotation: annotation))

    point = MKMapPoint(x: 142238228.52872249, y: 78053913.484172195)
    annotation = ClusterAnnotation(coordinate: point.coordinate, annotationsCount: 10)
    XCTAssertTrue(mapRect.contains(annotation: annotation))

    point = MKMapPoint(x: 10, y: 70)
    annotation = ClusterAnnotation(coordinate: point.coordinate, annotationsCount: 10)
    XCTAssertFalse(mapRect.contains(annotation: annotation))
  }

  func testIntersectsRect() {
    var rect = MKMapRect(origin: MKMapPoint(x: 10, y: 20), size: MKMapSize(width: 50, height: 20))
    XCTAssertTrue(mapRect.intersects(rect: rect))

    rect = MKMapRect(origin: MKMapPoint(x: 20, y: 30), size: MKMapSize(width: 50, height: 20))
    XCTAssertTrue(mapRect.intersects(rect: rect))

    rect = MKMapRect(origin: MKMapPoint(x: 0, y: 60), size: MKMapSize(width: 10, height: 30))
    XCTAssertFalse(mapRect.intersects(rect: rect))
  }
}
