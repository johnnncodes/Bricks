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

let gameBitmapDefault: [[Int]] = [
    [8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8],
    [8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8],
    [8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8],
    [8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8],
    [8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8],
    [8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8],
    [8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8],
    [8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8],
    [8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8],
    [8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8],
    [8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8],
    [8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8],
    [8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8],
    [8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8],
    [8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8],
    [8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8],
    [8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8],
    [8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8],
    [8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8],
    [8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8],
    [8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8],
    [8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8]
]

let blockSize: CGFloat = 18.0
let defaultSpeed = NSTimeInterval(1200)

class GameScene: SKScene {
    var dropTime = defaultSpeed
    var lastUpdate:NSDate?
    
    let gameBoard = SKSpriteNode()
    var activeTetromino = Tetromino()
    
    var gameBitmapDynamic = gameBitmapDefault
    var gameBitmapStatic = gameBitmapDefault

    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.anchorPoint = CGPoint(x: 0, y: 1.0)

        gameBoard.anchorPoint = CGPoint(x: 0, y: 1.0)
        for col in 0..<gameBitmapDefault[0].count {
            for row in 0..<gameBitmapDefault.count {
                let bit = gameBitmapDefault[row][col]
                let square = SKSpriteNode(color: colors[bit], size: CGSize(width: blockSize, height: blockSize))
                square.anchorPoint = CGPoint(x: 0, y: 0)
                square.position = CGPoint(x: col * Int(blockSize) + col, y: -row * Int(blockSize) + -row)
                gameBoard.addChild(square)
            }
        }
        
        let gameBoardFrame = gameBoard.calculateAccumulatedFrame()
        gameBoard.position = CGPoint(x: CGRectGetMidX(self.frame) - gameBoardFrame.width / 2, y: -125)
        self.addChild(gameBoard)
        
        centerActiveTetromino()
        refresh()
        lastUpdate = NSDate()
    }
    
    func centerActiveTetromino() {
        let cols = gameBitmapDefault[0].count
        let brickWidth = activeTetromino.bitmap[0].count
        activeTetromino.position = (cols / 2 -  brickWidth, 0)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if lastUpdate != nil {
            let elapsed = lastUpdate!.timeIntervalSinceNow * -1000.0
            if elapsed > dropTime {
                moveTetrominoDown()
            }
        }
    }
    
    func moveTetrominoDown() {
        if landed() {
            gameBitmapStatic.removeAll(keepCapacity: true)
            gameBitmapStatic = gameBitmapDynamic
            
            activeTetromino = Tetromino()
            centerActiveTetromino()
        } else {
            activeTetromino.moveTo(.Down)
            
        }
        
        lastUpdate = NSDate()
        refresh()
    }
    
    func landed() -> Bool {
        let x = activeTetromino.position.x
        let y = activeTetromino.position.y + 1
        for row in 0..<activeTetromino.bitmap.count {
            for col in 0..<activeTetromino.bitmap[row].count {
                if activeTetromino.bitmap[row][col] > 0 && gameBitmapStatic[y + row][x + col + 1] > 0 {
                    return true
                }
            }
        }
        return false
    }
    
    func refresh() {
        updateGameBitmap()
        updateGameBoard()
    }
    
    func updateGameBitmap() {
        gameBitmapDynamic.removeAll(keepCapacity: true)
        gameBitmapDynamic = gameBitmapStatic
        
        for row in 0..<activeTetromino.bitmap.count {
            for col in 0..<activeTetromino.bitmap[row].count {
                if activeTetromino.bitmap[row][col] > 0 {
                    gameBitmapDynamic[activeTetromino.position.y + row][activeTetromino.position.x + col + 1] = activeTetromino.bitmap[row][col]
                }
            }
        }
    }
    
    func updateGameBoard() {
        let squares = gameBoard.children as [SKSpriteNode]
        var currentSquare = 0
        
        for col in 0..<gameBitmapDynamic[0].count {
            for row in 0..<gameBitmapDynamic.count {
                let bit = gameBitmapDynamic[row][col]
                let square = squares[currentSquare]
                if square.color != colors[bit] {
                    square.color = colors[bit]
                }
                ++currentSquare
            }
        }
    }
}
