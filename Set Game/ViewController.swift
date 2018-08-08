//
//  ViewController.swift
//  Set Game
//
//  Created by Beibei Lu on 8/5/18.
//  Copyright © 2018 Seraph Technologies. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private var cardButtons: [UIButton]!
    @IBOutlet weak var dealButton: UIButton!
    @IBOutlet weak var hintButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    
    private var game = SetGame()
    
    private(set) var score = 0 {
        didSet {
            scoreLabel.text = "Scores: \(score)"
        }
    }
    
    private var message: String = "" {
        didSet {
            messageLabel.text = message
        }
    }
    
    // MARK: - IBActions
    
    @IBAction private func deal(_ sender: UIButton) {
        touchDeal()
    }
    
    @IBAction private func showHint(_ sender: UIButton) {
        game.solve()
        showHint()
    }
    
    
    @IBAction private func touchCard(_ sender: UIButton) {
        if let index = cardButtons.index(of: sender) {
            game.chooseCard(with: index)
            updateViewFromModel()
        }
    }
    
    @IBAction private func newGame(_ sender: UIButton) {
        startNewGame()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        startNewGame()
    }
    
    // MARK: - Private methods
    
    
    
    private func startNewGame(){
        game = SetGame()
        updateViewFromModel()
    }
    
    // MARK: - ViewModel
    
    // FIXME: this is too messy
    
    private func updateViewFromModel() {
        toggleFunctionalButtons()
        updateLabels()
        drawCardButtons()
    }
    
    private func showHint() {
        if game.selectedCardsIsASet {
            touchDeal()
        }
        for (index, button) in cardButtons.enumerated() {
            if index < game.board.count {
                let card = game.board[index]
                if game.hintCards.contains(card){
                    button.layer.borderWidth = 3.0
                    button.layer.borderColor = UIColor.white.cgColor
                } else {
                    button.layer.borderWidth = 0
                }
            }
        }
    }
    
    private func touchDeal() {
        game.deal()
        updateViewFromModel()
    }
    
    private func toggleFunctionalButtons() {
        (game.deck.isEmpty || game.board.count == cardButtons.count) ? disable(button: dealButton) : enable(button: dealButton)
    }
    
    private func updateLabels() {
        
        if game.selectedCardsIsASet {
            message = "Yay~ It's a set!"
        } else if !game.solvable {
            message = "Sadly, I can't seem to find a matching set for you..."
        } else if game.deck.isEmpty {
            message = "I have dealt all the cards."
        } else {
            message = ""
        }
        
        score = game.score
        
        if game.gameEnd {
            message = game.win ? "Congradulations! You matched all 81 cards." : "Good Game, mate. Maybe you could start a new game?"
        }
        
    }
    
    private func drawCardButtons() {
        assert(cardButtons.count >= game.board.count, "ViewController.updateViewFromModel(): Buttons \(cardButtons.count) and board \(game.board.capacity) does not match.")
        
        for (index, button) in cardButtons.enumerated() {
            if index < game.board.count {
                let card = game.board[index]
                setTitle(for: card, on: button)
                drawCardButtonHighlights(card, button)
            } else {
                clearAllButtonStyles(button)
            }
        }
    }
    
    private func drawCardButtonHighlights(_ card: Card, _ button: UIButton) {
        if game.selectedCards.contains(card) {
            button.layer.borderWidth = 3.0
            if game.selectedCardsIsASet {
                button.layer.borderColor = UIColor.green.cgColor
            } else if !game.selectedCardsIsASet && game.selectedCards.count == 3 {
                button.layer.borderColor = UIColor.red.cgColor
            } else {
                button.layer.borderColor = UIColor.black.cgColor
            }
        } else {
            button.layer.borderWidth = 0
        }
    }
    
    private func clearAllButtonStyles(_ button: UIButton) {
        button.setTitle("", for: .normal)
        button.setAttributedTitle(nil, for: .normal)
        button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        button.layer.borderWidth = 0
    }
    
    private func disable(button:UIButton) {
        button.isEnabled = false
        button.isHidden = true
    }
    
    private func enable(button:UIButton) {
        button.isEnabled = true
        button.isHidden = false
    }
    
    private func setTitle(for card: Card, on button: UIButton) {
        var title: String {
            get {
                var character: String
                switch card.symbol {
                case .circle: character = "●"
                case .triangle: character =  "▲"
                case .square: character = "■"
                }
                switch card.number {
                case .one: return "\(character)"
                case .two: return "\(character)\n\(character)"
                case .three: return "\(character)\n\(character)\n\(character)"
                }
            }
        }
        
        var color: UIColor {
            get {
                switch card.color {
                case .colorA: return #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
                case .colorB: return #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
                case .colorC: return #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
                }
            }
        }
        
        var attributes = [NSAttributedStringKey:Any]()
        switch card.shading {
        case .fill:
            attributes[NSAttributedStringKey.foregroundColor] = color
        case .outline:
            attributes[NSAttributedStringKey.strokeWidth] = 5.0
            attributes[NSAttributedStringKey.strokeColor] = color
        case .stripe:
            attributes[NSAttributedStringKey.foregroundColor] = color.withAlphaComponent(0.3)
        }
        let attrString = NSAttributedString(string: title, attributes: attributes)
        button.setAttributedTitle(attrString, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.8747332692, green: 0.8113735914, blue: 0.7808287144, alpha: 1)
        
    }
}


