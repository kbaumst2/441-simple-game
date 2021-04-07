//
//  GameView.swift
//  carGame
//
//  Created by Kate Baumstein on 3/26/21.
//

import UIKit
import CoreData

class GameView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    var basketImage = UIImage(imageLiteralResourceName: "basket1.png")
    var appleImage = UIImage(imageLiteralResourceName: "apple.png")
    var bananaImage = UIImage(imageLiteralResourceName: "banana.png")
    var orangeImage = UIImage(imageLiteralResourceName: "orange.png")
    var kiwiImage = UIImage(imageLiteralResourceName: "kiwi.png")
   // var strawberryImage = UIImage(imageLiteralResourceName: "strawberry.png")
    var pineappleImage = UIImage(imageLiteralResourceName: "pineapple.png")
    var fruitToCatch : String = "apple"
    var showLevelUpLabel = false
    var increaseSpeed = false
    
    var gameHasStarted = false
    
    var fruitOptions : [String : UIImage] = [ : ]
    
    var scoreboard: [NSManagedObject] = []
    var currentScoreboard = Scoreboard()

    @IBOutlet var catchesLabel: UILabel!
    @IBOutlet var livesLabel: UILabel!
    @IBOutlet var nextCatch: UIImageView!
    @IBOutlet var highScoreLabel: UILabel!
    @IBOutlet var startOverOrLevelUpLabel: UILabel!
    
    var changeStartMessageToLevelUp = false      //change this to false after 3 seconds
    var changeStartMessageToRestart = false
    var startGameMessage = DispatchTime.now()
    //var timeDifference = DispatchTime.now()
    
    var checkForPause = false
    var basketX = 0
    var basketY = 300   //put at 500
    var touchX = -1
    var direction = "right"
    var started = false
    var highScoreOverall : Int64 = 0
    var pause = false
    
    var fruitCoordinates : [(String, (Int, Int))] = []
    var appleX = 0
    var appleY = 0
    var level : Int64 = 1   //as level goes up, speed of fruit falling increases as well as freq they appear
    var catches = 0
    var lives = 3
    let start = DispatchTime.now()
    var fruitsCaught : [Bool] = []
    var fruitsMissed : [Bool] = []
    var intervalsUsed : [Int] = []
    var appearRate = 4   //lower as level goes up
    //array of fruits - while the size is less than 13, choose a random fruit and add it do the fruitCoordinates
    
    
    //num fruits = 13 because must catch 10, can miss 3
    
   // var touchY = -1
    
    
    override func draw(_ rect: CGRect) {

//        let now = DispatchTime.now()
//        let dif = now.uptimeNanoseconds - startGameMessage.uptimeNanoseconds // Difference in nano seconds
//        let timeInterval = Double(dif) / 1_000_000_000

        
        let now = DispatchTime.now()
        let dif = now.uptimeNanoseconds - startGameMessage.uptimeNanoseconds // Difference in nano seconds
        let timeInterval = Double(dif) / 1_000_000_000

        if(timeInterval > 5 && checkForPause ){
            pause = false
        }
        
        if(pause == false ) {
        self.fetchScoreboard()
        print("HIGH SCORE DRAW 1: " + String(highScoreOverall))

        //fetch the scoreboards. If the length of scoarboards is 0, then save one
        if(scoreboard.count == 0 ){
            print("SAVING SCOREBOARD 1ST TIME")
            //level = 1
            //highScoreOverall = 0
            //currentScoreboard.set
            self.save(highScore: Int64(0))
            gameHasStarted = true   //add this also to the database
        }
        
        else {
           // level = scoreboard[0].level
            highScoreOverall = Int64(scoreboard[0].value(forKey: "highScore") as! Int)
            print(scoreboard[0].value(forKey: "highScore"))
            print("not first time")
        }
    
       // changeStartMessageToRestart = false
        print("HIGH SCORE DRAW 2: " + String(highScoreOverall))
        highScoreLabel.text = "High Score : " + String(highScoreOverall)
        
        fruitOptions = ["apple" : appleImage, "banana" : bananaImage, "orange" : orangeImage, "kiwi" : kiwiImage, "pineapple" : pineappleImage]
        basketImage = self.resizeImage(image: basketImage, targetSize: CGSize(width: 100.0, height: 200.0))
        basketImage.draw(at: CGPoint(x: CGFloat(basketX), y: CGFloat(basketY)))
        
        //let fruitImages = [ appleImage, bananaImage, orangeImage, kiwiImage, strawberryImage, pineappleImage ]
        
        nextCatch.image = fruitOptions[fruitToCatch]

        
        let end = DispatchTime.now()
        let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds // Difference in nano seconds
        let timeInterval = Double(nanoTime) / 1_000_000_000
        //if timeInterval is a multiple of 5, then release a new fruit (add to fruits list)
        
        
        checkForCatchesAndMisses()
        getRidOfElementsOffScreen()
        //HERE PUT LEVEL UP LABEL WAIT 5 SECONDS THEN GET RID OF LABEL TEXT
        if(Int(timeInterval) % appearRate == 0 && intervalsUsed.contains(Int(timeInterval)) == false){
            print("RELEASING NEW FRUIT")
            started = true
            //release a new fruit (addto fruitcoordinates and fruitsCaught - set to false)
            intervalsUsed.append(Int(timeInterval))
            let random = Int.random(in: Int(self.bounds.minX) + 10 ... Int(self.bounds.maxX) - 50)
            fruitsCaught.append(false)
            fruitsMissed.append(false)
            
            let fruit = Array(fruitOptions.keys).randomElement()!
            fruitCoordinates.append( (fruit, (random,0) ))
            
            
            
        }
        
        //go through list of all fruits and draw them at their coordinates
        if(fruitCoordinates.count > 0){
            for i in 0...fruitCoordinates.count - 1{
                
                if(fruitCoordinates[i].0 == "apple") {
                    appleImage = self.resizeImage(image: appleImage, targetSize: CGSize(width: 50.0, height: 50.0))
                    if(fruitsCaught[i] == false && fruitsMissed[i] == false ){
                        appleImage.draw(at: CGPoint(x: CGFloat(fruitCoordinates[i].1.0), y: CGFloat(fruitCoordinates[i].1.1)) )
                    }
                }
                

                
                else if(fruitCoordinates[i].0 == "kiwi") {
                    kiwiImage = self.resizeImage(image: kiwiImage, targetSize: CGSize(width: 50.0, height: 50.0))
                    if(fruitsCaught[i] == false && fruitsMissed[i] == false ){
                        kiwiImage.draw(at: CGPoint(x: CGFloat(fruitCoordinates[i].1.0), y: CGFloat(fruitCoordinates[i].1.1)) )
                    }
                }
                
                else if(fruitCoordinates[i].0 == "banana") {
                    bananaImage = self.resizeImage(image: bananaImage, targetSize: CGSize(width: 50.0, height: 50.0))
                    if(fruitsCaught[i] == false && fruitsMissed[i] == false){
                        bananaImage.draw(at: CGPoint(x: CGFloat(fruitCoordinates[i].1.0), y: CGFloat(fruitCoordinates[i].1.1)) )
                    }
                }
                
                else if(fruitCoordinates[i].0 == "pineapple") {
                    pineappleImage = self.resizeImage(image: pineappleImage, targetSize: CGSize(width: 50.0, height: 50.0))
                    if(fruitsCaught[i] == false && fruitsMissed[i] == false){
                        pineappleImage.draw(at: CGPoint(x: CGFloat(fruitCoordinates[i].1.0), y: CGFloat(fruitCoordinates[i].1.1)) )
                    }
                }
                
                else if(fruitCoordinates[i].0 == "orange") {
                    orangeImage = self.resizeImage(image: orangeImage, targetSize: CGSize(width: 50.0, height: 50.0))
                    if(fruitsCaught[i] == false && fruitsMissed[i] == false ){
                        orangeImage.draw(at: CGPoint(x: CGFloat(fruitCoordinates[i].1.0), y: CGFloat(fruitCoordinates[i].1.1)) )
                    }
                }
            }
        }
            
        }
        
        
        
    }
    
    @IBAction func clickResetButton(sender: UIButton){
        
    }
    
    @objc func update(){  //do collision detection here
        //for all fruits in the fruitsCoords list add level
        
       // appleY += 2
        
        //in update - if the fruit y == baskey y, it is caught , if it goes past it, it goes away
//        if(appleY < basketY + 10 && appleY > basketY - 10 ){
//            catches += 1
//            catchesLabel.text = "Catches: " + String(catches)
//        }
//
        
//        if(lives == 2){
//            level = 5
//            CoreDataScoreboard.saveNewScore(newScore: Int64(level))
//
//        }
        
        
        print("HIGH SCORE IN UPDATE: " + String(highScoreOverall))
        highScoreLabel.text = "High Score : " + String(highScoreOverall)
        
        fruitOptions = ["apple" : appleImage, "banana" : bananaImage, "orange" : orangeImage, "kiwi" : kiwiImage,  "pineapple" : pineappleImage]
   //     checkForCatchesAndMisses()
        
        if(catches % 3 == 0 && catches > 1  && increaseSpeed == true){
            
//            fruitCoordinates.removeAll()
//            fruitsMissed.removeAll()
//            fruitsCaught.removeAll()
             level += 1
//            self.updateData(level: Int64(level), scoreboardToUpdate: scoreboard[0] as! Scoreboard)
//
            if(appearRate > 1){
                appearRate -= 1
            }
            increaseSpeed = false
//            levelLabel.text = "Level: " + String(level)
//            catches = 0
//            catchesLabel.text = "Catches: " + String(catches)
//            lives = 3
//            livesLabel.text = "Lives: " + String(lives)
//
//
//            changeStartMessageToLevelUp = true
//            self.startOverOrLevelUpLabel.alpha = 1
//            startOverOrLevelUpLabel.text = "Level Up!"
//            startOverOrLevelUpLabel.isHidden = false
//            self.startOverOrLevelUpLabel.alpha = 1
//            UIView.animate(withDuration: 5.0, animations: { () -> Void in
//                self.startOverOrLevelUpLabel.alpha = 0
//            })
//
//            startGameMessage = DispatchTime.now()
//
//
        }
        
        if(lives == 0 && started == true) {
            showLevelUpLabel = true
            print("LOST ALL LIVEs")
            catches = 0
            catchesLabel.text = "Catches: " + String(catches)
            lives = 3
            level = 1
            appearRate = 4
            livesLabel.text = "Lives: " + String(lives)
            //START OVER SCREEN
//            startOverOrLevelUpLabel.isHidden = false
            startGameMessage = DispatchTime.now()
            startOverOrLevelUpLabel.text = "You lost all your \n lives! Starting over"
            //TODO: change message to display score
            print("here")
            startOverOrLevelUpLabel.isHidden = false
            self.startOverOrLevelUpLabel.alpha = 1
            UIView.animate(withDuration: 5.0, animations: { () -> Void in
                self.startOverOrLevelUpLabel.alpha = 0
            })
            changeStartMessageToRestart = true
            started = false
            
            pause = true
            checkForPause = true
            //TODO: check for high score, give message if new high score, update high score if it was different
            
            if(catches > highScoreOverall){
                print("NEW HIGH SCORE!s")
                self.updateData(newHighScore: Int64(catches), scoreboardToUpdate: scoreboard[0] as! Scoreboard)
            }
            
            fruitCoordinates.removeAll()
            fruitsCaught.removeAll()
            fruitsMissed.removeAll()
        }
        
        
        if(fruitCoordinates.count > 0) {
            for i in 0...fruitCoordinates.count-1 {
                fruitCoordinates[i].1.1 += Int(level)
            }
        }
        
        
       /// if(appleY )
        
        if(basketX + 100 > Int(self.bounds.maxX)){
            direction = "left"
        }
        
        if( basketX < Int(self.bounds.minX)){
            direction = "right"
        }
        
        if(direction ==  "left"){
            basketX -= 2
        }
        if(direction ==  "right"){
            basketX += 2
            }
        
            
        setNeedsDisplay()
        //setNeedsDisplay()  //calls draw function (like a flag)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let point = t.location(in: self)
            //count += 1
            touchX = Int(point.x)
            if(touchX < basketX) {
                direction = "left"
            }
            else {
                direction = "right"
            }
        }
            
    }
    
    
    func getRidOfElementsOffScreen(){
        var indexesToDelete : [Int] = []
        if(fruitCoordinates.count > 0){
            for i in 0...fruitCoordinates.count-1 {
                if (fruitCoordinates[i].1.1 > basketY + 76) {
                    indexesToDelete.append(i)
                }
            }
        }
        
        for i in indexesToDelete {
            fruitCoordinates.remove(at: i)
            fruitsCaught.remove(at: i)
            fruitsMissed.remove(at: i)
        }
    }
    
        
    func checkForCatchesAndMisses(){
        //print("NEW CHECK")
        if(fruitCoordinates.count > 0) {
            for i in 0...fruitCoordinates.count-1 {
                if((fruitCoordinates[i].1.1 < basketY + 50 && fruitCoordinates[i].1.1 > basketY) &&
                    (fruitCoordinates[i].1.0 <= basketX + 100 &&  fruitCoordinates[i].1.0 >= basketX) && fruitsCaught[i] == false  && fruitCoordinates[i].0 == fruitToCatch ){
                    //caught the correct fruit
                    print("CORRECT!")
                    catches += 1
                    increaseSpeed = true
                    print("Catches: " + String(catches) + " High score: " + String(highScoreOverall))
                    
                    
                    if(Int64(catches) > highScoreOverall){
                        print("GREATER THAN")
                        highScoreOverall = Int64(catches)
                        self.updateData(newHighScore: Int64(catches), scoreboardToUpdate: scoreboard[0] as! Scoreboard)
                        print("NEW HIGH SCORE : " + String(highScoreOverall))
                    }
                    
                    catchesLabel.text = "Catches: " + String(catches)
                    highScoreLabel.text = "High Score: " + String(highScoreOverall)
                    print("TEXT IS: " + highScoreLabel.text!)
                    fruitsCaught[i] = true
                    
                    fruitToCatch = Array(fruitOptions.keys).randomElement()!
                    nextCatch.image = fruitOptions[fruitToCatch]
                    break
                }
                
                else if((fruitCoordinates[i].1.1 < basketY + 50 && fruitCoordinates[i].1.1 > basketY) &&
                            (fruitCoordinates[i].1.0 <= basketX + 100 &&  fruitCoordinates[i].1.0 >= basketX) && fruitsCaught[i] == false  && fruitCoordinates[i].0 != fruitToCatch ){
                            //caught the wrong fruit
                            print("CAUGHT WRONG FRUIT")
                            lives -= 1
                            livesLabel.text = "Lives: " + String(lives)
                            fruitsCaught[i] = true
                            fruitsMissed[i] = true
                        }
//make off screen list (check if fruit still on screen)
                
                else if(fruitCoordinates[i].0 == fruitToCatch && fruitsCaught[i] == false && fruitsMissed[i] == false){
                    if (fruitCoordinates[i].1.1 > basketY + 75  && fruitCoordinates[i].1.1 < Int(self.bounds.maxY )){
                        print("MISSED FRUIT")
                        fruitsCaught[i] = true
                        lives -= 1
                        livesLabel.text = "Lives: " + String(lives)
                        fruitsMissed[i] = true
                    }
                }
            }
            //whats happening: it's getting them from fruitCoordinates and thinking they're the right fruit, have to delete from it
            //have to take
            
            
        }
    }
    
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
       let size = image.size

       let widthRatio  = targetSize.width  / size.width
       let heightRatio = targetSize.height / size.height

       // Figure out what our orientation is, and use that to form the rectangle
       var newSize: CGSize
       if(widthRatio > heightRatio) {
           newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
       } else {
           newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
       }

       // This is the rect that we've calculated out and this is what is actually used below
       let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

       // Actually do the resizing to the rect using the ImageContext stuff
       UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
       image.draw(in: rect)
       let newImage = UIGraphicsGetImageFromCurrentImageContext()
       UIGraphicsEndImageContext()

       return newImage!
   }
        
        
        

    
    func save(highScore: Int64) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        
        
        /*1.
         Before you can save or retrieve anything from your Core Data store, you first need to get your hands on an NSManagedObjectContext. You can consider a managed object context as an in-memory “scratchpad” for working with managed objects.
         Think of saving a new managed object to Core Data as a two-step process: first, you insert a new managed object into a managed object context; then, after you’re happy with your shiny new managed object, you “commit” the changes in your managed object context to save it to disk.
         Xcode has already generated a managed object context as part of the new project’s template. Remember, this only happens if you check the Use Core Data checkbox at the beginning. This default managed object context lives as a property of the NSPersistentContainer in the application delegate. To access it, you first get a reference to the app delegate.
         */
        let managedContext = appDelegate.persistentContainer.viewContext
        
        /*
         An NSEntityDescription object is associated with a specific class instance
         Class
         NSEntityDescription
         A description of an entity in Core Data.
         
         Retrieving an Entity with a Given Name here person
         */
        let entity = NSEntityDescription.entity(forEntityName: "Scoreboard",
                                                in: managedContext)!
        
        
        /*
         Initializes a managed object and inserts it into the specified managed object context.
         
         init(entity: NSEntityDescription,
         insertInto context: NSManagedObjectContext?)
         */
        let scoreboard = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        /*
         With an NSManagedObject in hand, you set the name attribute using key-value coding. You must spell the KVC key (name in this case) exactly as it appears in your Data Model
         */
        scoreboard.setValue(Int64(catches), forKeyPath: "highScore")
        
        /*
         You commit your changes to person and save to disk by calling save on the managed object context. Note save can throw an error, which is why you call it using the try keyword within a do-catch block. Finally, insert the new managed object into the people array so it shows up when the table view reloads.
         */
        do {
          try managedContext.save()
         // scoreboard.append(s)
          //tableView.reloadData()
        } catch let error as NSError {
          print("Could not save. \(error), \(error.userInfo)")
        }
      }
    
    
    
    func updateData(newHighScore: Int64, scoreboardToUpdate: Scoreboard) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        
        /*1.
         Before you can save or retrieve anything from your Core Data store, you first need to get your hands on an NSManagedObjectContext. You can consider a managed object context as an in-memory “scratchpad” for working with managed objects.
         Think of saving a new managed object to Core Data as a two-step process: first, you insert a new managed object into a managed object context; then, after you’re happy with your shiny new managed object, you “commit” the changes in your managed object context to save it to disk.
         Xcode has already generated a managed object context as part of the new project’s template. Remember, this only happens if you check the Use Core Data checkbox at the beginning. This default managed object context lives as a property of the NSPersistentContainer in the application delegate. To access it, you first get a reference to the app delegate.
         */
        let context = appDelegate.persistentContainer.viewContext
        
        do {
          
          
          /*
           With an NSManagedObject in hand, you set the name attribute using key-value coding. You must spell the KVC key (name in this case) exactly as it appears in your Data Model
           */
            print("UPDATING")
            scoreboardToUpdate.setValue(newHighScore, forKey: "highScore")
         print("UPDATED")
          
 //         print("\(scoreboard.value(forKey: "level"))")

          
          /*
           You commit your changes to person and save to disk by calling save on the managed object context. Note save can throw an error, which is why you call it using the try keyword within a do-catch block. Finally, insert the new managed object into the people array so it shows up when the table view reloads.
           */
          do {
            try context.save()
            print("saved!")
          } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
          } catch {
            
          }
          
        } catch {
          print("Error with request: \(error)")
        }
      }
    
    
    
    func fetchScoreboard(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        
        /*Before you can do anything with Core Data, you need a managed object context. */
        let managedContext = appDelegate.persistentContainer.viewContext
        
        /*As the name suggests, NSFetchRequest is the class responsible for fetching from Core Data.
         
         Initializing a fetch request with init(entityName:), fetches all objects of a particular entity. This is what you do here to fetch all Person entities.
         */
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Scoreboard")
        
        /*You hand the fetch request over to the managed object context to do the heavy lifting. fetch(_:) returns an array of managed objects meeting the criteria specified by the fetch request.*/
        do {
          scoreboard = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
        
      }
    
    
    
    
//    func fetchLevel(){
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let context = appDelegate.persistentContainer.viewContext
//
//        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Scoreboard")
//        let predicate = NSPredicate(format: "level = %@") // Specify your condition here
//    // Or for integer value
//    // let predicate = NSPredicate(format: "age > %d", argumentArray: [10])
//
//        fetch.predicate = predicate
//
//        do {
//
//          let result = try context.fetch(fetch)
//          for data in result as! [NSManagedObject] {
//            print(data.value(forKey: "username") as! String)
//            print(data.value(forKey: "password") as! String)
//            print(data.value(forKey: "age") as! String)
//          }
//        } catch {
//          print("Failed")
//        }
//    }
//
//
////    func fetchLevel(){
////        /*get reference to appdelegate file*/
////        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
////            return
////        }
////
////      /*get reference of managed object context*/
////        let managedContext = appDelegate.persistentContainer.viewContext
////
////      /*init fetch request*/
////        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Scoreboard")
////
////      /*pass your condition with NSPredicate. We only want to delete those records which match our condition*/
////        fetchRequest.predicate = NSPredicate(format: "level == %@" ,level)
////        var retVal : [Scoreboard] = []
////        do {
////
////          /*managedContext.fetch(fetchRequest) will return array of person objects [personObjects]*/
////            let item = try managedContext.fetch(fetchRequest)
////
////          //  retVal = item
//////            for i in item {
//////
//////                retVal = i
//////              /*call delete method(aManagedObjectInstance)*/
//////              /*here i is managed object instance*/
//////                managedContext.delete(i)
//////
//////              /*finally save the contexts*/
//////                try managedContext.save()
//////
//////              /*update your array also*/
//////              people.remove(at: (people.index(of: i))!)
//////            }
////        } catch let error as NSError {
////            print("Could not fetch. \(error), \(error.userInfo)")
////        }
////
////    }

        
        
    

}
    

