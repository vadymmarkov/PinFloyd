# PinFloyd

[![CI Status](http://img.shields.io/travis/hyperoslo/PinFloyd.svg?style=flat)](https://travis-ci.org/hyperoslo/PinFloyd)
[![Version](https://img.shields.io/cocoapods/v/PinFloyd.svg?style=flat)](http://cocoadocs.org/docsets/PinFloyd)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/cocoapods/l/PinFloyd.svg?style=flat)](http://cocoadocs.org/docsets/PinFloyd)
[![Platform](https://img.shields.io/cocoapods/p/PinFloyd.svg?style=flat)](http://cocoadocs.org/docsets/PinFloyd)
![Swift](https://img.shields.io/badge/%20in-swift%203.0-orange.svg)

## Description

MapKit annotations clustering for iOS.

## Usage
Create an instance of `ClusteringManager`:
```swift
let clusteringManager = ClusteringManager()
```

Add annotations:
```swift
clusteringManager.add(annotations: annotations)
```

Replace annotations:
```swift
clusteringManager.replace(annotations: annotations)
```

Render annotations on region change:
```swift
// MKMapViewDelegate
func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
  clusteringManager.renderAnnotations(onMapView: mapView)
}
```

Reuse annotation view: 
```swift
func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
  switch annotation {
  case let annotation as ClusterAnnotation:
    let id = ClusterAnnotationView.identifier

    var clusterView = mapView.dequeueReusableAnnotationView(withIdentifier: id)
    if clusterView == nil {
      clusterView = ClusterAnnotationView(annotation: annotation, reuseIdentifier: id)
    } else {
      clusterView?.annotation = annotation
    }

    return clusterView
  default:
    // return annotation view
}
```

## Installation

**PinFloyd** is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'PinFloyd'
```

**PinFloyd** is also available through [Carthage](https://github.com/Carthage/Carthage).
To install just write into your Cartfile:

```ruby
github "hyperoslo/PinFloyd"
```

**PinFloyd** can also be installed manually. Just download and drop `Sources` folders in your project.

## Author

Hyper Interaktiv AS, ios@hyper.no

## Contributing

We would love you to contribute to **PinFloyd**, check the [CONTRIBUTING](https://github.com/hyperoslo/PinFloyd/blob/master/CONTRIBUTING.md) file for more info.

## License

**PinFloyd** is available under the MIT license. See the [LICENSE](https://github.com/hyperoslo/PinFloyd/blob/master/LICENSE.md) file for more info.
