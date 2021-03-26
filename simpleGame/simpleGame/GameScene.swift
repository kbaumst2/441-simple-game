import SpriteKit
 
class GameScene: SKScene {
    
    let label = SKLabelNode(text: "Hello SpriteKit!")
    var player = SKSpriteNode()
    var ground = SKSpriteNode()
    
       
    
    

    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        createGrounds()
        createPlayer()
        
//        label.position = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2)
//        addChild(label)
//        backgroundColor = SKColor.white
 
//        let image = UIImage(named: "car1.jpeg")
//        let texture = SKTexture(image: image!)
//        player = SKSpriteNode(texture: texture)
//        player.position = CGPoint(x: size.width * 0.1, y: 10)
//
//        
//
//
//      // Add the monster to the scene
//        addChild(player)
//
        
//        run(SKAction.repeatForever(
//              SKAction.sequence([
//                SKAction.run(movePlayer),
//                SKAction.wait(forDuration: 1.0)
//                ])
//            ))
        
        
    }
    
    override func update(_ currentTime: CFTimeInterval){
        //called before each frame is rendered
        moveGrounds()
        movePlayer()
    }
    
    
    func createGrounds(){
        for i in 0...3 {
            let ground = SKSpriteNode(imageNamed: "ground")
            ground.name = "Ground"
            ground.size = CGSize(width: (self.scene?.size.width)!, height: 250)
            ground.anchorPoint =  CGPoint(x: 0.5, y: 0.5)
            ground.position = CGPoint(x: CGFloat(i)*ground.size.width, y: -(self.frame.size.height / 2))
            
            self.addChild((ground))
        }
    }
    
    
    func moveGrounds(){
        self.enumerateChildNodes(withName: "Ground", using: ({
            (node,error) in
            
            node.position.x -= 2
            
            if node.position.x < -((self.scene?.size.width)!){
                node.position.x += (self.scene?.size.width)! * 3
            }
        }) )
    }
    
    
    func movePlayer () {
//        let path = CGMutablePath()
//        path.move(to: CGPoint(x: 0, y: 0))
//        path.addLine(to: CGPoint(x: player.position.x + 20, y: 0))
//        let followLine = SKAction.follow(path, speed: 3.0)
//        player.run(followLine)
//
//        let move = SKAction.move(to: CGPoint(x: 1000, y: 100), duration: 50)
//       // parentNode.run(move)
        self.enumerateChildNodes(withName: "Car", using: ({
            (node,error) in
            
            node.position.x -= 2
            
            if node.position.x < -((self.scene?.size.width)!){
                node.position.x += (self.scene?.size.width)! * 3
            }
        }) )
        
        
    }
    
    
    func createPlayer() {
//
//      // Create sprite
//     // let player = SKSpriteNode(imageNamed: "monster")
//
//      // Determine where to spawn the monster along the Y axis
////        let actualY = 10
////
////      // Position the monster slightly off-screen along the right edge,
////      // and along a random position along the Y axis as calculated above
////      //player.position = CGPoint(x: size.width + player.size.width/2, y: actualY)
////   //     player.position = CGPoint(x: size.width * 0.1, y: size.height * 0.5)
////        let image = UIImage(named: "car1.jpeg")
////        let texture = SKTexture(image: image!)
////        player = SKSpriteNode(texture: texture)
////        player.position = CGPoint(x: size.width * 0.1, y: 10)
////
////
////
////      // Add the monster to the scene
////      addChild(player)
//
//      // Determine speed of the monster
//     // let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
//        let actualDuration = 2.0
//        let actualY = 10
//
//      // Create the actions
//        let actionMove = SKAction.move(to: CGPoint(x: Int((player.size.width)/2) + 20, y: actualY),
//                                     duration: TimeInterval(actualDuration))
//      //let actionMoveDone
//        player.run(actionMove)
        
        for i in 0...3 {
            let car = SKSpriteNode(imageNamed: "car1.jpeg")
            car.name = "Car"
            car.size = CGSize(width: (self.scene?.size.width)!, height: 250)
            car.anchorPoint =  CGPoint(x: 0.5, y: 0.5)
            car.position = CGPoint(x: CGFloat(i)*ground.size.width, y: -(self.frame.size.height / 2))
            
            self.addChild((car))
        }
        
        
        
        
        
        
    }
    

    
    
    
    
    
    
    
}
