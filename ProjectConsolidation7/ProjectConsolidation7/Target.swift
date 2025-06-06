//
//  Target.swift
//  ProjectConsolidation7
//
//  Created by Gustavo Isaac Lopez Nunez on 06/06/25.
//

import UIKit
import SpriteKit

enum SpawnSides {
    case top
    case middle
    case bottom
}

enum TargetTypes {
    case good
    case bad
}

enum TargetSizes {
    case big
    case small
}

class Target: SKNode {
    var target: SKSpriteNode!
    var stick: SKSpriteNode!
    var isHit =  false
    var targetType: TargetTypes!
    var targetSize: TargetSizes!
    let goodTarget = "target0"
    let badTarget = ["target1", "target2", "target3"]
    
    func configure(side: SpawnSides, size: TargetSizes, type: TargetTypes) {
        var targetImage: String!
        var speed: Double!
        targetType = type
        targetSize = size
        
        if targetType == .good {
            targetImage = goodTarget
        } else if targetType == .bad {
            targetImage = badTarget.randomElement()!
        }
        
        target = SKSpriteNode(imageNamed: targetImage)
        target.zPosition = 0

        if targetSize == .big {
            speed = Double.random(in: 4...5)
            if let curSize = target.texture?.size() {
                target.size = CGSize(width: curSize.width * 1.2, height: curSize.height * 1.2)
            }
        } else if targetSize == .small {
            speed = Double.random(in: 2...3)
            if let curSize = target.texture?.size() {
                target.size = CGSize(width: curSize.width * 0.8, height: curSize.height * 0.8)
            }
        }
        addChild(target)
        
        let sticks = ["stick0", "stick1", "stick2"]
        stick = SKSpriteNode(imageNamed: sticks.randomElement()!)
        stick.position = CGPoint(x: 0, y: -stick.size.height / 2)
        target.addChild(stick)
        stick.zPosition = -1 // behind the target

        switch side {
        case.top:
            self.position = CGPoint(x: -100, y: 250)
            self.run(
                SKAction.sequence([
                    SKAction.moveBy(x: 1400, y: 0, duration: speed),
                    SKAction.removeFromParent()
                ])
            )
        case .middle:
            self.position = CGPoint(x: 1124, y: 350)
            self.xScale = -1
            
            self.run(
                SKAction.sequence([
                    SKAction.moveBy(x: -1400, y: 0, duration: speed),
                    SKAction.removeFromParent()
                ])
            )
        case .bottom:
            self.position = CGPoint(x: -100, y: 450)
            
            self.run(
                SKAction.sequence([
                    SKAction.moveBy(x: 1400, y: 0, duration: speed),
                    SKAction.removeFromParent()
                ])
            )
        }
    }
    
    func hit() {
        if !isHit {
            isHit = true
            
            self.removeAllActions()
            
            let movements = SKAction.group([
                SKAction.moveBy(x: 0, y: -130, duration: 0.3),
                SKAction.scaleX(to: -Double.random(in: 0...0.5), duration: 0.5),
                SKAction.scaleY(to: 0.2, duration: 0.5)
            ])
            
            self.run(
                SKAction.sequence([
                    movements,
                    SKAction.removeFromParent()
                ])
            )
        }
    }
}
