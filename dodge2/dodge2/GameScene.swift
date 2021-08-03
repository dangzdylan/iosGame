//
//  GameScene.swift
//  dodge2
//
//  Created by Dylan on 7/14/21.
//  Copyright © 2021 S-Crew. All rights reserved.
//

import SpriteKit
import GameplayKit

/*
 **GOALS**
 
 
 
 - organize objects; put in different files and make classes
 - make monster spawn into playfield and bounce around at constant speed
 - animation placeholder for monster spawning in
 - fix coin moving random algorithm
 - fix up start and end screen
 - save highscore and put on end screen
 
 - SCORE BASED ON TIME NOT COINS, COINS USED FOR CURRENCY IN SHOP
 
 */


//screenBounds = UIScreen.main.bounds, screenScale = UIScreen.main.scale, so UIScreen.main.scale = 2x scale

//screen res
public var screenWidth =  UIScreen.main.bounds
.size.width * CGFloat(2)
public var screenHeight = UIScreen.main.bounds
.size.height * CGFloat(2)


//view frame dimension
public let frameWidth = screenWidth / 2
public let frameHeight = screenHeight / 2

//borders
public var topBorder = SKSpriteNode()
public var bottomBorder = SKSpriteNode()
public var leftBorder = SKSpriteNode()
public var rightBorder = SKSpriteNode()

//nodes
public var tempSize = screenWidth/15
public var Player = SKSpriteNode()
public var monsterArray = [SKSpriteNode]()
public var coin = SKSpriteNode()


//bit mask 
public struct ColliderType{
    static let Player:UInt32 = 1
    static let topBorder:UInt32 = 2
    static let bottomBorder:UInt32 = 3
    static let rightBorder:UInt32 = 4
    static let leftBorder:UInt32 = 5
    static let Monster:UInt32 = 6
    static let coin: UInt32 = 0
}

//player movement vars
public var goingUp = true
public var goingRight = false
public var playerSpeed = CGVector()


//score
public var score  = SKLabelNode()
public var scoreNum = 0




class GameScene: SKScene, SKPhysicsContactDelegate {
    
    override func didMove(to view: SKView) {
        
        self.backgroundColor = .white
        self.physicsWorld.contactDelegate = self
        addBorders(self:self)
        addPlayer(self:self)
        addCoin(self: self)
        addScore(self: self)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let speed = 30
        if goingUp == true{
            if !goingRight{
                playerSpeed = CGVector(dx: speed, dy: speed)
            }else{
                playerSpeed = CGVector(dx: -speed, dy: speed)
            }
        }else{
            if !goingRight{
                playerSpeed = CGVector(dx: speed, dy: -speed)
            }else{
                playerSpeed = CGVector(dx: -speed, dy: -speed)
            }
        }
        goingRight = !goingRight
        
        
        Player.physicsBody?.velocity = CGVector(dx:0, dy:0)
        Player.physicsBody?.applyImpulse(playerSpeed)
    }
    

        
    
    override func update(_ currentTime: TimeInterval) {
        
        //player touching coin?
        if (isTouching(Player.position.x - coin.position.x, Player.position.y - coin.position.y, coin.size.width/1.9, Player.size.width/1.9)){
            
            touchCoin(self:self)
        }
         
    }
    
    
    func isTouching(_ c1:CGFloat , _ c2:CGFloat , _ r1:CGFloat , _ r2:CGFloat) -> Bool{
        let distance = sqrtf(Float(c1 * c1 + c2 * c2))
        
        return distance <= Float(r1 + r2)
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        let collision:UInt32 = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if collision == ColliderType.Player | ColliderType.topBorder || collision == ColliderType.Player | ColliderType.bottomBorder{
            goingUp = !goingUp
        }
    }


    func gameOver(){
        scoreNum = 0
        score.text = String(scoreNum)
        removeAllChildren()
        let temp = GameOverScene(fileNamed: "GameOverScene")
        self.scene?.view?.presentScene(temp!, transition: SKTransition.doorsOpenVertical(withDuration: 1))
        
    }
    
}



