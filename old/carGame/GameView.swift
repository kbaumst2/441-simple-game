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

    let carImage = UIImage(imageLiteralResourceName: "car.jpeg")
    
    override func draw(_ rect: CGRect) {
       
        carImage.draw(at: CGPoint(x: 0, y: 100))
    }
    
    @IBAction func clickResetButton(sender: UIButton){
        
    }
    
    @objc func update(){  //do collision detection here
        
        
        
        setNeedsDisplay()  //calls draw function (like a flag)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
            
    
    
    
    }
        
        
        


}
    

