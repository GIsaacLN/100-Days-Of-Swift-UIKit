//
//  GameScene.swift
//  ProjectConsolidation7
//
//  Created by Gustavo Isaac Lopez Nunez on 06/06/25.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var targetTimer: Timer?
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "\(score) points"
        }
    }
    var gameTimer: Timer?
    var timeLabel: SKLabelNode!
    var time = 60 {
        didSet {
            timeLabel.text = "\(time) seconds"
        }
    }
    var bullets: SKSpriteNode!
    var curBullets = 3 {
        didSet {
            bullets.texture = SKTexture(imageNamed: "shots\(curBullets)")
        }
    }
    var reload: SKLabelNode!
    var isGameOver = false
    
    override func didMove(to view: SKView) {        
        let woodBackground = SKSpriteNode(imageNamed: "wood-background")
        woodBackground.position = CGPoint(x: 512, y: 384)
        woodBackground.blendMode = .replace
        woodBackground.isUserInteractionEnabled = false
        woodBackground.size = CGSize(width: size.width, height: size.height)
        woodBackground.zPosition = -2
        addChild(woodBackground)
        
        let treesBackground = SKSpriteNode(imageNamed: "grass-trees")
        treesBackground.zPosition = -1
        treesBackground.isUserInteractionEnabled = false
        treesBackground.position = CGPoint(x: size.width / 2, y: size.height / 2 + 80)

        if let textureSize = treesBackground.texture?.size() {
            let widthRatio = size.width / textureSize.width
            let heightRatio = size.height / textureSize.height

            let scale = min(widthRatio, heightRatio)

            treesBackground.size = CGSize(width: textureSize.width * scale,
                                          height: textureSize.height * scale)
        }

        addChild(treesBackground)

        let water1 = SKSpriteNode(imageNamed: "water-bg")
        water1.position = CGPoint(x: size.width/2 , y: 120)
        water1.isUserInteractionEnabled = false
        water1.zPosition = 6
        
        let water2 = SKSpriteNode(imageNamed: "water-fg")
        water2.position = CGPoint(x: size.width/2 , y: 220)
        water2.isUserInteractionEnabled = false
        water2.zPosition = 4
        
        let water3 = SKSpriteNode(imageNamed: "water-bg")
        water3.position = CGPoint(x: size.width/2 , y: 320)
        water3.isUserInteractionEnabled = false
        water3.zPosition = 2
        
        if let textureSizeWater = water1.texture?.size() {
            let widthRatio = size.width / textureSizeWater.width
            let heightRatio = size.height / textureSizeWater.height

            let scale = min(widthRatio, heightRatio)

            water1.size = CGSize(width: textureSizeWater.width * scale, height: textureSizeWater.height * scale - 100)
            water2.size = CGSize(width: textureSizeWater.width * scale, height: textureSizeWater.height * scale - 100)
            water3.size = CGSize(width: textureSizeWater.width * scale, height: textureSizeWater.height * scale - 100)
        }
        
        addChild(water1)
        addChild(water2)
        addChild(water3)

        let curtains = SKSpriteNode(imageNamed: "curtains")
        curtains.position = CGPoint(x: 512, y: 384)
        curtains.size = CGSize(width: size.width, height: size.height)
        curtains.zPosition = 9
        curtains.isUserInteractionEnabled = false
        addChild(curtains)
        
        timeLabel = SKLabelNode(fontNamed: "Menlo-Bold")
        timeLabel.text = "\(time) seconds"
        timeLabel.position = CGPoint(x: 20, y: size.height - 50)
        timeLabel.horizontalAlignmentMode = .left
        timeLabel.fontSize = 30
        timeLabel.zPosition = 10
        addChild(timeLabel)

        scoreLabel = SKLabelNode(fontNamed: "Menlo-Bold")
        scoreLabel.text = "\(score) points"
        scoreLabel.position = CGPoint(x: 20, y: size.height - 100)
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.fontSize = 30
        scoreLabel.zPosition = 10
        addChild(scoreLabel)
        
        bullets = SKSpriteNode(imageNamed: "shots3")
        bullets.position = CGPoint(x: size.width - 60, y: size.height - 50)
        bullets.zPosition = 10
        addChild(bullets)
        
        reload = SKLabelNode(fontNamed: "Menlo-Bold")
        reload.name = "reload"
        reload.text = "Tap here to reload!"
        reload.fontSize = 48
        reload.position = CGPoint(x: size.width/2, y: 80)
        reload.zPosition = 10
        addChild(reload)
        
        targetTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(createTarget), userInfo: nil, repeats: true)
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(decreaseTime), userInfo: nil, repeats: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        if isGameOver {
            restart()
            return
        }
        if location.y < 150 {
            curBullets = 3
            run(SKAction.playSoundFileNamed("reload.wav", waitForCompletion: false))
            return
        }
        
        if curBullets <= 0 {
            run(SKAction.playSoundFileNamed("empty.wav", waitForCompletion: false))
            return
        }
        
        run(SKAction.playSoundFileNamed("shot.wav", waitForCompletion: false))
        curBullets -= 1
        var didShotTarget = false
        for node in tappedNodes {
            guard let target = node as? Target else { continue }
            didShotTarget = true
            if target.isHit { continue }
            target.hit()
            
            if target.targetType == .bad && target.targetSize == .big {
                score -= 50
            } else if target.targetType == .bad && target.targetSize == .small {
                score -= 10
            } else if target.targetType == .good && target.targetSize == .big {
                score += 10
            } else if target.targetType == .good && target.targetSize == .small{
                score += 50
            }
        }
        if !didShotTarget {
            score -= 2
        }

    }
    
    @objc func createTarget() {
        let types = [TargetTypes.bad, TargetTypes.good, TargetTypes.good, TargetTypes.good]
        let sizes = [TargetSizes.big, TargetSizes.small]
        let sides = [SpawnSides.bottom, SpawnSides.middle, SpawnSides.top]
        let targetSide = sides.randomElement()!
        let targetSize = sizes.randomElement()!
        let targetType = types.randomElement()!

        let target = Target()
        target.configure(side: targetSide, size: targetSize, type: targetType)
        switch targetSide {
        case .top:
            target.zPosition = 5
        case .middle:
            target.zPosition = 3
        case .bottom:
            target.zPosition = 1
        }
        
        addChild(target)
    }
    
    @objc func decreaseTime() {
        time -= 1
        
        if time == 0{
            gameOver()
        }
    }
    
    func gameOver() {
        isGameOver = true
        gameTimer?.invalidate()
        targetTimer?.invalidate()
        
        let gameOverLabel = SKSpriteNode(imageNamed: "game-over")
        gameOverLabel.name = "gameOver"
        gameOverLabel.position = CGPoint(x: size.width/2, y: size.height/2 + 50)
        gameOverLabel.zPosition = 10
        addChild(gameOverLabel)
        
        let finalScore = SKLabelNode(fontNamed: "Menlo-Bold")
        finalScore.text = "Final score: \(score)"
        finalScore.name = "finalScore"
        finalScore.position = CGPoint(x: size.width/2, y: size.height/2 - 50)
        finalScore.horizontalAlignmentMode = .center
        finalScore.zPosition = 10
        finalScore.fontSize = 48
        addChild(finalScore)
        
        let message = SKLabelNode(fontNamed: "Menlo-Bold")
        message.text = "Tap anywhere to restart game"
        message.name = "restart"
        message.position = CGPoint(x: size.width/2, y: size.height/2 - 150)
        message.horizontalAlignmentMode = .center
        message.zPosition = 10
        message.fontSize = 48
        addChild(message)
        
        scoreLabel.alpha = 0
        timeLabel.alpha = 0
        bullets.alpha = 0
        reload.alpha = 0
        
        for node in children {
            guard let target = node as? Target else { continue }
            target.removeAllActions()
            
            let movements = SKAction.group([
                SKAction.moveBy(x: 0, y: -130, duration: 0.3),
                SKAction.scaleX(to: -Double.random(in: 0...0.5), duration: 0.5),
                SKAction.scaleY(to: 0.2, duration: 0.5)
            ])
            
            target.run(
                SKAction.sequence([
                    movements,
                    SKAction.removeFromParent()
                ])
            )

        }
    }
    
    func restart() {
        isGameOver = false
        score = 0
        time = 60
        curBullets = 3
        
        for node in children{
            if node.name == "gameOver" || node.name == "restart" || node.name == "finalScore" {
                node.removeFromParent()
            }
        }
        
        scoreLabel.alpha = 1
        timeLabel.alpha = 1
        bullets.alpha = 1
        reload.alpha = 1
        
        targetTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(createTarget), userInfo: nil, repeats: true)
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(decreaseTime), userInfo: nil, repeats: true)
    }
    
    override func update(_ currentTime: TimeInterval) {
        for node in children{
            if node.position.x < -300 || node.position.x > 1324{
                node.removeFromParent()
            }
        }
    }
}
