//
//  GameScene.swift
//  Bricks
//
//  Created by Rico Zuniga on 12/1/14.
//  Copyright (c) 2014 Ulap. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let block = SKSpriteNode(color: SKColor.orangeColor(), size: CGSize(width: 50, height: 50))
        block.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        
        self.addChild(block)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
