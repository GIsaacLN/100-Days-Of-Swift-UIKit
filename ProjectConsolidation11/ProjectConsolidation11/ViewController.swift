//
//  ViewController.swift
//  ProjectConsolidation11
//
//  Created by Gustavo Isaac Lopez Nunez on 13/07/25.
//

import UIKit

class ViewController: UICollectionViewController {
    private var cards = [Card]()
    private var indexOfOnlyFaceUpCard: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        layoutGrid()
        startNewGame()
    }
    
    private func layoutGrid() {
        let spacing: CGFloat = 10
        let itemsPerRow: CGFloat = 4
        let totalSpacing = spacing * (itemsPerRow + 1)
        let itemWidth = (view.bounds.width - totalSpacing) / itemsPerRow
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = .init(top: spacing, left: spacing,
                                    bottom: spacing, right: spacing)
        layout.itemSize = .init(width: itemWidth, height: itemWidth)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        
        collectionView.setCollectionViewLayout(layout, animated: false)
    }
    
    private func startNewGame() {
        // 8 unique values
        let values = ["🐶","🐱","🐭","🐹","🐰","🦊","🐻","🐼"]
        cards = (values + values)                       // duplicate
                .map { Card(id: UUID(), value: $0) }    // wrap
                .shuffled()                             // randomize
        
        indexOfOnlyFaceUpCard = nil
        collectionView.reloadData()
    }
    
    // MARK: – Data source
    
    override func collectionView(_ cv: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    override func collectionView(_ cv: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cv.dequeueReusableCell( withReuseIdentifier: "CardCell", for: indexPath) as! CardCell
        
        cell.card = cards[indexPath.item]
        return cell
    }
    
    // MARK: – Interaction
    
    override func collectionView(_ cv: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var card = cards[indexPath.item]
        guard !card.isFaceUp, !card.isMatched else { return }
        
        let cell = cv.cellForItem(at: indexPath) as! CardCell
        cell.flip(to: true)
        card.isFaceUp = true
        cards[indexPath.item] = card
        
        if let previousIndex = indexOfOnlyFaceUpCard {
            // second card flipped
            checkForMatch(between: previousIndex, and: indexPath)
            indexOfOnlyFaceUpCard = nil
        } else {
            // first card flipped
            for i in cards.indices {
                cards[i].isFaceUp = false
            }
            card.isFaceUp = true
            cards[indexPath.item] = card
            indexOfOnlyFaceUpCard = indexPath
        }
    }
    
    private func checkForMatch(between first: IndexPath, and second: IndexPath) {
        let firstCard  = cards[first.item]
        let secondCard = cards[second.item]
        
        if firstCard.value == secondCard.value {
            // a match!
            cards[first.item].isMatched = true
            cards[second.item].isMatched = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.collectionView.reloadItems(at: [first, second])
                self.checkWin()
            }
        } else {
            // not a match – flip both back down after delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.cards[first.item].isFaceUp  = false
                self.cards[second.item].isFaceUp = false
                self.collectionView.reloadItems(at: [first, second])
            }
        }
    }
    
    private func checkWin() {
        guard cards.allSatisfy({ $0.isMatched }) else { return }
        let ac = UIAlertController(title: "You Win!", message: "Great job matching all the cards!", preferredStyle: .alert)
        ac.addAction(.init(title: "Play Again",
                           style: .default) { _ in self.startNewGame() })
        present(ac, animated: true)
    }
}
