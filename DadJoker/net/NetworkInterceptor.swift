//
// Created by Peter Boberg on 2017-12-07.
// Copyright (c) 2017 PeterBobergAB. All rights reserved.
//

import Foundation
import Alamofire

class NetworkInterceptor {

    static let shared = NetworkInterceptor()

    private init() {
    }

    func run(request: URLRequest, completionHandler: @escaping (Data?, Error?) -> Void) {
        let transformedReq = transform(request: request)
        Alamofire.request(transformedReq).validate(statusCode: 200..<300).responseJSON(completionHandler: { (dataResponse) in
            completionHandler(dataResponse.data, dataResponse.error)
        })
    }
}

extension NetworkInterceptor {
    private func transform(request: URLRequest) -> URLRequest {
        var requestCopy = request
        requestCopy.addValue("application/json", forHTTPHeaderField: "Accept")
        requestCopy.addValue("DadJokerApp, peterbob@kth.se", forHTTPHeaderField: "User-Agent")
        return requestCopy
    }
}
