import MapKit

// MARK: - Tree node

final class QuadTreeNode {

  private let capacity: Int
  private let rect: MKMapRect
  private var children: [QuadTreeNode] = []
  private var annotations: [MKAnnotation] = []

  var isLeaf: Bool {
    return children.isEmpty
  }

  init(rect: MKMapRect, capacity: Int) {
    self.rect = rect
    self.capacity = capacity
  }

  @discardableResult
  func add(annotation: MKAnnotation) -> Bool {
    guard rect.contains(annotation: annotation) else {
      return false
    }

    if isLeaf {
      annotations.append(annotation)
      // Subdivide if needed
      if annotations.count == capacity {
        children = createChildren()
      }
    } else {
      for child in children {
        if child.add(annotation: annotation) {
          return true
        }
      }

      return false
    }

    return true
  }

  func annotations(inRect rect: MKMapRect) -> [MKAnnotation] {
    guard self.rect.intersects(rect: rect) else {
      return []
    }

    var result: [MKAnnotation] = []
    let filteredAnnotations = annotations.filter({ rect.contains(annotation: $0) })

    for annotation in filteredAnnotations {
      result.append(annotation)
    }

    for child in children {
      result.append(contentsOf: child.annotations(inRect: rect))
    }

    return result
  }

  func removeAll() {
    annotations.removeAll()

    for child in children {
      child.removeAll()
    }

    children.removeAll()
  }

  private func createChildren() -> [QuadTreeNode] {
    let northWest = QuadTreeNode(rect: rect.northWestRect, capacity: capacity)
    let northEast = QuadTreeNode(rect: rect.northEastRect, capacity: capacity)
    let southWest = QuadTreeNode(rect: rect.southWestRect, capacity: capacity)
    let southEast = QuadTreeNode(rect: rect.southEastRect, capacity: capacity)

    return [northWest, northEast, southWest, southEast]
  }
}
