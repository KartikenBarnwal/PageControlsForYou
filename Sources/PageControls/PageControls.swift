//
//  InfinitePageControlsView.swift
//  Infinite Page Controls
//
//  Created by Kartiken Barnwal on 14/12/24.
//

import UIKit

/// Helps you define and customize the page controls at some level
public struct PageControlsForYouConfig {
    public var circleSize: CGFloat
    public var spacing: CGFloat
    public var totalCircles: Int
    public var visibleCircles: Int
    public var smallCircleRatio: CGFloat
    public var circleBackground: UIColor
    public var selectedCircleBackground: UIColor
    
    public init(circleSize: CGFloat = 50,
                spacing: CGFloat = 20,
                totalCircles: Int = 10,
                visibleCircles: Int = 4,
                smallCircleRatio: CGFloat = 0.5,
                circleBackground: UIColor = .systemPink,
                selectedCircleBackground: UIColor = .white
    ) {
        self.circleSize = circleSize
        self.spacing = spacing
        self.totalCircles = totalCircles
        self.visibleCircles = visibleCircles
        self.smallCircleRatio = smallCircleRatio
        self.circleBackground = circleBackground
        self.selectedCircleBackground = selectedCircleBackground
    }
}

public class PageControlsForYouView: UIView {
    
    enum States {
        case first
        case middle
        case last
    }
    
    private var config: PageControlsForYouConfig
    private var circles: [UIView] = []
    private var currentIndex: Int = 0
    private var lastIndex: Int = -1
    private var visibleIndex: Int = 0
    
    public init(frame: CGRect, config: PageControlsForYouConfig) {
        self.config = config
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        self.config = PageControlsForYouConfig()
        super.init(coder: coder)
        setup()
    }

    func setup() {
        
        let totalWidth = config.circleSize * CGFloat(config.visibleCircles) + config.spacing * CGFloat(config.visibleCircles - 1)
        
        var xOffset = (bounds.width - totalWidth) / 2
        let yOffset = (bounds.height - config.circleSize) / 2
        
        for i in 0..<config.visibleCircles {
            let circle = prepareCircleView()
            circle.tag = i
            circle.frame = CGRect(x: xOffset, y: yOffset, width: config.circleSize, height: config.circleSize)
            addSubview(circle)
            circles.append(circle)
            
            xOffset += config.circleSize + config.spacing
        }
        
        update(state: .first, index: 0)
        
    }
    
    func update(state: States, index: Int) {
        
        switch state {
        case .first:
            
            adjustCirclesSize(smallIndices: [config.visibleCircles - 1])
            highlightACircle(index)
            
        case .middle:
            
            // moved forward
            if lastIndex < currentIndex {
                //  if at extreme right - 1
                if visibleIndex == config.visibleCircles - 2 {
                    animateCircleBackward(index)
                } else {
                    visibleIndex += 1
                    highlightACircle(visibleIndex)
                }
            } else {
                //  if at extreme left - 1
                if visibleIndex == 1 {
                    animateCircleForward(index)
                } else {
                    visibleIndex -= 1
                    highlightACircle(visibleIndex)
                }
            }
            
        case .last:
            
            adjustCirclesSize(smallIndices: [0])
            highlightACircle(index)
            
        }
    }
    
    /// asks the InfinitePageControls to move one step before (if it's valid)
    public func prevCircle() {
        lastIndex = currentIndex
        currentIndex -= 1
        if currentIndex < 0 { return }
        updateHelper()
    }
    
    /// asks the InfinitePageControls to move one step after (if it's valid)
    public func nextCircle() {
        lastIndex = currentIndex
        currentIndex += 1
        if currentIndex >= config.totalCircles { return }
        updateHelper()
    }
    
    func updateHelper() {
        var newState: States
        
        if currentIndex <= config.visibleCircles - 2 {
            newState = .first
            visibleIndex = currentIndex
            update(state: newState, index: currentIndex)
        } else if currentIndex >= (config.totalCircles - config.visibleCircles + 1) {
            newState = .last
            let tmpIndex = (currentIndex - (config.totalCircles - config.visibleCircles))
            visibleIndex = tmpIndex
            update(state: newState, index: tmpIndex)
        } else {
            newState = .middle
            update(state: newState, index: config.visibleCircles - 2)
        }
    }
    
    func animateCircleBackward(_ index: Int) {
        circles[config.visibleCircles - 2].backgroundColor = config.circleBackground
        circles[config.visibleCircles - 1].backgroundColor = config.selectedCircleBackground

        // Shift all circles to the new positions
        UIView.animate(withDuration: 0.5, animations: {
            let translation = CGAffineTransform(translationX: -1 * (self.config.circleSize + self.config.spacing), y: 0)
            
            for i in 0..<self.config.visibleCircles {
                if i == 1 {
                    // applying animation for second circle to also get smaller while its translating to left
                    let scaling = CGAffineTransform(scaleX: self.config.smallCircleRatio, y: self.config.smallCircleRatio)
                    self.circles[i].transform = scaling.concatenating(translation)
                } else if i == 0 {
                    // handling first circle to even get smaller and translate a bit less
                    let translation = CGAffineTransform(translationX: -1 * (self.config.circleSize), y: 0)
                    let scaling = CGAffineTransform(scaleX: self.config.smallCircleRatio * self.config.smallCircleRatio, y: self.config.smallCircleRatio * self.config.smallCircleRatio)
                    self.circles[i].transform = scaling.concatenating(translation)
                } else {
                    // for rest of the circles
                    self.circles[i].transform = translation
                }
            }
            
        }) { _ in
            // Reset transformations
            for circle in self.circles {
                circle.transform = .identity
            }
            
            self.circles[self.config.visibleCircles - 2].backgroundColor = self.config.selectedCircleBackground
            self.circles[self.config.visibleCircles - 1].backgroundColor = self.config.circleBackground
            
            self.adjustCirclesSize(smallIndices: [0, self.config.visibleCircles - 1])
            
        }
    }
    
    func animateCircleForward(_ index: Int) {
        circles[1].backgroundColor = config.circleBackground
        circles[0].backgroundColor = config.selectedCircleBackground

        // Shift all circles to the new positions
        UIView.animate(withDuration: 0.5, animations: {
            let translation = CGAffineTransform(translationX: (self.config.circleSize + self.config.spacing), y: 0)
            
            for i in 0..<self.config.visibleCircles {
                if i == self.config.visibleCircles - 2 {
                    // applying animation for second circle to also get smaller while its translating to left
                    let scaling = CGAffineTransform(scaleX: self.config.smallCircleRatio, y: self.config.smallCircleRatio)
                    self.circles[i].transform = scaling.concatenating(translation)
                } else if i == self.config.visibleCircles - 1 {
                    // handling first circle to even get smaller and translate a bit less
                    let translation = CGAffineTransform(translationX: (self.config.circleSize), y: 0)
                    let scaling = CGAffineTransform(scaleX: self.config.smallCircleRatio * self.config.smallCircleRatio, y: self.config.smallCircleRatio * self.config.smallCircleRatio)
                    self.circles[i].transform = scaling.concatenating(translation)
                } else {
                    // for rest of the circles
                    self.circles[i].transform = translation
                }
            }
            
        }) { _ in
            // Reset transformations
            for circle in self.circles {
                circle.transform = .identity
            }
            
            self.circles[1].backgroundColor = self.config.selectedCircleBackground
            self.circles[0].backgroundColor = self.config.circleBackground
            
            self.adjustCirclesSize(smallIndices: [0, self.config.visibleCircles - 1])
            
        }
    }
    
    func adjustCirclesSize(smallIndices: [Int]) {
        for i in 0..<config.visibleCircles {
            if smallIndices.contains(i) {
                circles[i].transform = CGAffineTransform(scaleX: config.smallCircleRatio, y: config.smallCircleRatio)
            } else {
                circles[i].transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        }
    }
    
    func highlightACircle(_ index: Int) {
        for i in 0..<config.visibleCircles {
            circles[i].backgroundColor = (i == index) ? config.selectedCircleBackground : config.circleBackground
        }
    }
    
    func prepareCircleView() -> UIView {
        let circle = UIView()
        circle.backgroundColor = config.circleBackground
        circle.clipsToBounds = true
        circle.layer.cornerRadius = config.circleSize / 2
        
        return circle
    }

}
