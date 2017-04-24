//
//  Hand.swift
//  CardGameSwift
//
//  Created by Ruslan on 3/22/17.
//  Copyright © 2017 RAsoft. All rights reserved.
//

import UIKit

let MAXCOUNT:NSInteger=5
enum HandsErrors: Error {
    case EmptyHand
    case OtherError
}

protocol HandDelegate:NSObjectProtocol {
    func isHandChanged(hand:Hand)
}

class Hand: NSObject {
    public var c_hand:NSMutableArray = []
    public var isfullhand=false;
    
     var delegate:HandDelegate?
    //===============================
    // add card to hand
    // YES if it was added
    public func addCard(card:CardView)->Bool{
        var result=true;
        if (c_hand.count<MAXCOUNT){
            c_hand .add(card)
           let c_hand1 = c_hand.sorted(by: { ($0 as! CardView).currentNumber! < ($1 as! CardView).currentNumber! } )
            c_hand=NSMutableArray.init(array:  c_hand1);

            if (c_hand.count==MAXCOUNT){
                isfullhand=true
            } else {
                isfullhand=false
            }
        } else {
            result=false
        }
        delegate?.isHandChanged(hand: self)
        return result
    }
    //===============================
    // remove card from hand
    // YES if it was removed
    
    public func removeCard(card:CardView)->Bool{
        let result=false;
        for tcard in c_hand {
            let tmpcard:CardView=tcard as! CardView
            if (tmpcard.currentCard?.suit==card.currentCard?.suit&&tmpcard.currentCard?.value==card.currentCard?.value){
                c_hand.remove(tcard)
                isfullhand=false;
                delegate?.isHandChanged(hand: self)
                return true
            }
            
        }
        return result
    }
    
    
    
    //MARK:-
    //MARK: Poker Evaluation Algorithms
    //MARK: Determine High Card
    
    public func highCard() throws ->Card{
        if (c_hand.count>0){
        var cCard:Card=(c_hand[0] as! CardView).currentCard!
        if cCard.value==1 {
            return cCard
        } else {
          cCard=(c_hand.lastObject as! CardView).currentCard!
        }
            return cCard
        }  else {
            throw HandsErrors.EmptyHand
        }
    }
    
    //determine  Flush=================
    func isFlush()->Bool{
    var result=true
    if (isfullhand){
        var su:Suit=Suit.None
        for cv in c_hand {
            let nextSu:Suit=(cv as! CardView).currentCard!.suit;
            if (su != nextSu)&&(su != Suit.None)
                {
                result=false
                }
            su=nextSu
        }
    }
    return result;
    }
    
    //determine  Straight===============
   func isStraight()->Bool{
    var result = true
    var value:NSInteger = (-1)
    for cv in c_hand  {
        let nextValue:Value=(cv as! CardView).currentCard!.value;
        if ((value+1) != nextValue&&value != (-1)){
            result=false;
    //check if hand have Ace====
            if (value==1&&nextValue==10){
                result=true;
            }
        }
    value=nextValue;
    }
    
    return result;
    }
    
    
    //determine  FlushRoyal==================
 func isFlushRoyal()->Bool{
    var result = false
    do{
        let chighCard = try highCard()
        if (isFlush()&&isStraight()
            &&  chighCard.value==1
            && ((c_hand.lastObject) as! CardView).currentCard!.value==13){
            result=true;
        }
    } catch {
        
    }
    return result;
}

    
    //determine  FlushStraight===============
func isFlushStraight()->Bool{
    var result = false
    if(!isFlushRoyal() && isFlush() && isStraight() ){
        result = true;
    }
    return result;
    }
    
    
    //determine  FullHous==================
func isFullHous()->Bool{
   var result = false
    if  isfullhand {
      var aVL = [Value]()
      for cv in c_hand  {
        let cardv:Value = (cv as! CardView).currentCard!.value;
        aVL.append(cardv)// addObject:[NSNumber numberWithLong:cardv]];
        }
     let r1=(aVL[0] == aVL[1] && aVL[1] == aVL[2] && aVL[3] == aVL[4]);
     let r2=(aVL[0] == aVL[1] && aVL[2] == aVL[3] && aVL[3] == aVL[4]);
     result=r1||r2;
    }
    
    return result;
    
    }
    
    //determine  Three==================
func isThree()->Bool{
    var result = false
    if  isfullhand {
        var aVL = [Value]()
        for cv in c_hand  {
            let cardv:Value = (cv as! CardView).currentCard!.value;
            aVL.append(cardv)// addObject:[NSNumber numberWithLong:cardv]];
        }
        let r1=(aVL[0]==aVL[1]&&aVL[1]==aVL[2])
        let r2=(aVL[1]==aVL[2]&&aVL[2]==aVL[3])
        let r3=(aVL[2]==aVL[3]&&aVL[3]==aVL[4])
        result=(r1||r2||r3) && (!isFullHous() && !isFour());
    }
    
    return result;
    
    }
    
    //determine  four==================
func isFour()->Bool{
    var result = false
    if  isfullhand {
        var aVL = [Value]()
        for cv in c_hand  {
            let cardv:Value = (cv as! CardView).currentCard!.value;
            aVL.append(cardv)
        }
    let r1=(aVL[0]==aVL[1]&&aVL[1]==aVL[2]&&aVL[2]==aVL[3]);
    let r2=(aVL[1]==aVL[2]&&aVL[2]==aVL[3]&&aVL[3]==aVL[4]);
    result=(r1||r2);
    }
    
    return result;
    
    
    }
    
    //determine  two pair===============
func isTwoPair()->Bool{
    var result = false
    if  isfullhand {
        var aVL = [Value]()
        for cv in c_hand  {
            let cardv:Value = (cv as! CardView).currentCard!.value;
            aVL.append(cardv)
        }
    let r1=(aVL[0] == aVL[1] && aVL[2] == aVL[3]);
    let r2=(aVL[0] == aVL[1] && aVL[3] == aVL[4]);
    let r3=(aVL[1] == aVL[2] && aVL[3] == aVL[4]);
    result=(r1||r2||r3) && (!isFullHous() && !isFour() && !isThree());
    }
    
    return result;
    }
    
func isPair()->Bool{
    var result = false
    if  isfullhand {
        var aVL = [Value]()
        for cv in c_hand  {
            let cardv:Value = (cv as! CardView).currentCard!.value;
            aVL.append(cardv)
        }
    let r1=(aVL[0] == aVL[1]);
    let r2=(aVL[1] == aVL[2]);
    let r3=(aVL[2] == aVL[3]);
    let r4=(aVL[3] == aVL[4]);
    result=(r1||r2||r3||r4)&&(!isFullHous() && !isFour() && !isThree() && !isFour() && !isTwoPair());
    }
    
    return result;
    }

    
    func getHandResult()->String{
        var result:String=""
        var highCardg:Card?
        do{
             highCardg = try highCard()
        } catch{
            
        }
        
      
        
        if (isFlush()){
            result="Royal Flush"
        } else
            if (isFlushStraight()){
                result="Straight Flush"
            } else
                if (isFour())  {
                    result="Four of a kind"
                } else
                    if (isFullHous())  {
                        result="Full House"
                    } else
                        if (isFlush())  {
                            result="Flush"
                        } else
                            if (isStraight())  {
                                result="Straight"
                            } else
                                if (isThree())  {
                                    result="Three of a Kind"
                                } else
                                    if (isTwoPair())  {
                                        result="Two Pair"
                                    } else
                                        if (isPair())  {
                                            result="One Pair"
                                        } else {
                                            result=String(format:"High Card %@",highCardg!.visibleValue)
                                            
        }
        
        
        
        
        
        return result;
        
  
        
    }
    
    
}

