import XCTest
import MapKit
@testable import PinFloyd

class QuadTreeNodeTests: XCTestCase {

  var node: QuadTreeNode!
  var mapRect: MKMapRect!

  override func setUp() {
    super.setUp()
    mapRect = MKMapRect(
      origin: MKMapPoint(x: 141674268, y: 79422844),
      size: MKMapSize(width: 5000, height: 5000)
    )
    node = QuadTreeNode(rect: mapRect, capacity: 4)
  }

  func testCoordinate() {
    XCTAssertTrue(node.annotations(inRect: mapRect).isEmpty)

    // Rect does not containt a point
    XCTAssertFalse(node.add(
      annotation: Annotation(mapPoint: MKMapPoint(x: 142238217, y: 78053902.0)))
    )
    XCTAssertTrue(node.isLeaf)
    XCTAssertTrue(node.annotations(inRect: mapRect).isEmpty)

    // 1. Rect containts a point
    XCTAssertTrue(node.add(
      annotation: Annotation(mapPoint: MKMapPoint(x: 141674269, y: 79422844.3))
    ))
    XCTAssertTrue(node.isLeaf)
    XCTAssertEqual(node.annotations(inRect: mapRect).count, 1)

    // 2. Rect containts a point
    XCTAssertTrue(node.add(
      annotation: Annotation(mapPoint: MKMapPoint(x: 141674270, y: 79422844.3))
    ))
    XCTAssertTrue(node.isLeaf)
    XCTAssertEqual(node.annotations(inRect: mapRect).count, 2)

    // 3. Rect containts a point
    XCTAssertTrue(node.add(
      annotation: Annotation(mapPoint: MKMapPoint(x: 141674480, y: 79422954.3))
    ))
    XCTAssertTrue(node.isLeaf)
    XCTAssertEqual(node.annotations(inRect: mapRect).count, 3)

    // 4. Rect containts a point, node should be subdivided
    XCTAssertTrue(node.add(
      annotation: Annotation(mapPoint: MKMapPoint(x: 141674380, y: 79422954.3))
    ))
    XCTAssertTrue(!node.isLeaf)
    XCTAssertEqual(node.annotations(inRect: mapRect).count, 4)

    // 5. Rect containts a point
    XCTAssertTrue(node.add(
      annotation: Annotation(mapPoint: MKMapPoint(x: 141674280, y: 79422854.3))
    ))
    XCTAssertTrue(!node.isLeaf)
    XCTAssertEqual(node.annotations(inRect: mapRect).count, 5)

    // Find annotations within a rect
    let rect = MKMapRect(
      origin: MKMapPoint(x: 141674268, y: 79422844),
      size: MKMapSize(width: 100, height: 100)
    )
    XCTAssertEqual(node.annotations(inRect: rect).count, 3)
  }
}
