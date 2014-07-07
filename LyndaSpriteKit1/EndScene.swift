//
//  EndScene.swift
//  LyndaSpriteKit1
//
//  Created by Jim Snodgrass on 7/7/14.
//  Copyright (c) 2014 Jim Snodgrass. All rights reserved.
//

import SpriteKit

class EndScene: SKScene {
    
    let endingSound = SKAction.playSoundFileNamed("end.wav", waitForCompletion: false)
    
    override func didMoveToView(view: SKView) {
        backgroundColor = SKColor.blackColor()
        addGameOverLabel()
        addTryAgainLabel()
        runAction(endingSound)
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let game = GameScene.sceneWithSize(size)
            game.scaleMode = .AspectFit
            view.presentScene(game, transition: SKTransition.doorsOpenHorizontalWithDuration(1.0))
        }
    }
    
    func addGameOverLabel() {
        let gameOverLabel = SKLabelNode(text: "Game Over")
        gameOverLabel.fontName = "Futura Medium"
        gameOverLabel.position = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame) + 20)
        gameOverLabel.fontColor = SKColor.whiteColor()
        gameOverLabel.fontSize = 44
        addChild(gameOverLabel)
    }
    
    func addTryAgainLabel() {
        let label = SKLabelNode(text: "tap to play again")
        label.fontColor = SKColor.whiteColor()
        label.fontSize = 24
        label.position = CGPointMake(CGRectGetMidX(frame), -50)
        
        let moveAction = SKAction.moveToY(CGRectGetMidY(frame) - 40, duration: 1.0)
        label.runAction(moveAction)
        
        addChild(label)
    }

}
