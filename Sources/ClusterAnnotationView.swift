import UIKit
import MapKit

open class ClusterAnnotationView: MKAnnotationView {

  public static var identifier: String {
    return String(reflecting: self)
  }

  public lazy var textLabel: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.font = .boldSystemFont(ofSize: 13)
    label.textAlignment = .center
    label.numberOfLines = 1
    label.adjustsFontSizeToFitWidth = true
    label.minimumScaleFactor = 0.5

    return label
  }()

  open override var annotation: MKAnnotation? {
    didSet {
      configure(annotation: annotation)
    }
  }

  // MARK: - Init

  public override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
    super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    setup()
  }

  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }

  // MARK: - Layout

  open override func layoutSubviews() {
    super.layoutSubviews()
    textLabel.frame = bounds
    layer.cornerRadius = bounds.size.height / 2
  }

  // MARK: - Setup

  private func setup() {
    layer.borderWidth = 3
    layer.borderColor = UIColor.white.withAlphaComponent(0.8).cgColor
    addSubview(textLabel)
  }

  open func configure(annotation: MKAnnotation?) {
    guard let annotation = annotation as? ClusterAnnotation else {
      return
    }

    let pin = ClusterPin.createClusterPin(forCount: annotation.annotationsCount)
    backgroundColor = pin.color
    frame.size = CGSize(width: pin.size, height: pin.size)
    textLabel.text = pin.text
  }
}
