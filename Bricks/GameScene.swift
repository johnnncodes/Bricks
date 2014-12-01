//
//  GameScene.swift
//  Bricks
//
//  Created by Rico Zuniga on 12/1/14.
//  Copyright (c) 2014 Ulap. All rights reserved.
//

import SpriteKit

let colors: [SKColor] = [
    SKColor.lightGrayColor(),
    SKColor.cyanColor(),
    SKColor.yellowColor(),
    SKColor.magentaColor(),
    SKColor.blueColor(),
    SKColor.orangeColor(),
    SKColor.greenColor(),
    SKColor.redColor(),
    SKColor.darkGrayColor()
]

let blockSize: CGFloat = 18.0
let defaultSpeed = NSTimeInterval(1200)

class GameScene: SKScene {
    var dropTime = defaultSpeed
    var lastUpdate:NSDate?

    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.anchorPoint = CGPoint(x: 0, y: 1.0)
        lastUpdate = NSDate()
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            drawTetrominoAtPoint(touch.locationInNode(self))
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if lastUpdate != nil {
            let elapsed = lastUpdate!.timeIntervalSinceNow * -1000.0
            if elapsed > dropTime {
                moveTetrominoesDown()
            }
        }
    }
    
    func drawTetrominoAtPoint(location: CGPoint) {
        let t = Tetromino()
        for row in 0..<t.bitmap.count {
            for col in 0..<t.bitmap[row].count {
                if t.bitmap[row][col] > 0 {
                    let block = t.bitmap[row][col]
                    let square = SKSpriteNode(color: colors[block], size: CGSize(width: blockSize, height: blockSize))
                    square.anchorPoint = CGPoint(x: 1.0, y: 0)
                    square.position = CGPoint(x: col * Int(blockSize) + col, y: -row * Int(blockSize) + -row)
                    square.position.x += location.x
                    square.position.y += location.y
                    self.addChild(square)
                }
            }
        }
    }
    
    func moveTetrominoesDown() {
        let squares = self.children as [SKSpriteNode]
        for square in squares {
            square.position.y += CGFloat(-blockSize)
        }
        lastUpdate = NSDate()
    }
}
