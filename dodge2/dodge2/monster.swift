//
//  monster.swift
//  dodge2
//
//  Created by Dylan on 8/2/21.
//  Copyright © 2021 S-Crew. All rights reserved.
//

import SpriteKit
import GameplayKit


func spawnMonsters(self:GameScene){
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
