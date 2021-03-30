//
//  Scoreboard.swift
//  catchingGame
//
//  Created by Kate Baumstein on 3/29/21.
//

import UIKit
import CoreData

class CoreDataNotifications{
    
    private static func setContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        return context
    }
    
    static func saveNewScore(newScore: Int64){

        let context = setContext()
        let newScoreboard = Scoreboard(context: context)
        newScoreboard.level = Int64(newScore)
        
        do
        {
            try context.save()
            print("Saved new score.")
        }
        catch { fatalError("Unable to save data.") }
    }
    
    static func loadWithCompletion(completion: @escaping ([Scoreboard]) -> Void) {
        
        let extractValues: [Scoreboard]
        let context = setContext()
        let request = Scoreboard.scoreboardFetchRequest()
        request.returnsObjectsAsFaults = false
        do
        {
            extractValues = try context.fetch(request)
        }
        catch { fatalError("Could not load Data") }
        completion(extractValues)
    }
}
