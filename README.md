# PageControlsForYou
PageControlsForYou is a customizable and lightweight library for adding infinite scrolling page controls to iOS apps.

## Demo
![Demo](/Assets/demo.gif)

Watch out the repo `https://github.com/KartikenBarnwal/DemoPageControls` for demo

## Support Me

If you find this project useful, please toss me a coffee:

<a href="https://buymeacoffee.com/kartiken" target="_blank" rel="noopener noreferrer"><img src="https://www.codehim.com/wp-content/uploads/2022/09/bmc-button.png" width="200"><a/>


## Features
- Supports infinite scrolling
- Customizable using a configuration object
- Smooth animations for transitions

## Installation

Use Swift Package Manager to add `PageControlsForYou` to your project:

1. Go to **File > Add Packages** in Xcode.
2. Enter the repository URL: `https://github.com/KartikenBarnwal/PageControlsForYou`.

## Usage

```swift
import PageControlsForYou

let config = PageControlsForYouConfig(
    circleSize: 40,
    spacing: 15,
    totalCircles: 8,
    visibleCircles: 3,
    smallCircleRatio: 0.6
)

let pageControl = PageControlsForYouView(frame: CGRect(x: 20, y: 100, width: 300, height: 60), config: config)
view.addSubview(pageControl)

// Navigate circles
pageControls.toCircle(index: 2)
pageControl.nextCircle()
pageControl.prevCircle()


// setup the view programmatically - just need a wrapper UIView and its reference
func setupPageControlsProgrammatically() {
    let config = PageControlsForYouConfig(circleSize: 20, spacing: 10, totalCircles: items.count, circleBackground: .gray, selectedCircleBackground: .black)

    pageControls?.translatesAutoresizingMaskIntoConstraints = false
    pageControls = PageControlsForYou(frame: pageControlsWrapper.bounds, config: config)
    pageControlsWrapper.addSubview(pageControls!)
}

// setup the view from a storyboard instance - just need a UIView now referenced to PageControlsForYou class of the module 
func setupPageControlsFromStoryboard() {
    let config = PageControlsForYouConfig(circleSize: 20, spacing: 10, totalCircles: items.count, circleBackground: .gray, selectedCircleBackground: .black)
    
    pageControlsView.configure(with: config)
}

```
