//
// Created by Peter Boberg on 2017-12-27.
// Copyright (c) 2017 PeterBobergAB. All rights reserved.
//

import Foundation

class DbService {

    static let shared = DbService()

    private let dbManager = DbManager.shared

    private init() {
    }

    func save(joke: DadJoke, completion: @escaping (Error?) -> Void) {
        self.dbManager.saveNewJoke(id: joke.id, joke: joke.joke, completion: completion)
    }

    func getAllJokes(completion: @escaping ([DadJoke]?, Error?) -> Void) {
        self.dbManager.fetchAllJokes(completion: { (jokeModels, error) in
            if let jokeModels = jokeModels {
                var jokes: [DadJoke] = jokeModels.map({ (jokeModel) in
                    return DadJoke(id: jokeModel.id ?? "", joke: jokeModel.joke ?? "")
                })

                completion(jokes, nil)
                return
            }
            completion(nil, error)
        })
    }
}
