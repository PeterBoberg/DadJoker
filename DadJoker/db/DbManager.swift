//
// Created by Peter Boberg on 2017-12-27.
// Copyright (c) 2017 PeterBobergAB. All rights reserved.
//

import Foundation
import CoreData
import Dispatch
import UIKit

class DbManager {

    var context: NSManagedObjectContext? = nil
    let mainQueue = DispatchQueue.main
    let workerQueue = DispatchQueue.global(qos: .userInitiated)

    static let shared = DbManager()

    private init() {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            print("DbManager instantiation error could not load app delegate")
            return
        }
        self.context = delegate.persistentContainer.viewContext
    }

    func fetchAllJokes(completion: @escaping ([JokeModel]?, Error?) -> Void) {

        workerQueue.async(execute: {
            guard let context = self.context else {
                print("Db context not existing")
                completion(nil, NSError())
                return
            }
            do {
                let fetchRequest: NSFetchRequest<JokeModel> = JokeModel.fetchRequest()
                let jokes: [JokeModel] = try context.fetch(fetchRequest)
                self.mainQueue.async(execute: {
                    completion(jokes, nil)
                })

            } catch let error {
                print("Db context not existing: \(error.localizedDescription)")
                completion(nil, NSError())
            }
        })
    }

    func saveNewJoke(id: String, joke: String, completion: @escaping (Error?) -> Void) {
        workerQueue.async(execute: {
            guard let context = self.context else {
                print("Db context not existing")
                completion(NSError())
                return
            }
            do {
                let jokeModel: JokeModel = JokeModel(entity: JokeModel.entity(), insertInto: context)
                jokeModel.id = id
                jokeModel.joke = joke
                try context.save()
                self.mainQueue.async(execute: {
                    completion(nil)
                })
            } catch let error {
                print("Could not save new joke: \(error.localizedDescription)")
                completion(NSError())
            }
        })
    }
}
