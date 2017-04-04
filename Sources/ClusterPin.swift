import UIKit

// MARK: - Pin color

enum PinColor {
  case extraSmall, small, medium, large, extraLarge

  var color: UIColor {
    switch self {
    case .extraSmall:
      return UIColor(red: 0.07, green: 0.35, blue: 0.58, alpha: 1.00)
    case .small:
      return UIColor(red: 0.11, green: 0.48, blue: 0.59, alpha: 1.00)
    case .medium:
      return UIColor(red:0.13, green:0.59, blue:0.35, alpha:1.00)
    case .large:
      return UIColor(red: 0.25, green: 0.59, blue: 0.14, alpha: 1.00)
    case .extraLarge:
      return UIColor(red: 0.58, green: 0.24, blue: 0.09, alpha: 1.00)
    }
  }
}

// MARK: - Cluster pin

struct ClusterPin {

  let text: String
  let color: UIColor
  let size: CGFloat

  static func createClusterPin(forCount count: Int) -> ClusterPin {
    switch count {
    case 0...10:
      return ClusterPin(
        text: "\(count)",
        color: PinColor.extraSmall.color,
        size: 40
      )
    case 11...19:
      return ClusterPin(
        text: "10+",
        color: PinColor.extraSmall.color,
        size: 40
      )
    case 20...49:
      return ClusterPin(
        text: "20+",
        color: PinColor.small.color,
        size: 45
      )
    case 50...99:
      return ClusterPin(
        text: "50+",
        color: PinColor.medium.color,
        size: 45
      )
    case 100...199:
      return ClusterPin(
        text: "100+",
        color: PinColor.large.color,
        size: 55
      )
    default:
      return ClusterPin(
        text: "200+",
        color: PinColor.extraLarge.color,
        size: 55
      )
    }
  }
}
