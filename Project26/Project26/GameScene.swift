//
//  GameScene.swift
//  Project26
//
//  Created by Gustavo Isaac Lopez Nunez on 28/06/25.
//

import CoreMotion
import SpriteKit
import GameplayKit

enum CollisionTypes: UInt32 {
    case player = 1
    case wall = 2
    case star = 4
    case vortex = 8
    case finish = 16
    case teleport = 32
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    var player: SKSpriteNode!
    var lastTouchPosition: CGPoint?
    var motionManager: CMMotionManager!
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet{
            scoreLabel.text = "Score: \(score)"
        }
    }
    var isGameOver = false
    var level = 1
    var levelNodes = [SKSpriteNode]()
    private var lastTeleport: SKNode?

    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background.jpg")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.zPosition = 2
        addChild(scoreLabel)
        
        loadLevel()
        createPlayer()
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        motionManager = CMMotionManager()
        motionManager.startAccelerometerUpdates()
    }
    
    func playerCollided(with node: SKNode) {
        if node.name == "vortex" {
            player.physicsBody?.isDynamic = false
            isGameOver = true
            score -= 1
            
            let move = SKAction.move(to: node.position, duration: 0.25)
            let scale = SKAction.scale(to: 0.0001, duration: 0.25)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([move,scale,remove])
            
            player.run(sequence) { [weak self] in
                self?.createPlayer()
                self?.isGameOver = false
            }
        } else if node.name == "star" {
            node.removeFromParent()
            levelNodes.removeAll { $0 == node }
            score += 1
        } else if node.name == "finish" {
            level += 1
            if level <= 3 {
                loadLevel()
                player.removeFromParent()
                createPlayer()
            } else {
                let gameOver = SKLabelNode(fontNamed: "Chalkduster")
                gameOver.text = "Game Over"
                gameOver.fontSize = 64
                gameOver.horizontalAlignmentMode = .center
                gameOver.position = CGPoint(x: 512, y: 384)
                gameOver.zPosition = 2
                addChild(gameOver)
                
                player.removeFromParent()
            }
        } else if node.name == "teleport" {
            // if this is the one we just arrived at, ignore it and clear the flag
            if node == lastTeleport {
                lastTeleport = nil
                return
            }

            // find both teleports in the level
            let teleports = levelNodes
                .filter { $0.name == "teleport" }
            guard teleports.count == 2 else { return }

            // pick the one that isn't the one we just hit
            let destination = teleports.first { $0 != node }!

            // remember "don't teleport back" for the next contact
            lastTeleport = destination

            // temporarily disable physics so we don't re-collide mid-move
            player.physicsBody?.isDynamic = false

            // move the player over, then re-enable physics
            let move = SKAction.move(to: destination.position, duration: 0.2)
            let reenable = SKAction.run { [weak self] in
                self?.player.physicsBody?.isDynamic = true
            }
            player.run(.sequence([move, reenable]))

        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA == player {
            playerCollided(with: nodeB)
        } else if nodeB == player {
            playerCollided(with: nodeA)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchPosition = nil
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard isGameOver == false else { return }
        #if targetEnvironment(simulator)
        if let currentTouch = lastTouchPosition {
            let diff = CGPoint(x: currentTouch.x - player.position.x, y: currentTouch.y - player.position.y)
            physicsWorld.gravity = CGVector(dx: diff.x / 100, dy: diff.y / 100)
        }
        #else
        if let accelerometerData = motionManager.accelerometerData {
            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.y * -50, dy: accelerometerData.acceleration.x * 50)
        }
        #endif
    }
    
    func createPlayer() {
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 96, y: 672)
        player.zPosition = 1
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.linearDamping = 0.5

        player.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player.physicsBody?.contactTestBitMask = CollisionTypes.star.rawValue | CollisionTypes.vortex.rawValue | CollisionTypes.finish.rawValue | CollisionTypes.teleport.rawValue
        player.physicsBody?.collisionBitMask = CollisionTypes.wall.rawValue
        addChild(player)

    }
    
    func loadLevel() {
        guard let levelURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") else {
            fatalError("Couldn't find level\(level).txt in the app bundle")
        }
        guard let levelString = try? String(contentsOf: levelURL) else {
            fatalError("Couldn't load level\(level).txt from the app bundle")
        }
        
        for (index, levelNode) in levelNodes.enumerated().reversed() {
            levelNode.removeFromParent()
            levelNodes.remove(at: index)
        }
        
        let lines = levelString.components(separatedBy: "\n")
        
        for (row, line) in lines.reversed().enumerated() {
            for (column, letter) in line.enumerated() {
                let position = CGPoint(x: (64 * column) + 32, y: (64 * row) + 32)
                createBlock(letter, at: position)
            }
        }
    }
    
    func createBlock(_ letter: Character, at position: CGPoint) {
        if letter == "x" {
            let node = SKSpriteNode(imageNamed: "block")
            node.position = position

            node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
            node.physicsBody?.categoryBitMask = CollisionTypes.wall.rawValue
            node.physicsBody?.isDynamic = false
            addChild(node)
            levelNodes.append(node)
        } else if letter == "v"  {
            let node = SKSpriteNode(imageNamed: "vortex")
            node.name = "vortex"
            node.position = position
            node.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 1)))
            node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
            node.physicsBody?.isDynamic = false

            node.physicsBody?.categoryBitMask = CollisionTypes.vortex.rawValue
            node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
            node.physicsBody?.collisionBitMask = 0
            addChild(node)
            levelNodes.append(node)
        } else if letter == "s"  {
            let node = SKSpriteNode(imageNamed: "star")
            node.name = "star"
            node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
            node.physicsBody?.isDynamic = false

            node.physicsBody?.categoryBitMask = CollisionTypes.star.rawValue
            node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
            node.physicsBody?.collisionBitMask = 0
            node.position = position
            addChild(node)
            levelNodes.append(node)
        } else if letter == "f"  {
            let node = SKSpriteNode(imageNamed: "finish")
            node.name = "finish"
            node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
            node.physicsBody?.isDynamic = false

            node.physicsBody?.categoryBitMask = CollisionTypes.finish.rawValue
            node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
            node.physicsBody?.collisionBitMask = 0
            node.position = position
            addChild(node)
            levelNodes.append(node)
        } else if letter == "t" {
            let node = SKSpriteNode(imageNamed: "vortex")
            node.name = "teleport"
            node.position = position
            node.colorBlendFactor = 0.5
            node.color = .blue
            node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width/2)
            node.physicsBody?.isDynamic = false

            node.physicsBody?.categoryBitMask    = CollisionTypes.teleport.rawValue
            node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
            node.physicsBody?.collisionBitMask   = 0

            addChild(node)
            levelNodes.append(node)
        } else if letter == " " {
            // this is an empty space – do nothing!
        } else {
            fatalError("Unknown level letter: \(letter)")
        }
    }
}
