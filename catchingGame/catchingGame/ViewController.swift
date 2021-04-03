//
//  ViewController.swift
//  carGame
//
//  Created by Kate Baumstein on 3/26/21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var gameView: GameView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //when screen needs to refresh, calls this selector
        let displayLink = CADisplayLink(target: self, selector: #selector(update))
        displayLink.add(to: RunLoop.main, forMode: RunLoop.Mode.default)
//        let value = UIInterfaceOrientation.landscapeLeft.rawValue
//        UIDevice.current.setValue(value, forKey: "orientation")
        
    }
    
    @objc func update(){
        //print(update())
        //print("update")
        gameView.update()
        
    }


}
