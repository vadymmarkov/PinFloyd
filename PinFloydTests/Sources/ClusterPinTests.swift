import XCTest
@testable import PinFloyd

class ClusterPinTests: XCTestCase {

  func testCreateClusterPin() {
    var pin: ClusterPin

    // 0...10
    pin = ClusterPin.createClusterPin(forCount: 5)
    XCTAssertEqual(pin.text, "5")
    XCTAssertEqual(pin.color, PinColor.extraSmall.color)
    XCTAssertEqual(pin.size, 40)

    pin = ClusterPin.createClusterPin(forCount: 10)
    XCTAssertEqual(pin.text, "10")
    XCTAssertEqual(pin.color, PinColor.extraSmall.color)
    XCTAssertEqual(pin.size, 40)

    // 11...19
    pin = ClusterPin.createClusterPin(forCount: 11)
    XCTAssertEqual(pin.text, "10+")
    XCTAssertEqual(pin.color, PinColor.extraSmall.color)
    XCTAssertEqual(pin.size, 40)

    pin = ClusterPin.createClusterPin(forCount: 19)
    XCTAssertEqual(pin.text, "10+")
    XCTAssertEqual(pin.color, PinColor.extraSmall.color)
    XCTAssertEqual(pin.size, 40)

    // 20...49:
    pin = ClusterPin.createClusterPin(forCount: 20)
    XCTAssertEqual(pin.text, "20+")
    XCTAssertEqual(pin.color, PinColor.small.color)
    XCTAssertEqual(pin.size, 45)

    pin = ClusterPin.createClusterPin(forCount: 49)
    XCTAssertEqual(pin.text, "20+")
    XCTAssertEqual(pin.color, PinColor.small.color)
    XCTAssertEqual(pin.size, 45)

    // 50...99:
    pin = ClusterPin.createClusterPin(forCount: 50)
    XCTAssertEqual(pin.text, "50+")
    XCTAssertEqual(pin.color, PinColor.medium.color)
    XCTAssertEqual(pin.size, 45)

    pin = ClusterPin.createClusterPin(forCount: 99)
    XCTAssertEqual(pin.text, "50+")
    XCTAssertEqual(pin.color, PinColor.medium.color)
    XCTAssertEqual(pin.size, 45)

    // 100...199:
    pin = ClusterPin.createClusterPin(forCount: 100)
    XCTAssertEqual(pin.text, "100+")
    XCTAssertEqual(pin.color, PinColor.large.color)
    XCTAssertEqual(pin.size, 55)

    pin = ClusterPin.createClusterPin(forCount: 199)
    XCTAssertEqual(pin.text, "100+")
    XCTAssertEqual(pin.color, PinColor.large.color)
    XCTAssertEqual(pin.size, 55)

    // >= 200
    pin = ClusterPin.createClusterPin(forCount: 200)
    XCTAssertEqual(pin.text, "200+")
    XCTAssertEqual(pin.color, PinColor.extraLarge.color)
    XCTAssertEqual(pin.size, 55)

    pin = ClusterPin.createClusterPin(forCount: 1000)
    XCTAssertEqual(pin.text, "200+")
    XCTAssertEqual(pin.color, PinColor.extraLarge.color)
    XCTAssertEqual(pin.size, 55)
  }
}
