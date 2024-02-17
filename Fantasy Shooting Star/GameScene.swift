//
//  GameScene.swift
//  Fantasy Shooting Star
//
//  Created by user240061 on 10/30/23.
//

import SpriteKit
import GameplayKit
import AVFoundation

var gameScore = 0
class GameScene: SKScene, SKPhysicsContactDelegate {
    
    

    var backgroundMusic: SKAudioNode!

    let scoreLabel = SKLabelNode(fontNamed: "Pixelpoint")
    var LevelNumber = 0
    var livesNumber = 3
    let livesLable = SKLabelNode(fontNamed: "Pixelpoint")
    
    let player = SKSpriteNode(imageNamed: "playerShip")
    
    let bulletSound = SKAction.playSoundFileNamed("Laser_Gun_Sound_Effect.mp3", waitForCompletion: false)
    let explosionSound = SKAction.playSoundFileNamed("Video_Game_Explosion_Sound_Effect.mp3", waitForCompletion: false)
    let Click = SKAction.playSoundFileNamed("BGM.mp3", waitForCompletion: false)


    let tabToStartLabel = SKLabelNode(fontNamed: "Pixelpoint")
    let titlegame = SKLabelNode(fontNamed: "Pixelpoint")
    let titlegame2 = SKLabelNode(fontNamed: "Pixelpoint")
    
    enum gameState{
        
        case preGame
        case inGame
        case afterGame
        
    }
    
    var currentGameState = gameState.preGame
    
    
    struct PhysicsCategories{
        static let None : UInt32 = 0
        static let Player : UInt32 = 0b1
        static let Bullet : UInt32 = 0b10
        static let Enemy : UInt32 = 0b100

        
    }
    
    
    func random() -> CGFloat {
        
        let randomValue = Float(arc4random()) / Float(UInt32.max)
        return CGFloat(randomValue)
    }
    func random(min: CGFloat, max: CGFloat) -> CGFloat{
        
        return random() * (max - min) + min
    }
    
    

//    override init (size: CGSize){
//
//
//        let maxAspectRatio: CGFloat = 19.5/9.0
//        let playbleWidth =  size.height / maxAspectRatio
//
//        let margin = (size.width - playbleWidth) / 2
//
//        gameArea = CGRect(x: 800, y: 0, width: 800, height: 2556)
//
//        super.init(size: size)
//
//
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        // Perform any additional setup if needed
//    }
//

    //พื้นหลังและตัวละคร
    override func didMove(to view: SKView) {
        playBackgroundMusic()

        gameScore = 0
        
        self.physicsWorld.contactDelegate = self
        
        //ตำแหน่งพื้นหลัง
        for i in -1...3 {
            let background = SKSpriteNode(imageNamed: "background")
            background.size = self.size
            background.zPosition = 0
            background.anchorPoint = CGPoint(x: 1, y: 0.5)
//            background.position = CGPoint(x: size.width / 2, y: 0)
            background.position = CGPointMake(background.size.width / 2, CGFloat(i) * background.size.height )
            background.name = "Background"
            self.addChild(background)
            
        }
        
        
        
        
        //ขนาดและตำแหน่งกผู้เล่น
        player.setScale(1.5)
        player.zPosition = 2
        player.position =  CGPoint(x: 0, y: -1010)
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody!.affectedByGravity = false
        player.physicsBody!.categoryBitMask = PhysicsCategories.Player
        player.physicsBody!.collisionBitMask = PhysicsCategories.None
        player.physicsBody!.contactTestBitMask = PhysicsCategories.Enemy
        self.addChild(player)
        
        scoreLabel.text = "คะแนน: 0"
        scoreLabel.fontSize = 50
        scoreLabel.fontColor = SKColor.white
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreLabel.position = CGPoint(x:-250, y: 1000)
        scoreLabel.zPosition = 100
        self.addChild(scoreLabel)
        
        
        
        livesLable.text = "ชีวิต: 3"
        livesLable.fontSize = 50
        livesLable.fontColor = SKColor.white
        livesLable.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        livesLable.position = CGPoint(x:100, y:1000)
        livesLable.zPosition = 100
        self.addChild(livesLable)
   

        
        tabToStartLabel.text = "แตะเพื่อเริ่มเกม"
        tabToStartLabel.fontSize = 50
        tabToStartLabel.fontColor = SKColor.white
        tabToStartLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        tabToStartLabel.position = CGPoint(x:-180, y: -500)
        tabToStartLabel.zPosition = 100
        tabToStartLabel.alpha = 0
        self.addChild(tabToStartLabel)
        let fadeInAction = SKAction.fadeIn(withDuration: 0.3)
        tabToStartLabel.run(fadeInAction)
        
        
        titlegame.text = "เกม"
        titlegame.fontSize = 100
        titlegame.fontColor = SKColor.white
        titlegame.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        titlegame.position = CGPoint(x:-90, y: 400)
        titlegame.zPosition = 100
        titlegame.alpha = 0
        self.addChild(titlegame)
        titlegame.run(fadeInAction)
        
        titlegame2.text = "ตะลุยอวกาศ"
        titlegame2.fontSize = 70
        titlegame2.fontColor = SKColor.white
        titlegame2.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        titlegame2.position = CGPoint(x:-220, y: 300)
        titlegame2.zPosition = 100
        titlegame2.alpha = 0
        self.addChild(titlegame2)
        titlegame2.run(fadeInAction)
        
        
        startNewLevel()
        startFlashingAnimation()

    }
    
    func startFlashingAnimation() {
           let fadeIn = SKAction.fadeIn(withDuration: 0.9)
           let fadeOut = SKAction.fadeOut(withDuration: 0.9)
           let sequence = SKAction.sequence([fadeOut, fadeIn])
           let repeatForever = SKAction.repeatForever(sequence)
        tabToStartLabel.run(repeatForever)
       }

    
    func playBackgroundMusic() {
          let musicFile = "Bgm.mp3"

          if let musicURL = Bundle.main.url(forResource: musicFile, withExtension: nil) {
              backgroundMusic = SKAudioNode(url: musicURL)
              addChild(backgroundMusic)
          }
      }
    
    
    var lastUpdateTime: TimeInterval = 0
    var deltaFrameTime: TimeInterval = 0
    var amountToMovePerSecond: CGFloat = 300
    
    override func update(_ currentTime: TimeInterval) {
        if lastUpdateTime == 0 {
            lastUpdateTime = currentTime
        } else {
            deltaFrameTime = currentTime - lastUpdateTime
            lastUpdateTime = currentTime
        }

        let amountToMoveBackground = amountToMovePerSecond * CGFloat(deltaFrameTime)

        // Enumerate through each background node
        self.enumerateChildNodes(withName: "Background") { node, _ in
            if let background = node as? SKSpriteNode {
                if self.currentGameState == .inGame {
                    background.position.y -= amountToMoveBackground

                    // Check if the top of the background is off the screen
                    if background.frame.maxY < 1 {
                        // Move the background to the bottom to create a continuous loop
                        background.position.y += background.size.height * 1.5
                    }
                }
            }
        }
    }
    
    func startGame(){
        
        currentGameState = gameState.inGame
        let moveOnToScreenAction = SKAction.moveTo(y: 550, duration: 0.3)
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.5)
        let deleteAction = SKAction.removeFromParent()
        let deleteSequence = SKAction.sequence([fadeOutAction,deleteAction])
        tabToStartLabel.run(deleteAction)
        titlegame.run(deleteAction)
        titlegame2.run(deleteAction)

        scoreLabel.run(moveOnToScreenAction)
        livesLable.run(moveOnToScreenAction)
        
        let moveShipOntoScreenAction = SKAction.moveTo(y: -510, duration: 0.5)
        let startLevelAction = SKAction.run(startNewLevel)
        let startGameSequence = SKAction.sequence([moveShipOntoScreenAction, startLevelAction])
        player.run(startGameSequence)
    }
    
    
    func loseALife(){
        
        livesNumber -= 1
        livesLable.text = "ชีวิต: \(livesNumber)"
        
     
        if livesNumber == 0{
            
            runGameOver()
        }
       
    }
    
    
    func addScore()
    {
        gameScore += 1
        scoreLabel.text = "คะแนน: \(gameScore)"
        
        
        if gameScore == 10 || gameScore == 25 || gameScore == 50 {
            
        startNewLevel()
        }
    
    
    }
    
    func runGameOver(){
        
        currentGameState = gameState.afterGame
        self.removeAllActions()
        
        self.enumerateChildNodes(withName: "Bullet") {
            
            bullet, stop in
            bullet.removeAllActions()
        }
        self.enumerateChildNodes(withName: "Enemy"){
            
            enemy, stop in
            enemy.removeAllActions()
        }
    
        let changeSceneAction = SKAction.run(changeScene)
        let waitToChangeScene = SKAction.wait(forDuration: 1)
        let changeSceneSequence = SKAction.sequence([waitToChangeScene, changeSceneAction])
        self.run(changeSceneAction)
    }
    
    func changeScene(){
        
        let sceneToMoveTo = GameOverScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        let myTransition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(sceneToMoveTo, transition: myTransition)
        
    }
    
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask{
            
            body1 = contact.bodyA
            body2 = contact.bodyB
        }
        else{
            body1 = contact.bodyB
            body2 = contact.bodyA
            
        }
        if body1.categoryBitMask == PhysicsCategories.Player && body2.categoryBitMask == PhysicsCategories.Enemy
        {
            if body1.node != nil{
                spawnExplosion(spawnPosition: body1.node!.position)
            }
            
            if body2.node != nil{
                spawnExplosion(spawnPosition: body2.node!.position)
                

            }
            
            //ถ้า ตัวละครชนศัตรู
          
            body2.node?.removeFromParent()
            body1.node?.removeFromParent()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                
                self.runGameOver()
            }

           
            
            
        }
        
        if body1.categoryBitMask == PhysicsCategories.Bullet && body2.categoryBitMask == PhysicsCategories.Enemy
            && (body2.node?.position.y)! < self.size.height{
            
            
            addScore()
            
            if body2.node != nil{
                spawnExplosion(spawnPosition: body2.node!.position)
            }
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
        }
    }
    
    
    func spawnExplosion(spawnPosition: CGPoint){
        
        let explosion = SKSpriteNode(imageNamed: "explosion")
        explosion.position = spawnPosition
        explosion.zPosition = 3
        explosion.setScale(0)
        self.addChild(explosion)
        
        
        let scaleIn = SKAction.scale(to: 1, duration: 0.1)
        let fadeOut = SKAction.fadeOut(withDuration: 0.1)
        let delete = SKAction.removeFromParent()

        let explosionSequence = SKAction.sequence([explosionSound,scaleIn, fadeOut, delete])
        
        explosion.run(explosionSequence)
    }
    
    func startNewLevel(){
        LevelNumber += 1
        
        if self.action(forKey: "spawningEnemies") != nil{
            
            self.removeAction(forKey: "spawningEnemies")
        }
        
        var levelDuration: TimeInterval = 1.2

        switch LevelNumber{
            
        case 1: levelDuration = 1.2
        case 2: levelDuration = 1
        case 3: levelDuration = 0.8
        case 4: levelDuration = 0.5
        default:
            levelDuration = 0.5
            print("ไม่มีเลเวลทีเลือก")
        }
        
        let spawn = SKAction.run(spawEnemy)
        let waitToSpawn = SKAction.wait(forDuration: 1)
        let SpawnSequence = SKAction.sequence([waitToSpawn,spawn])
        let spawnForever = SKAction.repeatForever(SpawnSequence)
        self.run(spawnForever, withKey: "spawningEnemies")
        
    }    //กระสุน

    func fireBullet(){
      
        //ขนาดและตำแหน่งกระสุน
        let bullet = SKSpriteNode(imageNamed: "bullet")
        bullet.name = "Bullet"
        bullet.setScale(1.5)
        bullet.position = player.position
        bullet.zPosition = 0.9
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
        bullet.physicsBody!.affectedByGravity = false
        bullet.physicsBody!.categoryBitMask = PhysicsCategories.Bullet
        bullet.physicsBody!.collisionBitMask = PhysicsCategories.None
        bullet.physicsBody!.contactTestBitMask = PhysicsCategories.Enemy
        self.addChild(bullet)
        
        
        //ทิศทางกระสุน และ ลบกระสุนออกจากจอ
        
        let moveBullet = SKAction.moveTo(y: self.size.height + bullet.size.height, duration: 1)
//        let deleteBullet = SKAction.removeFromParent()
        
//        let bulletSequence = SKAction.sequence([bulletSound,moveBullet,deleteBullet])
        let bulletSequence = SKAction.sequence([bulletSound,moveBullet])
        bullet.run(bulletSequence)
        
        
    }
    
    //สุ่มจุดเกิดของศัตรู
   var randomnum = -210
    var randomnum2 = 50

    
    //แตะหน้าจอแล้วกระสุนออก
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if currentGameState == gameState.preGame{
            startGame()
            
        }
        
        
        else if currentGameState == gameState.inGame{
            fireBullet()

        }
//        spawEnemy()
        
       
        self.randomnum = Int.random(in: -400...400)
        self.randomnum2 = Int.random(in: 0...50)


    }
    
    var gameArea: CGRect {
            return CGRect(x: randomnum2, y: 0, width: randomnum, height: 500)
        }
    
    
    func spawEnemy()
    {
        let randomXStart = random(min: CGRectGetMinX(gameArea) , max: CGRectGetMaxX(gameArea))
        let randomXEnd = random(min: CGRectGetMinX(gameArea) , max: CGRectGetMaxX(gameArea))
        
        let startPoint = CGPoint(x: randomXStart, y: self.size.height * 1.2)
        let endPoint = CGPoint(x: randomXEnd, y: -self.size.height * 0.5)
        
        let enemy = SKSpriteNode(imageNamed: "enemyShip")
        enemy.setScale(1)
        enemy.position = startPoint
        enemy.zPosition = 2
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody!.affectedByGravity = false
        enemy.physicsBody!.categoryBitMask = PhysicsCategories.Enemy
        enemy.physicsBody!.collisionBitMask = PhysicsCategories.None
        enemy.physicsBody!.contactTestBitMask = PhysicsCategories.Player |  PhysicsCategories.Bullet


        self.addChild(enemy)
        
        
        let moveEnemy = SKAction.move(to: endPoint, duration: 1.5)
        let deleteEnemy = SKAction.removeFromParent()
        let loseALifeAction = SKAction.run(loseALife)
        let enemySequence = SKAction.sequence([moveEnemy,deleteEnemy, loseALifeAction])
        
        if currentGameState == gameState.inGame{
            enemy.run(enemySequence)
        }
        
        
        let dx = endPoint.x - startPoint.x
        let dy = endPoint.y - startPoint.y
        let amountToRotate = atan2(dy, dx)
        enemy.zRotation = amountToRotate
        
        
    }
    
    //กดค้างเพื่อขยับได้
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            
            let pointofTouch = touch.location(in: self)
            let previousPointofTouch = touch.previousLocation(in: self)
            
            let amountDragged = pointofTouch.x - previousPointofTouch.x
            
            if currentGameState == gameState.inGame{
                player.position.x += amountDragged
            }
//            if player.position.x > CGRectGetMaxX(gameArea){
//                player.position.x = CGRectGetMaxX(gameArea)
//            }
//
//            if player.position.x < CGRectGetMinX(gameArea){
//            player.position.x = CGRectGetMinX(gameArea)
//        }
        
    }
    
    
}
    
}
