import XCTest
import MapKit
@testable import PinFloyd

class ClusteringManagerTests: XCTestCase {

  var manager: ClusteringManager!
  var mapView: MKMapView!
  var annotations: [MKAnnotation] = []

  override func setUp() {
    super.setUp()
    manager = ClusteringManager()
    mapView = MKMapView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
    annotations = [
      // First cluster
      Annotation(mapPoint: MKMapPoint(x: 142238217, y: 78053902.0)),
      Annotation(mapPoint: MKMapPoint(x: 141674269, y: 79422844.3)),
      Annotation(mapPoint: MKMapPoint(x: 141674270, y: 79422844.3)),
      Annotation(mapPoint: MKMapPoint(x: 141674480, y: 79422954.3)),
      // Second cluster
      Annotation(mapPoint: MKMapPoint(x: -181674380, y: 79422954.3)),
      Annotation(mapPoint: MKMapPoint(x: -181674280, y: 79422854.3)),
    ]
  }

  override func tearDown() {
    manager.removeAll()
    super.tearDown()
  }

  func testRenderAnnotations() {
    let expectation = self.expectation(description: "Render annotations")

    manager.add(annotations: annotations)
    manager.renderAnnotations(onMapView: mapView) { mapView in
      // Should not be 2 cluster annotations
      XCTAssertEqual(mapView.annotations.count, 2)
      XCTAssertEqual(mapView.annotations.filter({ $0 is ClusterAnnotation }).count, 2)
      expectation.fulfill()
    }

    waitForExpectations(timeout: 4, handler: nil)
  }

  func testRenderAnnotationsWithZoomLevel16() {
    let expectation = self.expectation(description: "Render annotations")
    let coordinate = MKMapPoint(x: 141674270, y: 79422844.3).coordinate
    let region = MKCoordinateRegionMakeWithDistance(coordinate, 500, 500)
    mapView.setRegion(region, animated: false)

    manager.add(annotations: annotations)
    manager.renderAnnotations(onMapView: mapView) { mapView in
      // Should not be 1 cluster annotation
      XCTAssertEqual(mapView.annotations.count, 1)
      XCTAssertEqual(mapView.annotations.filter({ $0 is ClusterAnnotation }).count, 1)
      expectation.fulfill()
    }

    waitForExpectations(timeout: 4, handler: nil)
  }

  func testRenderAnnotationsWithZoomLevel21() {
    let expectation = self.expectation(description: "Render annotations")
    let coordinate = MKMapPoint(x: -181674380, y: 79422844.3).coordinate
    let region = MKCoordinateRegionMakeWithDistance(coordinate, 10, 10)
    mapView.setRegion(region, animated: false)

    manager.add(annotations: annotations)
    manager.renderAnnotations(onMapView: mapView) { mapView in
      // Should not be any cluster annotations
      XCTAssertEqual(mapView.annotations.count, 2)
      XCTAssertTrue(mapView.annotations.filter({ $0 is ClusterAnnotation }).isEmpty)
      expectation.fulfill()
    }

    waitForExpectations(timeout: 4, handler: nil)
  }
}
