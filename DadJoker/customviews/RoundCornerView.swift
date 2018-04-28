//
// Created by Peter Boberg on 2017-12-11.
// Copyright (c) 2017 PeterBobergAB. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class RoundCornerView: UIView {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            configure()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    private func configure() {
        self.clipsToBounds = true
        self.layer.cornerRadius = self.cornerRadius
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 2
    }
}
