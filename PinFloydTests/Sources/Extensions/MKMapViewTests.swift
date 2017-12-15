import XCTest
import MapKit
@testable import PinFloyd

class MKMapViewTests: XCTestCase {

  var mapView: MKMapView!

  override func setUp() {
    super.setUp()
    mapView = MKMapView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
  }

  func testZoomLevel() {
    // Zoom in
    let coordinate = CLLocationCoordinate2D(latitude: 59.932646, longitude: 10.756316)
    let region = MKCoordinateRegionMakeWithDistance(coordinate, 500, 500)
    mapView.setRegion(region, animated: false)

    XCTAssertEqual(mapView.zoomLevel, 16)
  }

  func testZoomScale() {
    XCTAssertEqual(
      mapView.zoomScale,
      Double(mapView.bounds.size.width) / mapView.visibleMapRect.size.width
    )
  }

  func testScaleFactor() {
    XCTAssertEqual(mapView.scaleFactor, mapView.zoomScale / 88)
  }

  func testTileSize() {
    let coordinate = CLLocationCoordinate2D(latitude: 59.932646, longitude: 10.756316)

    // 13...15
    mapView.setRegion(MKCoordinateRegionMakeWithDistance(coordinate, 1000, 1000), animated: false)
    XCTAssertEqual(mapView.tileSize, 64)

    // 16...18:
    mapView.setRegion(MKCoordinateRegionMakeWithDistance(coordinate, 500, 500), animated: false)
    XCTAssertEqual(mapView.tileSize, 32)

    // > 18
    mapView.setRegion(MKCoordinateRegionMakeWithDistance(coordinate, 10, 10), animated: false)
    XCTAssertEqual(mapView.tileSize, 16)

    // < 13
    mapView.setRegion(MKCoordinateRegionMakeWithDistance(coordinate, 10000, 10000), animated: false)
    XCTAssertEqual(mapView.tileSize, 88)
  }

  func testTile() {
    let boundingBox = mapView.tile

    XCTAssertEqual(boundingBox.minX, Int(floor(mapView.visibleMapRect.minX * mapView.scaleFactor)))
    XCTAssertEqual(boundingBox.maxX, Int(floor(mapView.visibleMapRect.maxX * mapView.scaleFactor)))
    XCTAssertEqual(boundingBox.minY, Int(floor(mapView.visibleMapRect.minY * mapView.scaleFactor)))
    XCTAssertEqual(boundingBox.maxY, Int(floor(mapView.visibleMapRect.maxY * mapView.scaleFactor)))
  }  
}
