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
   
    var basketX = 0
    var basketY = 100
    var touchX = -1
    var direction = "right"
   // var touchY = -1
    
    override func draw(_ rect: CGRect) {
        basketImage = self.resizeImage(image: basketImage, targetSize: CGSize(width: 100.0, height: 200.0))
        basketImage.draw(at: CGPoint(x: basketX, y: basketY))
    }
    
    @IBAction func clickResetButton(sender: UIButton){
        
    }
    
    @objc func update(){  //do collision detection here
        
        
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
        
      
//        if(touchX > basketX ) {
//            print("moving right")
//            direction = "right"
//            basketX += 2
//        }
//        else if (touchX < basketX) {
//            print("moving left")
//            direction = "left"
//            basketX -= 2
//        }
//
//        if(touchX == basketX && direction == "left" ){
//            basketX -= 2
//
//        }
//        else if(touchX == basketX && direction == "right" ){
//            basketX += 2
//        }
        
        
//        if (shapex > Int(self.bounds.maxX)){
//            dx = -dx
//        }
//
//        if (shapex < Int(self.bounds.minX)){
//            dx = -dx
//        }
       
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
    

