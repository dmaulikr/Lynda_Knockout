//
//  GameScene.swift
//  LyndaSpriteKit1
//
//  Created by Jim Snodgrass on 7/4/14.
//  Copyright (c) 2014 Jim Snodgrass. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // game constants
    let ballSpeed: CGFloat = 7.0
    let paddleDistanceFromBottom: CGFloat = 50.0
    
    // load art assets
    let paddle = SKSpriteNode(imageNamed: "Paddle")
    let ball = SKSpriteNode(imageNamed: "Ball")

    // load sound assets
    let paddleSound = SKAction.playSoundFileNamed("blip.wav", waitForCompletion: false)
    let brickSound = SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: false)
    
    // setup bitmask categories using bitwise operators
    let ballCategory: UInt32 = 0x1
    let brickCategory: UInt32 = 0x1 << 1
    let paddleCategory: UInt32 = 0x1 << 2
    let edgeCategory: UInt32 = 0x1 << 3
    let bottomEdgeCategory: UInt32 = 0x1 << 4
    
    override func didMoveToView(view: SKView) {
        setupScene()
        addBottomEdge()
        addBall()
        addPlayer()
        addBricks()
    }
    
    func didBeginContact(contact: SKPhysicsContact) {        
        var notTheBall = contact.bodyA
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            notTheBall = contact.bodyB
        }
        
        if notTheBall.categoryBitMask == brickCategory {
            notTheBall.node.removeFromParent()
            runAction(brickSound)
        }
        
        if notTheBall.categoryBitMask == paddleCategory {
            runAction(paddleSound)
        }
        
        if notTheBall.categoryBitMask == bottomEdgeCategory {
            let end = EndScene.sceneWithSize(size)
            end.scaleMode = .AspectFit
            view.presentScene(end, transition: SKTransition.doorsCloseHorizontalWithDuration(0.5))
        }
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            paddle.position = CGPointMake(paddleEdgeBounds(CGFloat(location.x)), paddleDistanceFromBottom)
        }
    }
    
    func paddleEdgeBounds(xPosition: CGFloat) -> CGFloat {
        let minX = paddle.frame.size.width/2
        let maxX = size.width - paddle.frame.size.width/2
        if xPosition < minX {
            return minX
        }
        if xPosition > maxX {
            return maxX
        }
        return xPosition
    }
    
    func setupScene() {
        backgroundColor = SKColor.whiteColor()
        physicsBody = SKPhysicsBody(edgeLoopFromRect: frame)
        physicsBody.categoryBitMask = edgeCategory
        physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self
    }
    
    func addBottomEdge() {
        let edge = SKNode()
        edge.physicsBody = SKPhysicsBody(edgeFromPoint: CGPointMake(0, 1), toPoint: CGPointMake(size.width, 1))
        edge.physicsBody.categoryBitMask = bottomEdgeCategory
        addChild(edge)
    }
    
    func addBall() {
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.frame.size.width/2)
        ball.physicsBody.restitution = 1
        ball.physicsBody.friction = 0
        ball.physicsBody.linearDamping = 0
        ball.physicsBody.categoryBitMask = ballCategory
        ball.physicsBody.contactTestBitMask = brickCategory | paddleCategory | bottomEdgeCategory
        ball.position = CGPointMake(size.width/2, size.height/2)
        addChild(ball)
        ball.physicsBody.applyImpulse(CGVectorMake(ballSpeed, ballSpeed))
    }
    
    func addPlayer() {
        paddle.position = CGPointMake(size.width/2, paddleDistanceFromBottom)
        paddle.physicsBody = SKPhysicsBody(rectangleOfSize: paddle.frame.size)
        paddle.physicsBody.dynamic = false
        paddle.physicsBody.categoryBitMask = paddleCategory
        
        addChild(paddle)
    }
    
    func addBricks() {
        for i in 0...3 {
            addBrick(CGFloat(i))
        }
    }
    
    func addBrick(index: CGFloat) {
        let brick = SKSpriteNode(imageNamed: "Brick")
        let xPos = size.width/5.0 * (index + 1.0)
        let yPos = size.height - 50.0
        brick.position = CGPointMake(xPos, yPos)
        brick.physicsBody = SKPhysicsBody(rectangleOfSize: brick.frame.size)
        brick.physicsBody.dynamic = false
        brick.physicsBody.categoryBitMask = brickCategory
        addChild(brick)
    }
    

}




