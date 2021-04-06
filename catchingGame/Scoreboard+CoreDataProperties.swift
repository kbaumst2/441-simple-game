//
//  Scoreboard+CoreDataProperties.swift
//  catchingGame
//
//  Created by Kate Baumstein on 3/29/21.
//
//

import Foundation
import CoreData


extension Scoreboard {

    @nonobjc public class func scoreboardFetchRequest() -> NSFetchRequest<Scoreboard> {
        return NSFetchRequest<Scoreboard>(entityName: "Scoreboard")
    }

    @NSManaged public var highScore: Int64

}

extension Scoreboard : Identifiable {

}
