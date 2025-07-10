//
//  GameViewController.swift
//  Project29
//
//  Created by Gustavo Isaac Lopez Nunez on 07/07/25.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    var currentGame: GameScene!
    @IBOutlet var angleSlider: UISlider!
    @IBOutlet var angleLabel: UILabel!
    @IBOutlet var velocitySlider: UISlider!
    @IBOutlet var velocityLabel: UILabel!
    @IBOutlet var launchButton: UIButton!
    @IBOutlet var playerNumber: UILabel!
    @IBOutlet var playerOneScore: UILabel!
    @IBOutlet var playerTwoScore: UILabel!
    @IBOutlet var windLabel: UILabel!
    
    var pOneScore = 0 {
        didSet {
            playerOneScore.text = "\(pOneScore)"
        }
    }
    var pTwoScore = 0 {
        didSet {
            playerTwoScore.text = "\(pTwoScore)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        angleChanged(self)
        velocityChanged(self)
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                currentGame = scene as? GameScene
                currentGame.viewController = self

                // Present the scene
                view.presentScene(scene)                
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    @IBAction func angleChanged(_ sender: Any) {
        angleLabel.text = "Angle: \(Int(angleSlider.value))°"
    }
    
    @IBAction func velocityChanged(_ sender: Any) {
        velocityLabel.text = "Velocity: \(Int(velocitySlider.value))"
    }
    
    @IBAction func launch(_ sender: Any) {
        angleSlider.isHidden = true
        angleLabel.isHidden = true

        velocitySlider.isHidden = true
        velocityLabel.isHidden = true

        launchButton.isHidden = true

        currentGame.launch(angle: Int(angleSlider.value), velocity: Int(velocitySlider.value))
    }
    
    func activatePlayer(number: Int) {
        if number == 1 {
            playerNumber.text = "<<< PLAYER ONE"
        } else {
            playerNumber.text = "PLAYER TWO >>>"
        }

        angleSlider.isHidden = false
        angleLabel.isHidden = false

        velocitySlider.isHidden = false
        velocityLabel.isHidden = false

        launchButton.isHidden = false
    }
    
    func addScore(toPlayer currentPlayer: Int) {
        if currentPlayer == 1 {
            pOneScore += 1
        } else {
            pTwoScore += 1
        }
        if pOneScore == 3 || pTwoScore == 3 {
            endGame()
        }
    }
    
    func endGame() {
        if pOneScore == 3 {
            playerNumber.text = "PLAYER 1 WINS!"
        } else if pTwoScore == 3 {
            playerNumber.text = "PLAYER 2 WINS!"
        }
        
        angleSlider.isHidden    = true
        angleLabel.isHidden     = true
        velocitySlider.isHidden = true
        velocityLabel.isHidden  = true
        launchButton.isHidden   = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.restartGame()
        }
    }

    private func restartGame() {
        pOneScore = 0
        pTwoScore = 0
        playerOneScore.text = "0"
        playerTwoScore.text = "0"

        playerNumber.text = "<<< PLAYER ONE"
        activatePlayer(number: 1)

        if let skView = self.view as? SKView,
           let newScene = SKScene(fileNamed: "GameScene") as? GameScene {
            newScene.scaleMode = .aspectFill
            newScene.viewController = self
            currentGame = newScene
            skView.presentScene(newScene,
                                transition: .doorway(withDuration: 1.0))
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
