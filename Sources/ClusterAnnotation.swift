import Foundation
import MapKit

public class ClusterAnnotation: NSObject, MKAnnotation {

  public let coordinate: CLLocationCoordinate2D
  public let annotationsCount: Int
  public var title: String?
  public var subtitle: String?

  init(coordinate: CLLocationCoordinate2D, annotationsCount: Int) {
    self.coordinate = coordinate
    self.annotationsCount = annotationsCount
  }
}
