import Foundation
import MapKit

public final class ClusteringManager {

  public typealias Completion = (MKMapView) -> Void

  public var filterAnnotations: (MKAnnotation) -> Bool = { _ in return true }
  private let rootNode: QuadTreeNode = QuadTreeNode(rect: MKMapRectWorld, capacity: 8)

  public init(annotations: [MKAnnotation] = []) {
    add(annotations: annotations)
  }

  // MARK: - Annotations

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

  public func renderAnnotations(onMapView mapView: MKMapView, completion: Completion? = nil) {
    DispatchQueue.global(qos: .userInitiated).async { [weak self, weak mapView] in
      guard let strongSelf = self, let mapView = mapView else {
        return
      }

      let annotations = strongSelf.clusteredAnnotations(onMapView: mapView)
      strongSelf.reload(annotations: annotations, onMapView: mapView, completion: completion)
    }
  }

  public func clusterAnnotationView(for annotation: MKAnnotation, mapView: MKMapView) -> MKAnnotationView? {
    guard let annotation = annotation as? ClusterAnnotation else {
      return nil
    }

    let id = ClusterAnnotationView.identifier
    var clusterView = mapView.dequeueReusableAnnotationView(withIdentifier: id)

    if clusterView == nil {
      clusterView = ClusterAnnotationView(annotation: annotation, reuseIdentifier: id)
    } else {
      clusterView?.annotation = annotation
    }

    clusterView?.canShowCallout = false

    return clusterView
  }

  public func animate(annotationViews: [MKAnnotationView], animation: AnnotationAnimation = .bounce) {
    let animator = animation.createAnimator()
    animator.animate(views: annotationViews)
  }

  private func clusterAnnotation(for coordinate: CLLocationCoordinate2D,
                                 annotationsCount: Int,
                                 visibleAnnotations: [MKAnnotation]) -> MKAnnotation {
    let filter: (MKAnnotation) -> Bool = { annotation in
      guard let annotation = annotation as? ClusterAnnotation else {
        return false
      }
      return annotation.annotationsCount == annotationsCount && annotation.coordinate == coordinate
    }

    guard let clusterAnnotation = visibleAnnotations.first(where: filter) else {
      return ClusterAnnotation(coordinate: coordinate, annotationsCount: annotationsCount)
    }

    return clusterAnnotation
  }


  // MARK: - Clustering

  private func clusteredAnnotations(onMapView mapView: MKMapView) -> [MKAnnotation] {
    guard !mapView.zoomScale.isInfinite else {
      return []
    }

    let tile = mapView.tile
    let scaleFactor = mapView.scaleFactor
    let visibleAnnotations = mapView.annotations
    var clusteredAnnotations = [MKAnnotation]()

    // Iterate through the bounding box points
    for x in tile.minX...tile.maxX {
      for y in tile.minY...tile.maxY {
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

          clusteredAnnotations.append(clusterAnnotation(
            for: clusterMapPoint.coordinate,
            annotationsCount: annotations.count, visibleAnnotations: visibleAnnotations
          ))
        }
      }
    }

    return clusteredAnnotations
  }

  // Add only the annotations we need in the current region
  // https://robots.thoughtbot.com/how-to-handle-large-amounts-of-data-on-maps#adding-only-the-annotations-we-need
  private func reload(annotations: [MKAnnotation], onMapView mapView: MKMapView, completion: Completion?) {
    let mapAnnotations = mapView.annotations.filter(filterAnnotations)
    let currentSet = NSMutableSet(array: mapAnnotations)
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
    DispatchQueue.main.async { [weak mapView] in
      guard let mapView = mapView else {
        return
      }

      if let toAddAnnotations = setToAdd.allObjects as? [MKAnnotation] {
        mapView.addAnnotations(toAddAnnotations)
      }

      if let removeAnnotations = setToRemove.allObjects as? [MKAnnotation] {
        mapView.removeAnnotations(removeAnnotations)
      }
      
      completion?(mapView)
    }
  }
}
