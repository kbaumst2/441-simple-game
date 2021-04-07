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
    
    
    override func draw(_ rect: CGRect) {

        
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
            self.save(highScore: Int64(0))
            gameHasStarted = true   //add this also to the database
        }
        
        else {
           // level = scoreboard[0].level
            highScoreOverall = Int64(scoreboard[0].value(forKey: "highScore") as! Int)
            print(scoreboard[0].value(forKey: "highScore"))
            print("not first time")
        }
    
        print("HIGH SCORE DRAW 2: " + String(highScoreOverall))
        highScoreLabel.text = "High Score : " + String(highScoreOverall)
        
        fruitOptions = ["apple" : appleImage, "banana" : bananaImage, "orange" : orangeImage, "kiwi" : kiwiImage, "pineapple" : pineappleImage]
        basketImage = self.resizeImage(image: basketImage, targetSize: CGSize(width: 100.0, height: 200.0))
        basketImage.draw(at: CGPoint(x: CGFloat(basketX), y: CGFloat(basketY)))
        
        
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

        
        
        print("HIGH SCORE IN UPDATE: " + String(highScoreOverall))
        highScoreLabel.text = "High Score : " + String(highScoreOverall)
        
        fruitOptions = ["apple" : appleImage, "banana" : bananaImage, "orange" : orangeImage, "kiwi" : kiwiImage,  "pineapple" : pineappleImage]
        
        if(catches % 3 == 0 && catches > 1  && increaseSpeed == true){
            
             level += 1
            if(appearRate > 1){
                appearRate -= 1
            }
            increaseSpeed = false
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
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Scoreboard",
                                                in: managedContext)!
        
    
        let scoreboard = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        scoreboard.setValue(Int64(catches), forKeyPath: "highScore")
        
        do {
          try managedContext.save()
        } catch let error as NSError {
          print("Could not save. \(error), \(error.userInfo)")
        }
      }
    
    
    
    func updateData(newHighScore: Int64, scoreboardToUpdate: Scoreboard) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        do {
          
          
            print("UPDATING")
            scoreboardToUpdate.setValue(newHighScore, forKey: "highScore")
         print("UPDATED")
          
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
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Scoreboard")
        

        do {
          scoreboard = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
        
      }
    
    
    
    


        
        
    

}
    

