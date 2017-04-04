import Foundation
import MapKit

public final class ClusteringManager {

  private let rootNode: QuadTreeNode = QuadTreeNode(rect: MKMapRectWorld, capacity: 8)

  init(annotations: [MKAnnotation] = []) {
    add(annotations: annotations)
  }

  public func add(annotations: [MKAnnotation]) {
    for annotation in annotations {
      rootNode.add(annotation: annotation)
    }
  }

  public func replace(annotations: [MKAnnotation]) {
    removeAll()
    add(annotations: annotations)
  }

  public func removeAll() {
    rootNode.removeAll()
  }

  public func renderAnnotations(onMapView mapView: MKMapView) {
    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
      guard let strongSelf = self else {
        return
      }

      let annotations = strongSelf.clusteredAnnotations(onMapView: mapView)
      strongSelf.reload(annotations: annotations, onMapView: mapView)
    }
  }

  // MARK: - Clustering

  private func clusteredAnnotations(onMapView mapView: MKMapView) -> [MKAnnotation] {
    let boundingBox = mapView.tileBoundingBox
    let scaleFactor = mapView.scaleFactor
    var clusteredAnnotations = [MKAnnotation]()

    // Iterate through the bounding box points
    for x in boundingBox.minX...boundingBox.maxX {
      for y in boundingBox.minY...boundingBox.maxY {
        // Create map rect considering scale factor
        let mapRect = MKMapRect(
          origin: MKMapPoint(x: Double(x) / scaleFactor, y: Double(y) / scaleFactor),
          size: MKMapSize(width: 1.0 / scaleFactor, height: 1.0 / scaleFactor)
        )

        var clusterMapPoint = MKMapPoint(x: 0, y: 0)
        var annotations = [MKAnnotation]()

        // Find annotations within the map rect
        let mapRectAnnotations = rootNode.annotations(inRect: mapRect)

        for annotation in mapRectAnnotations {
          let annotationMapPoint = annotation.mapPoint
          clusterMapPoint.x += annotationMapPoint.x
          clusterMapPoint.y += annotationMapPoint.y
          annotations.append(annotation)
        }

        let count = annotations.count

        if count == 1 {
          // No need for a cluster annotation
          clusteredAnnotations += annotations
        } else if count > 1 {
          // Create a cluster annotation when there is more than 1 annotation
          clusterMapPoint.x /= Double(count)
          clusterMapPoint.y /= Double(count)

          let clusterAnnotation = ClusterAnnotation(
            coordinate: clusterMapPoint.coordinate,
            annotationsCount: annotations.count
          )

          clusteredAnnotations.append(clusterAnnotation)
        }
      }
    }

    return clusteredAnnotations
  }

  private func reload(annotations: [MKAnnotation], onMapView mapView: MKMapView) {
    let currentSet = NSMutableSet(array: mapView.annotations)
    let newSet = NSSet(array: annotations) as Set<NSObject>

    // Remove user location
    currentSet.remove(mapView.userLocation)

    // Keep annotations shared by both sets
    let setToKeep = NSMutableSet(set: currentSet)
    setToKeep.intersect(newSet)

    // Add new annotations
    let setToAdd = NSMutableSet(set: newSet)
    setToAdd.minus(setToKeep as Set<NSObject>)

    // Remove not visible annotations
    let setToRemove = NSMutableSet(set: currentSet)
    setToRemove.minus(newSet)

    // Reload annotations
    DispatchQueue.main.async {
      if let toAddAnnotations = setToAdd.allObjects as? [MKAnnotation] {
        mapView.addAnnotations(toAddAnnotations)
      }

      if let removeAnnotations = setToRemove.allObjects as? [MKAnnotation] {
        mapView.removeAnnotations(removeAnnotations)
      }
    }
  }
}
