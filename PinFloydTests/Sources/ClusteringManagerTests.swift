import XCTest
import MapKit
@testable import PinFloyd

final class ClusteringManagerTests: XCTestCase {
  var manager: ClusteringManager!
  var mapView: MKMapView!
  var annotations: [MKAnnotation] = []

  override func setUp() {
    super.setUp()
    manager = ClusteringManager()
    mapView = MKMapView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
    annotations = [
      // Berlin Cathedral, Berlin, Germany
      Annotation(mapPoint: MKMapPointForCoordinate(CLLocationCoordinate2D(latitude: 52.518898, longitude: 13.401797))),
      // Berlin Central and Regional Library, Berlin, Germany
      Annotation(mapPoint: MKMapPointForCoordinate(CLLocationCoordinate2D(latitude:52.496517, longitude:  13.392376))),
      // Berlin State Library, Berlin, Germany
      Annotation(mapPoint: MKMapPointForCoordinate(CLLocationCoordinate2D(latitude:52.507675, longitude:  13.370528)))
    ]
  }

  override func tearDown() {
    manager.removeAll()
    super.tearDown()
  }

  func testRenderAnnotationsWithZoomLevel16() {
    let expectation = self.expectation(description: "Render annotations")
    let coordinate = annotations[0].coordinate
    let region = MKCoordinateRegionMakeWithDistance(coordinate, 10000, 10000)
    mapView.setRegion(region, animated: false)
    XCTAssertEqual(mapView.zoomLevel, 12)

    manager.add(annotations: annotations)
    manager.renderAnnotations(onMapView: mapView) { mapView in
      XCTAssertEqual(mapView.annotations.count, 2)
      XCTAssertEqual(mapView.annotations.filter({ $0 is ClusterAnnotation }).count, 1)
      expectation.fulfill()
    }

    waitForExpectations(timeout: 4, handler: nil)
  }

  func testRenderAnnotationsWithZoomLevel21() {
    let expectation = self.expectation(description: "Render annotations")
    let coordinate = annotations[0].coordinate
    let region = MKCoordinateRegionMakeWithDistance(coordinate, 5000, 5000)
    mapView.setRegion(region, animated: false)
    XCTAssertEqual(mapView.zoomLevel, 13)

    manager.add(annotations: annotations)
    manager.renderAnnotations(onMapView: mapView) { mapView in
      XCTAssertEqual(mapView.annotations.count, 3)
      XCTAssertTrue(mapView.annotations.filter({ $0 is ClusterAnnotation }).isEmpty)
      expectation.fulfill()
    }

    waitForExpectations(timeout: 4, handler: nil)
  }
}
