//
//  coin.swift
//  dodge2
//
//  Created by Dylan on 8/2/21.
//  Copyright © 2021 S-Crew. All rights reserved.
//

import SpriteKit
import GameplayKit




func addCoin(self:GameScene){
    let radius = screenWidth/30
    coin = SKSpriteNode(color: .yellow, size: CGSize(width: screenWidth/30, height: screenWidth/30))
    
    //coin.texture = SKTexture(imageNamed: "blueball")
    
    coin.position = CGPoint(x: screenWidth/7, y: screenWidth/7)
    coin.zPosition = 0
    
    //coin physics
    coin.physicsBody = SKPhysicsBody(circleOfRadius: radius)
    coin.physicsBody?.categoryBitMask = ColliderType.coin
    coin.physicsBody?.contactTestBitMask = ColliderType.coin
    coin.physicsBody?.collisionBitMask = ColliderType.coin
    coin.physicsBody?.isDynamic = false
    coin.physicsBody?.affectedByGravity = false
    
    self.addChild(coin)
    
}

func touchCoin(self:GameScene){
    //update score
    scoreNum += 1
    score.text = String(scoreNum)
    
    //move coin to new position
    let borderWidth = Int(self.frame.width/2 - screenWidth/90)
    //0 = leftBorder y coord
    let borderHeight = Int(0 + screenHeight/5)
    let distanceW = Int(Player.size.width)
    let distanceH = Int(Player.size.height)
    let coinCoord = [Int.random(in: -borderWidth + distanceW...borderWidth - distanceW), Int.random(in: -borderHeight + distanceH...borderHeight - distanceH)]
    coin.run(SKAction.move(to: CGPoint(x: coinCoord[0], y: coinCoord[1]), duration: 0))
    
    
}
