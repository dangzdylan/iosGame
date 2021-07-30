//
//  StartScene.swift
//  dodge2
//
//  Created by Dylan on 7/14/21.
//  Copyright © 2021 S-Crew. All rights reserved.
//

import SpriteKit
import GameplayKit

class StartScene: SKScene {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    let startLabel = SKLabelNode(text: "Press to start")
    
    override func didMove(to view: SKView) {
        //todo
        startLabel.fontSize = 40
        startLabel.position = CGPoint(x: 0, y: -20)
        
        self.addChild(startLabel)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches{
            let temp = GameScene(fileNamed: "GameScene")
            self.scene?.view?.presentScene(temp!, transition: SKTransition.doorsOpenVertical(withDuration: 1))
            let location = touch.location(in: self)
            
            if startLabel.contains(location){
                let temp = GameScene(fileNamed: "GameScene")
                self.scene?.view?.presentScene(temp!, transition: SKTransition.doorsOpenVertical(withDuration: 1))

            }
        }
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
        
    }
}
