//
//  GameOverScene.swift
//  Fantasy Shooting Star
//
//  Created by user240061 on 11/9/23.
//

import Foundation
import SpriteKit
import UIKit
import AVFoundation

class GameOverScene: SKScene{
    let restartLabel = SKLabelNode(fontNamed: "Pixelpoint")
    var backgroundMusic: SKAudioNode!

    override func didMove(to view: SKView)
    {
        playBackgroundMusic()

        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 310, y:668)
        background.zPosition = 0
        background.size = self.size
        self.addChild(background)
        
        
        let gameOverLabel = SKLabelNode(fontNamed: "Pixelpoint")
        gameOverLabel.text = "จบเกม"
        gameOverLabel.fontSize = 100
        gameOverLabel.fontColor = SKColor.white
        gameOverLabel.position = CGPoint(x: self.size.width*0.5 , y: self.size.height*0.7)
        gameOverLabel.zPosition = 1
        self.addChild(gameOverLabel)
        
        
        let scoreLabel = SKLabelNode(fontNamed: "Pixelpoint")
        scoreLabel.text = "คะแนน: \(gameScore)"
        scoreLabel.fontSize = 60
        scoreLabel.fontColor = SKColor.white
        scoreLabel.position = CGPoint(x: self.size.width*0.5 , y: self.size.height*0.6)
        scoreLabel.zPosition = 1
        self.addChild(scoreLabel)
        
        let defaults = UserDefaults()
        var highScoreNumber = defaults.integer(forKey: "highScoreSaved")
        
        if gameScore > highScoreNumber{
            
            highScoreNumber = gameScore
            defaults.set(highScoreNumber, forKey: "highScoreSaved")
            
        }
        
        let highScoreLabel = SKLabelNode(fontNamed: "Pixelpoint")
        highScoreLabel.text = "คะแนนสูงสุด: \(highScoreNumber)"
        highScoreLabel.fontSize = 60
        highScoreLabel.fontColor = SKColor.white
        highScoreLabel.position = CGPoint(x: self.size.width*0.5 , y: self.size.height*0.5)
        highScoreLabel.zPosition = 1
        self.addChild(highScoreLabel)

        
        let restartLabel = SKLabelNode(fontNamed: "Pixelpoint")
        restartLabel.text = "แตะเพื่อเริ่มเกมใหม่"
        restartLabel.fontSize = 50
        restartLabel.fontColor = SKColor.white
        restartLabel.position = CGPoint(x: self.size.width*0.5 , y: self.size.height*0.3)
        restartLabel.zPosition = 1
        self.addChild(restartLabel)
        
    }
    
    func playBackgroundMusic() {
          let musicFile = "Gameover.mp3"

          if let musicURL = Bundle.main.url(forResource: musicFile, withExtension: nil) {
              backgroundMusic = SKAudioNode(url: musicURL)
              addChild(backgroundMusic)
          }
      }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

                   for touch: AnyObject in touches{
                       
                       let pointOfTouch = touch.location(in: self)

                       let scene = GameScene(size: CGSize(width: 1179, height: 2556))
                       
                       
                       if let view = self.view as! SKView? {
                           // Load the SKScene from 'GameScene.sks'
                           if let scene = SKScene(fileNamed: "GameScene") {
                               // Set the scale mode to scale to fit the window
                               scene.scaleMode = .aspectFill
                               
                               // Present the scene
                               view.presentScene(scene)
                           }
                           
                           view.ignoresSiblingOrder = true
                           
                           view.showsFPS = true
                           view.showsNodeCount = true
                       }
                      
                   }
           }
           
    
    
}
