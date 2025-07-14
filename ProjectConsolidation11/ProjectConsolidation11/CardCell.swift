//
//  CardCell.swift
//  ProjectConsolidation11
//
//  Created by Gustavo Isaac Lopez Nunez on 13/07/25.
//

import UIKit

class CardCell: UICollectionViewCell {
    @IBOutlet var textLabel: UILabel!    
    @IBOutlet var backView: UIView!
    
    // expose for configuration
    var card: Card? {
        didSet { updateAppearance() }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backView.layer.cornerRadius = 8
        textLabel.isHidden = true
    }
            
    private func updateAppearance() {
        guard let card = card else { return }
        textLabel.text = card.value
        textLabel.isHidden = !card.isFaceUp
        backView.isHidden = card.isFaceUp || card.isMatched
        
        // optionally fade out matched cards
        contentView.alpha = card.isMatched ? 0.5 : 1
    }
    
    /// Animate a flip
    func flip(to faceUp: Bool, duration: TimeInterval = 0.3) {
        let fromView: UIView! = faceUp ? backView : textLabel
        let toView: UIView!   = faceUp ? textLabel : backView
        let options: UIView.AnimationOptions = faceUp
            ? .transitionFlipFromLeft
            : .transitionFlipFromRight
        
        UIView.transition(
          from: fromView,
          to:   toView,
          duration: duration,
          options: [options, .showHideTransitionViews],
          completion: nil
        )
    }
}
