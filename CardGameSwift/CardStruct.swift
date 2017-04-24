//
//  CardStruct.swift
//  CardGameSwift
//
//  Created by Ruslan on 3/14/17.
//  Copyright © 2017 RAsoft. All rights reserved.
//

import Foundation

enum Suit:String{
    case None=""
    case Clubs="♣︎"
    case Diamonds="♦︎"
    case Hearts="♥︎"
    case Spades="♠︎"
}

typealias  Value=NSInteger

struct Card {
    var  suit:Suit
    var value:Value
    var visibleValue:String{
        var s_cardV=""
        switch value  {
        case 1:
            s_cardV="A"
            break
        case 11:
            s_cardV="J"
            break
        case 12:
            s_cardV="Q"
            break
        case 13:
            s_cardV="K"
            break
        default:
            s_cardV="\(value)"
        }
        return String(format:"%@%@", s_cardV,suit.rawValue)
    }
}

