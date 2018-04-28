//
// Created by Peter Boberg on 2017-12-11.
// Copyright (c) 2017 PeterBobergAB. All rights reserved.
//

import Foundation
import UIKit
import SwiftHEXColors

class ColorService {

    public static let shared = ColorService()

    private init() {
    }

    private let colors = [
        UIColor(hexString: "66ffff", alpha: 0.62),
        UIColor(hexString: "99ff99", alpha: 0.62),
        UIColor(hexString: "ff99ff", alpha: 0.62),
        UIColor(hexString: "9999ff", alpha: 0.62),
        UIColor(hexString: "99ff99", alpha: 0.62),
        UIColor(hexString: "ff6600", alpha: 0.62),
        UIColor(hexString: "ff33cc", alpha: 0.62),
        UIColor(hexString: "cc0099", alpha: 0.62),
        UIColor(hexString: "006699", alpha: 0.62),
        UIColor(hexString: "009933", alpha: 0.62),
        UIColor(hexString: "ffff00", alpha: 0.62),
        UIColor(hexString: "990033", alpha: 0.62),
        UIColor(hexString: "0033cc", alpha: 0.62),
        UIColor(hexString: "006699", alpha: 0.62),
        UIColor(hexString: "9900cc", alpha: 0.62),
        UIColor(hexString: "339966", alpha: 0.62),
        UIColor(hexString: "ccffcc", alpha: 0.62),
    ]

    func getRandomColor() -> UIColor {
        let random = arc4random_uniform(UInt32(colors.count))
        let coloe = colors[Int(random)]
        return colors[Int(random)] ?? UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.62)
    }
}
