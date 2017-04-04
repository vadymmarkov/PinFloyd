import MapKit

// Annotation animation

public enum AnnotationAnimation {
  case bounce, fade

  func createAnimator() -> AnnotationAnimator {
    switch self {
    case .bounce:
      return BounceAnnotationAnimator()
    case .fade:
      return FadeAnnotationAnimator()
    }
  }
}

// MARK: - Protocol

protocol AnnotationAnimator {
  func animate(views: [MKAnnotationView])
  func animate(view: MKAnnotationView)
}

extension AnnotationAnimator {

  func animate(views: [MKAnnotationView]) {
    for view in views {
      animate(view: view)
    }
  }
}

// MARK: - Bounce

final class BounceAnnotationAnimator: AnnotationAnimator {

  func animate(view: MKAnnotationView) {
    let animationKey = "annotationBounce"
    let animation = CAKeyframeAnimation.init(keyPath: "transform.scale")
    var timingFunctions = [CAMediaTimingFunction]()

    animation.values = [0.5, 1.1, 0.9, 1]
    animation.duration = 0.5

    for _ in 0..<4 {
      timingFunctions.append(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
    }

    animation.timingFunctions = timingFunctions
    animation.isRemovedOnCompletion = false

    view.layer.add(animation, forKey: animationKey)
  }
}

// MARK: - Fade

final class FadeAnnotationAnimator: AnnotationAnimator {

  func animate(view: MKAnnotationView) {
    view.alpha = 0

    UIView.animate(withDuration: 0.3) {
      view.alpha = 1
    }
  }
}
