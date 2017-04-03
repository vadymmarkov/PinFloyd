import XCTest
import CoreLocation
@testable import PinFloyd

class ClusterAnnotationViewTests: XCTestCase {

  var view: ClusterAnnotationView!
  var annotation: ClusterAnnotation!

  override func setUp() {
    super.setUp()
    let coordinate = CLLocationCoordinate2D(latitude: 59.932646, longitude: 10.756316)
    annotation = ClusterAnnotation(coordinate: coordinate, annotationsCount: 11)
    view = ClusterAnnotationView(annotation: annotation, reuseIdentifier: ClusterAnnotationView.identifier)
  }

  func testIdentifier() {
    XCTAssertEqual(ClusterAnnotationView.identifier, String(reflecting: ClusterAnnotationView.self))
  }

  func testInit() {
    XCTAssertEqual(view.annotation as? ClusterAnnotation, annotation)
    XCTAssertEqual(view.reuseIdentifier, ClusterAnnotationView.identifier)
    XCTAssertEqual(view.subviews.count, 1)
    XCTAssertEqual(view.layer.borderColor, UIColor.white.withAlphaComponent(0.8).cgColor)
    XCTAssertEqual(view.layer.borderWidth, 3.0)
  }

  func testTextLabel() {
    let label = view.textLabel

    XCTAssertNotNil(label.superview)
    XCTAssertEqual(label.textColor, .white)
    XCTAssertEqual(label.font, .boldSystemFont(ofSize: 13))
    XCTAssertEqual(label.textAlignment, .center)
    XCTAssertEqual(label.numberOfLines, 1)
    XCTAssertTrue(label.adjustsFontSizeToFitWidth)
    XCTAssertEqual(label.minimumScaleFactor, 0.5)
  }

  func testLayoutSubviews() {
    let rect = CGRect(x: 0, y: 0, width: 50, height: 50)
    view.frame = rect
    view.layoutSubviews()

    XCTAssertEqual(view.textLabel.frame, rect)
    XCTAssertEqual(view.layer.cornerRadius, 25)
  }
  
  func testConfigure() {
    view.configure(annotation: annotation)

    XCTAssertEqual(view.backgroundColor, PinColor.extraSmall.color)
    XCTAssertEqual(view.frame.size, CGSize(width: 40, height: 40))
    XCTAssertEqual(view.textLabel.text, "10+")
  }

  func testConfigureWithNoAnnotation() {
    view = ClusterAnnotationView(annotation: nil, reuseIdentifier: ClusterAnnotationView.identifier)
    view.configure(annotation: nil)

    XCTAssertNil(view.backgroundColor)
    XCTAssertEqual(view.frame.size, CGSize(width: 0, height: 0))
    XCTAssertNil(view.textLabel.text)
  }
}
