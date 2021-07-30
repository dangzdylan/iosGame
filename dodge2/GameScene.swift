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
 ***Goals***
 analog joystick
 if touch player, reset score and delete all redballs
 add yellow balls for coins
 
 */

//res
//var screenBounds = UIScreen.main.bounds
//let screenScale = UIScreen.main.scale, so UIScreen.main.scale = 2x scale

public var screenWidth =  UIScreen.main.bounds
.size.width * CGFloat(2)
public var screenHeight = UIScreen.main.bounds
.size.height * CGFloat(2)

struct ColliderType{
    static let Player:UInt32 = 1
    static let topBorder:UInt32 = 2
    static let bottomBorder:UInt32 = 3
    static let rightBorder:UInt32 = 4
    static let leftBorder:UInt32 = 5
    static let Monster:UInt32 = 6
    static let coin: UInt32 = 0
}


class GameScene: SKScene, SKPhysicsContactDelegate {
    
   
    //nodes
    var tempSize = screenWidth/15
    var Player = SKSpriteNode(color: .blue, size: CGSize(width: screenWidth/15, height: screenWidth/15))
    var monsterArray = [SKSpriteNode]()
    var coin = SKSpriteNode(color: .blue, size: CGSize(width: screenWidth/20, height: screenWidth/20))
    
    //borders dec
    var leftBorder = SKSpriteNode()
    var rightBorder = SKSpriteNode()
    var bottomBorder = SKSpriteNode()
    var topBorder = SKSpriteNode()
    
    //player movement vars
    var goingUp = true
    var goingRight = false
    var playerSpeed = CGVector()
    
    
    //score
    var score  = SKLabelNode()
    var scoreNum = 0
    
    //coin countdown
    var timerCountdown = SKLabelNode()
    var timerCountdownNum = 5
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        addBorders()
        startGame()
        
    }
    
    func addBorders(){
        
        
        //frame declaration
        let sidesBorderSize = CGSize(width: screenWidth / 100, height: screenHeight/2.5)
        let topBorderSize = CGSize(width: screenHeight/3, height: screenWidth/100)
        
        
        //borders dec
        let leftBorder = SKSpriteNode(color: .white, size: sidesBorderSize)
        let rightBorder = SKSpriteNode(color: .white, size: sidesBorderSize)
        let bottomBorder = SKSpriteNode(color: .white, size: topBorderSize)
        let topBorder = SKSpriteNode(color: .white, size: topBorderSize)
        
        
        //frame position
        leftBorder.position = CGPoint(x:-self.frame.width/2 + screenWidth/90 , y: 0)
        rightBorder.position = CGPoint(x: self.frame.width/2 - screenWidth/90 , y: 0)
        // y screenheight is sidesBorderSize denom * 2
        topBorder.position = CGPoint(x:0, y:leftBorder.position.y + screenHeight/5)
        bottomBorder.position = CGPoint(x:0, y: leftBorder.position.y - screenHeight/5)
        
        
        //physics body
        
        leftBorder.physicsBody = SKPhysicsBody(rectangleOf: sidesBorderSize)
        rightBorder.physicsBody = SKPhysicsBody(rectangleOf: sidesBorderSize)
        bottomBorder.physicsBody = SKPhysicsBody(rectangleOf: topBorderSize)
        topBorder.physicsBody = SKPhysicsBody(rectangleOf: topBorderSize)
        
        let borderArr = [leftBorder, rightBorder, topBorder, bottomBorder]
        
        for borderBody in borderArr{
            borderBody.physicsBody?.friction = 0
            borderBody.physicsBody?.restitution = 1
            borderBody.physicsBody?.collisionBitMask = ColliderType.Player
            borderBody.physicsBody?.angularDamping = 0
            borderBody.physicsBody?.linearDamping = 0
            borderBody.physicsBody?.affectedByGravity = false
            borderBody.physicsBody?.isDynamic = false
            
            self.addChild(borderBody)
            
        }
        
        topBorder.physicsBody?.categoryBitMask = ColliderType.topBorder
        bottomBorder.physicsBody?.categoryBitMask = ColliderType.bottomBorder
        rightBorder.physicsBody?.categoryBitMask = ColliderType.rightBorder
        leftBorder.physicsBody?.categoryBitMask = ColliderType.leftBorder
        
        
    }
    
    func startGame(){
        score.text = "0"
        score.fontSize = screenHeight/4
        
        timerCountdown.text = String(timerCountdownNum)
        timerCountdown.fontSize = coin.size.width/2
        
        
        
        //size nodes
        Player.texture = SKTexture(imageNamed:"blueball")
        coin.texture = SKTexture(imageNamed: "blueball")
        
        //set node positions
        Player.position = CGPoint(x: 0, y: 0)
        
        score.position = CGPoint(x:0, y: -screenHeight/7.5)
        score.zPosition = -10
        
        coin.position = CGPoint(x: screenWidth/7, y: screenWidth/7)
        coin.zPosition = 0
        
        timerCountdown.position = coin.position
        timerCountdown.zPosition = coin.zPosition + 1
        
        
        
        
        //player physics
        Player.physicsBody = SKPhysicsBody(texture: Player.texture!, size: Player.texture!.size())
        Player.physicsBody?.categoryBitMask = ColliderType.Player
        Player.physicsBody?.contactTestBitMask = ColliderType.Player | ColliderType.topBorder | ColliderType.bottomBorder
        Player.physicsBody?.collisionBitMask = ColliderType.Player | ColliderType.topBorder | ColliderType.bottomBorder | ColliderType.rightBorder
        Player.physicsBody?.isDynamic = true
        Player.physicsBody?.affectedByGravity = false
        Player.physicsBody?.angularDamping = 0
        Player.physicsBody?.linearDamping = 0
        Player.physicsBody?.restitution = 1
        Player.physicsBody?.friction = 0
        
        //coin physics
        coin.physicsBody = SKPhysicsBody(texture: coin.texture!, size: coin.texture!.size())
        coin.physicsBody?.categoryBitMask = ColliderType.coin
        coin.physicsBody?.contactTestBitMask = ColliderType.coin
        coin.physicsBody?.collisionBitMask = ColliderType.coin
        coin.physicsBody?.isDynamic = false
        coin.physicsBody?.affectedByGravity = false
        
        //add nodes
        self.addChild(Player)
        self.addChild(score)
        self.addChild(coin)
        self.addChild(timerCountdown)
        
        //timer for coin
        let coinTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(countdown), userInfo: nil, repeats: true)
    }
    
    
    func touchCoin(){
        //update score
        scoreNum += 1
        score.text = String(scoreNum)
        
        //move coin to new position
        let borderWidth = Int(self.frame.width/2 - screenWidth/90)
        let borderHeight = Int(leftBorder.position.y + screenHeight/5)
        let distanceW = Int(Player.size.width)
        let distanceH = Int(Player.size.height)
        let coinCoord = [Int.random(in: -borderWidth + distanceW...borderWidth - distanceW), Int.random(in: -borderHeight + distanceH...borderHeight - distanceH)]
        coin.run(SKAction.move(to: CGPoint(x: coinCoord[0], y: coinCoord[1]), duration: 0))
        
        //reset timer position and number
        timerCountdown.run(SKAction.move(to: CGPoint(x: coinCoord[0], y: coinCoord[1]), duration: 0))
        timerCountdown.zPosition = coin.zPosition + 1
        timerCountdownNum = 5
        timerCountdown.text = String(timerCountdownNum)
        
    }
    
    @objc func spawnMonsters(){
        let Monster = SKSpriteNode(color: .blue, size: CGSize(width: screenWidth/15, height: screenWidth/15))
        Monster.texture = SKTexture(imageNamed:"redball")
        
        monsterArray.append(Monster)
        
        
        //bullet phsyic body info
        Monster.physicsBody = SKPhysicsBody(texture: Monster.texture!, size: Monster.texture!.size())
        Monster.physicsBody?.restitution = 1
        Monster.physicsBody?.friction = 0
        Monster.physicsBody?.isDynamic = true
        Monster.physicsBody?.categoryBitMask = 1
        Monster.physicsBody?.collisionBitMask = 1
        Monster.physicsBody?.contactTestBitMask = 1
        Monster.physicsBody?.linearDamping = 0
        Monster.physicsBody?.angularDamping = 0
        Monster.physicsBody?.affectedByGravity = false
    
        
        // position and impulse
        //Monster.position = Spawner.position
        
        let monsterSpeeds = [-60, 60]
        self.addChild(Monster)
        Monster.physicsBody?.applyImpulse(CGVector(dx: monsterSpeeds.randomElement()!, dy: monsterSpeeds.randomElement()!))
        
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        speed = 60
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
        
        /*
        for touch in touches{
            //let location = touch.location(in: self)
            
            
            //if (joystickBase.frame.contains(location)){
    
            
        }
         */
    }
    

        
    
    override func update(_ currentTime: TimeInterval) {
        
        //player touching coin?
        
        if (isTouching(Player.position.x - coin.position.x, Player.position.y - coin.position.y, coin.size.width/1.9, Player.size.width/1.9)){
            
           touchCoin()
        }
        
         
        
        
         
    }
    
    @objc func countdown(timer: Timer){
        timerCountdownNum -= 1
        timerCountdown.text = String(timerCountdownNum)
        
        if timerCountdownNum == 0{
            timer.invalidate()
            gameOver()
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



