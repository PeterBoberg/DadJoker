//
// Created by Peter Boberg on 2017-12-07.
// Copyright (c) 2017 PeterBobergAB. All rights reserved.
//

import Foundation
import Unbox

class ApiService {

    static let shared = ApiService()

    private var apiClient = ApiClient.shared

    private init() {
    }

    func getRandomJoke(completionHandler: @escaping (DadJoke) -> Void) {
        apiClient.getRandomJoke(completionHandler: { (data, error) in
            guard let data = data else {
                print(error?.localizedDescription)
                return
            }

            do {
                let dadJoke: DadJoke = try unbox(data: data)
                completionHandler(dadJoke)
            } catch let unboxError {
                print(unboxError.localizedDescription)
            }
        })
    }

    func getJokeImage(joke: DadJoke, completionHandler: @escaping (UIImage) -> Void) {
        apiClient.getImageForJoke(jokeId: joke.id, completionHandler: { (data, error) in
            guard let data = data else {
                print(error?.localizedDescription)
                return
            }

            guard let image = UIImage(data: data) else {
                print("Can not load image from data")
                return
            }

            completionHandler(image)
        })
    }
}
