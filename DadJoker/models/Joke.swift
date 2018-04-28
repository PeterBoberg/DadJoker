//
// Created by Peter Boberg on 2017-12-07.
// Copyright (c) 2017 PeterBobergAB. All rights reserved.
//

import Foundation
import Unbox

struct DadJoke {
    let id: String
    let joke: String
}

extension DadJoke: Unboxable {

    init(unboxer u: Unboxer) throws {
        self.id = try u.unbox(key: "id")
        self.joke = try u.unbox(key: "joke")
    }
}
