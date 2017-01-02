//
//  DeckOfCards.swift
//  CloudRook
//
//  Created by Brad Caldwell on 1/2/17.
//  Copyright © 2017 Caldwell Contracting LLC. All rights reserved.
//

import Foundation
class DeckOfCards {
    
    //Has 57 cards
    
    
    
    func createDeck() -> [Card] {
        var myCardDeck = [Card]()
        for x in 1...14 {
            for y in 1...4 {
                var newCard = Card(numbeR: x, coloR: y)
                myCardDeck.append(newCard)
            }
        }
        var newCard = Card(numbeR: 15, coloR: 5)
        myCardDeck.append(newCard)
        return myCardDeck
    }
    
    func shuffleDeck( deck: [Card]) -> [Card] {
        
        var deck = deck
        return deck
    }
    
}

class Card: DeckOfCards {
    var cardNumber: Int
    var cardColor: Int
    
    init (numbeR: Int, coloR: Int){
        var numbeR = numbeR
        self.cardNumber = numbeR
        self.cardColor = coloR
    }
    
}
