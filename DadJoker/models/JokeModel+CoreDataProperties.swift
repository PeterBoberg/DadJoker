//
//  JokeModel+CoreDataProperties.swift
//  DadJoker
//
//  Created by Peter Boberg on 2017-12-27.
//  Copyright © 2017 PeterBobergAB. All rights reserved.
//
//

import Foundation
import CoreData

extension JokeModel {

    public class func fetchRequest() -> NSFetchRequest<JokeModel> {
        return NSFetchRequest<JokeModel>(entityName: "JokeModel")
    }

    @NSManaged public var id: String?
    @NSManaged public var joke: String?

}
