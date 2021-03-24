import SpriteKit
 
class GameScene: SKScene {
    
    let label = SKLabelNode(text: "Hello SpriteKit!")
    var player = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        label.position = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2)
        addChild(label)
        backgroundColor = SKColor.white
            // 3
            let image = UIImage(named: "car1.jpeg")
            let texture = SKTexture(image: image!)
            player = SKSpriteNode(texture: texture)
            player.position = CGPoint(x: size.width * 0.1, y: size.height * 0.5)
            // 4
            addChild(player)
    }
}
