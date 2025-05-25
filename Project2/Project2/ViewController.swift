//
//  ViewController.swift
//  Project2
//
//  Created by Gustavo Isaac Lopez Nunez on 23/03/25.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var score = 0
    var highscore = 0 {
        didSet {
            let defaults = UserDefaults()
            defaults.set(highscore, forKey: "highscore")
        }
    }
    var correctAnswer = 0
    var currentQuestion = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "star.fill"), style: .plain, target: self, action: #selector(getScore))
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        let defaults = UserDefaults.standard
        highscore = defaults.integer(forKey: "highscore")
        askQuestion()
    }

    func askQuestion(action: UIAlertAction? = nil) {
        currentQuestion += 1

        if currentQuestion > 10 {
            var message = """
                        Your Final Score is \(score)
                        Your Highscore is: \(highscore)
                        """
            if score > highscore {
                highscore = score
                message = """
                        You beat your highscore
                        Your new highscore is: \(highscore)
                        """
            }
            let ac = UIAlertController(title: "Game Over", message: message, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Play Again", style: .default, handler: restartGame))
            present(ac, animated: true)
            return
        }
        
        countries.shuffle()
        correctAnswer = Int.random(in: 0..<3)
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.button1.transform = .identity
            self?.button2.transform = .identity
            self?.button3.transform = .identity
        }
        
        title = countries[correctAnswer].uppercased()
    }
    
    func restartGame(action: UIAlertAction? = nil) {
        score = 0
        currentQuestion = 0
        askQuestion()
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        var message: String
        if sender.tag == correctAnswer {
            score += 1
            title = "Correct!"
            message = "Your score is \(score)"
        } else {
            score -= 1
            title = "Incorrect!"
            message =
                        """
                        Thats the flag of \(countries[sender.tag].uppercased()) 
                        Your score is \(score)
                        """
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 10) {
            sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
        
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        present(ac, animated: true)
    }
    
    @objc func getScore() {
        print("Score: \(score)")
        let message =   """
                        Your score is \(score)
                        Question \(currentQuestion) out of 10
                        """
        
        let ac = UIAlertController(title: "Current Score", message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Close", style: .default))
        present(ac, animated: true)
    }
}

