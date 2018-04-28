//
// Created by Peter Boberg on 2017-12-07.
// Copyright (c) 2017 PeterBobergAB. All rights reserved.
//

import Foundation
import Alamofire

private struct ApiUrls {
    static let baseUrl = "https://icanhazdadjoke.com"

    struct Paths {
        static let randomJokePath = "/"
        static let specificJokePath = "/j"
    }
}
class ApiClient {

    static let shared = ApiClient()

    private let networkInterceptor = NetworkInterceptor.shared

    private init() {}

    func getRandomJoke(completionHandler: @escaping (Data?, Error?) -> Void) {
        if let url = getUrlForPath(path: ApiUrls.Paths.randomJokePath) {
            let request = URLRequest(url: url)
            networkInterceptor.run(request: request, completionHandler: completionHandler)
        }
    }

    func getImageForJoke(jokeId: String, completionHandler: @escaping (Data?, Error?) -> Void) {
        if let url = getUrlForPath(path: "\(ApiUrls.Paths.specificJokePath)/\(jokeId).png") {
            let request = URLRequest(url: url)
            networkInterceptor.run(request: request, completionHandler: completionHandler)
        }
    }

    private func getUrlForPath(path: String) -> URL? {
        guard let url = URL(string: ApiUrls.baseUrl + path) else {
            print("Error generating path")
            return nil
        }
        return url
    }
}
