//
//  borders.swift
//  dodge2
//
//  Created by Dylan on 8/1/21.
//  Copyright © 2021 S-Crew. All rights reserved.
//

import SpriteKit
import GameplayKit


func addBorders(self:GameScene){
    
    //frame declaration
    let sidesBorderSize = CGSize(width: screenWidth / 400, height: screenHeight/2.5)
    let topBorderSize = CGSize(width: screenHeight/3.5, height: screenWidth/400)


    //borders dec
    
    let borderColor:UIColor = .purple
    leftBorder = SKSpriteNode(color: borderColor, size: sidesBorderSize)
    rightBorder = SKSpriteNode(color: borderColor, size: sidesBorderSize)
    bottomBorder = SKSpriteNode(color: borderColor, size: topBorderSize)
    topBorder = SKSpriteNode(color: borderColor, size: topBorderSize)


    //frame position
    leftBorder.position = CGPoint(x:-frameWidth/2 + screenWidth/30 , y: 0)
    rightBorder.position = CGPoint(x: frameWidth/2 - screenWidth/30 , y: 0)
    
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
  
    

