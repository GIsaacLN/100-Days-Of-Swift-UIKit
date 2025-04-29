//
//  ViewController.swift
//  ProjectConsolidation4
//
//  Created by Gustavo Isaac Lopez Nunez on 28/04/25.
//

import UIKit

class ViewController: UIViewController {
    var mistakesLabel: UILabel!
    var levelLabel: UILabel!
    var currentAnswer: UITextField!
    var letterButtons = [UIButton]()
    var activatedLetterButtons = [UIButton]()
    var allWords = [String]()
    
    var currentWord: String = ""
    var level = 1 {
        didSet {
            levelLabel.text = "Level: \(level)"
        }
    }
    var currentMistakes = 0 {
        didSet {
            mistakesLabel.text = "You have made \(currentMistakes) attempts. You have attempts \(7 - currentMistakes) left"
        }
    }
    let allLetters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]

    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        levelLabel = UILabel()
        levelLabel.translatesAutoresizingMaskIntoConstraints = false
        levelLabel.textAlignment = .center
        levelLabel.text = "Level: \(level)"
        view.addSubview(levelLabel)

        mistakesLabel = UILabel()
        mistakesLabel.translatesAutoresizingMaskIntoConstraints = false
        mistakesLabel.textAlignment = .center
        mistakesLabel.text = "You have made \(currentMistakes) attempts. You have attempts \(7 - currentMistakes) left"
        mistakesLabel.font = UIFont.systemFont(ofSize: 34)
        view.addSubview(mistakesLabel)
        
        let hintLabel = UILabel()
        hintLabel.translatesAutoresizingMaskIntoConstraints = false
        hintLabel.textAlignment = .center
        hintLabel.text = "Tap on any letter!"
        hintLabel.font = UIFont.systemFont(ofSize: 40)
        view.addSubview(hintLabel)
        
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.text = "_ _ _ _ _ _ _"
        currentAnswer.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 80)
        currentAnswer.isUserInteractionEnabled = false
        view.addSubview(currentAnswer)
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        NSLayoutConstraint.activate([
            levelLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            levelLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            mistakesLabel.topAnchor.constraint(equalTo: levelLabel.bottomAnchor),
            mistakesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            hintLabel.topAnchor.constraint(equalTo: mistakesLabel.bottomAnchor, constant: 20),
            hintLabel.centerXAnchor.constraint(equalTo: mistakesLabel.centerXAnchor),
            
            currentAnswer.topAnchor.constraint(equalTo: hintLabel.bottomAnchor),
            currentAnswer.centerXAnchor.constraint(equalTo: hintLabel.centerXAnchor),
            
            buttonsView.widthAnchor.constraint(equalToConstant: 900),
            buttonsView.heightAnchor.constraint(equalToConstant: 400),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor, constant: 20),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
        ])
        
        let width = 150
        let height = 80
        let totalCols = 6
        let totalRows = 5
        for row in 0..<totalRows {
            for col in 0..<totalCols {
                let letterIndex = (totalCols * row) + (col)
                if letterIndex < allLetters.count {
                    let letterButton = UIButton(type: .system)
                    letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                    let currentLetter = allLetters[letterIndex]
                    letterButton.setTitle(currentLetter, for: .normal)
                    
                    let frame = CGRect(x: col * width, y: row * height, width: width, height: height)
                    letterButton.frame = frame
                    
                    buttonsView.addSubview(letterButton)
                    
                    letterButtons.append(letterButton)
                    letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                }
            }
        }
    }
    
    func levelUp(action: UIAlertAction) {
        level += 1
        startGame()
    }
    
    func restart(action: UIAlertAction) {
        level = 1
        startGame()
    }
    
    func startGame() {
        for button in activatedLetterButtons {
            button.isHidden = false
        }

        currentWord = allWords.randomElement() ?? "apple"
        var answerString = ""

        for _ in currentWord {
            answerString += "_ "
        }
        
        DispatchQueue.main.async {
            self.currentMistakes = 0

            self.currentAnswer.text = answerString.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        print(currentWord)
    }
    
    @objc func letterTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else { return }

        activatedLetterButtons.append(sender)
        sender.isHidden = true
        let answer = currentWord.lowercased()
        if answer.contains(buttonTitle.lowercased()) {
            let currentText = currentAnswer.text
            var curLetters = currentText?.components(separatedBy: " ")
            
            for (index, letter) in currentWord.enumerated() {
                if String(letter) == buttonTitle.lowercased() {
                    curLetters?[index] = String(letter)
                }
            }
            
            currentAnswer.text = curLetters?.joined(separator: " ")
            
            if curLetters?.joined(separator: "") == currentWord {
                let ac = UIAlertController(title: "You have found the word", message: "Wanna play again?", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Let's play!", style: .default, handler: levelUp))
                present(ac, animated: true)
            }
        } else {
            currentMistakes += 1
            
            if currentMistakes >= 7 {
                let ac = UIAlertController(title: "You have lost", message: "Wanna play again from start?", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Let's go", style: .default, handler: restart))
                present(ac, animated: true)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.global().async {
            if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
                if let startWords = try? String(contentsOf: startWordsURL, encoding: .utf8) {
                    self.allWords = startWords.components(separatedBy: "\n")
                }
            }
            
            if self.allWords.isEmpty {
                self.allWords = ["apple", "banana", "cherry"]
            }
            
            self.startGame()
        }
    }


}

