//
// Created by Peter Boberg on 2017-12-11.
// Copyright (c) 2017 PeterBobergAB. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

@IBDesignable
class FortuneWheelView: UIImageView {

    var delegate: FortuneWheelViewDelegate?

    private var recognizer: UIPanGestureRecognizer!
    private var maxSpeed: CGFloat = 0
    private var isSpinning = false

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configure()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
}

// MARK: - CAAnimationDelegate
extension FortuneWheelView: CAAnimationDelegate {

    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.isSpinning = false
        self.delegate?.fortuneWheelDidStop()
    }
}

// MARK: - PRivate Methods
extension FortuneWheelView {

    private func configure() {
        self.isUserInteractionEnabled = true
        self.recognizer = UIPanGestureRecognizer(target: self, action: #selector(self.spin(recognizer:)))
        self.addGestureRecognizer(recognizer)
    }

    @objc private func spin(recognizer: UIPanGestureRecognizer) {
        if (!isSpinning) {
            let velocity = recognizer.velocity(in: self)
            let point = recognizer.location(in: self)
            if isClockWiseRotation(velocity: velocity, touchedPoint: point) {
                let speed = findSpeed(velocity: velocity)
                if speed > maxSpeed {
                    maxSpeed = speed
                }

                if recognizer.state == .began {
                    maxSpeed = 0
                    self.delegate?.fortuneWheelDidStart()
                }

                if recognizer.state == .ended {
                    animateSpin()
                }
            }
        }
    }

    private func isClockWiseRotation(velocity: CGPoint, touchedPoint: CGPoint) -> Bool {
        return (velocity.x > 0 && touchedPoint.y < self.bounds.midY) || (velocity.x < 0 && touchedPoint.y > self.bounds.midY) ||
                (velocity.y > 0 && touchedPoint.x > self.bounds.midX) || (velocity.y < 0 && touchedPoint.x < self.bounds.midX)
    }

    private func findSpeed(velocity: CGPoint) -> CGFloat {
        let vX = abs(velocity.x)
        let vY = abs(velocity.y)
        let speed = sqrt((vX * vX) + (vY * vY))
        return speed
    }

    private func animateSpin() {
        let anim = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        anim.duration = 7.8
        anim.values = [-maxSpeed / 20, 0.0]
        anim.timingFunctions = [CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)]
        anim.isRemovedOnCompletion = false
        anim.fillMode = kCAFillModeForwards
        anim.delegate = self
        self.layer.removeAllAnimations()
        self.layer.add(anim, forKey: "rotate")
        self.isSpinning = true
    }
}

protocol FortuneWheelViewDelegate {
    func fortuneWheelDidStart()
    func fortuneWheelDidStop()
}
