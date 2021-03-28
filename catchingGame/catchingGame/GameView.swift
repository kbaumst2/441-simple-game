//
//  GameView.swift
//  carGame
//
//  Created by Kate Baumstein on 3/26/21.
//

import UIKit

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
    @IBOutlet var catchesLabel: UILabel!
   
    var basketX = 0
    var basketY = 100   //put at 500
    var touchX = -1
    var direction = "right"
    
    var fruitCoordinates : [(Int, Int)] = []
    var appleX = 0
    var appleY = 0
    var level = 1   //as level goes up, speed of fruit falling increases as well as freq they appear
    var catches = 0
    let start = DispatchTime.now()
    var fruitsCaught : [Bool] = []
    var intervalsUsed : [Int] = []
    var appearRate = 4   //lower as level goes up
    //array of fruits - while the size is less than 13, choose a random fruit and add it do the fruitCoordinates
    
    
    //num fruits = 13 because must catch 10, can miss 3
    
   // var touchY = -1
    
    override func draw(_ rect: CGRect) {
        basketImage = self.resizeImage(image: basketImage, targetSize: CGSize(width: 100.0, height: 200.0))
        basketImage.draw(at: CGPoint(x: CGFloat(basketX), y: CGFloat(basketY)))
        
        print("start")
        print(start.uptimeNanoseconds)
        let end = DispatchTime.now()
        let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds // Difference in nano seconds
        let timeInterval = Double(nanoTime) / 1_000_000_000
        //if timeInterval is a multiple of 5, then release a new fruit (add to fruits list)
        
        if(Int(timeInterval) % appearRate == 0 && intervalsUsed.contains(Int(timeInterval)) == false){
            print("RELEASING NEW FRUIT")
            //release a new fruit (addto fruitcoordinates and fruitsCaught - set to false)
            intervalsUsed.append(Int(timeInterval))
            let random = Int.random(in: Int(self.bounds.minX) + 10 ... Int(self.bounds.maxX) - 10)
            fruitsCaught.append(false)
            fruitCoordinates.append((random,0))
//            appleImage = self.resizeImage(image: appleImage, targetSize: CGSize(width: 50.0, height: 50.0))
//            appleX = random
//            appleImage.draw(at: CGPoint(x: CGFloat(appleX), y: CGFloat(appleY)) )
            
        }
        //go through list of all fruits and draw them at their coordinates
        if(fruitCoordinates.count > 0){
            for i in 0...fruitCoordinates.count - 1{
                appleImage = self.resizeImage(image: appleImage, targetSize: CGSize(width: 50.0, height: 50.0))
                if(fruitsCaught[i] == false ){
                    appleImage.draw(at: CGPoint(x: CGFloat(fruitCoordinates[i].0), y: CGFloat(fruitCoordinates[i].1)) )
                }
                
            }
        }
        
        print("Time \(timeInterval) seconds")
//        appleImage = self.resizeImage(image: appleImage, targetSize: CGSize(width: 50.0, height: 50.0))
//        appleX = Int(self.bounds.maxX / 2)
//        appleImage.draw(at: CGPoint(x: CGFloat(appleX), y: CGFloat(appleY)) )
        //choose fruits randomly from list,
        //every certain seconds(changes with level) , send a fruit down at speed (changes with level)
        
        
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
        
        checkForCatches()
        if(fruitCoordinates.count > 0) {
            for i in 0...fruitCoordinates.count-1 {
                fruitCoordinates[i].1 += level
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
        
    
       
        setNeedsDisplay()  //calls draw function (like a flag)
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
            //random = Int.random(in: Int(self.bounds.minY) + 70 ... Int(self.bounds.maxY) - 70)
//            shapex = Int(point.x)
//            shapey = Int(point.y)
            
        }
            
    
       
    
    }
    
    
    func checkForCatches(){
        if(fruitCoordinates.count > 0) {
            for i in 0...fruitCoordinates.count-1 {
                if(fruitCoordinates[i].1 < basketY + 50 && fruitCoordinates[i].1 > basketY &&
                    fruitCoordinates[i].0 <= basketX + 100 &&  fruitCoordinates[i].0 >= basketX && fruitsCaught[i] == false ) {
                    catches += 1
                    catchesLabel.text = "Catches: " + String(catches)
                    fruitsCaught[i] = true
                }
            }
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
        
        
        


}
    

