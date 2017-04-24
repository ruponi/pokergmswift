//
//  CardCVCell.swift
//  CardGameSwift
//
//  Created by Ruslan on 3/19/17.
//  Copyright © 2017 RAsoft. All rights reserved.
//

import UIKit

class CardCVCell: UICollectionViewCell {
    var l_top: UILabel=UILabel()
    let l_bottom:UILabel=UILabel()
    public var currentCard: Card?
    public var currentNumber:NSInteger?
    
    
   required init?(coder aDecoder: NSCoder) {
    
    super.init(coder:aDecoder)
    l_top=UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
    l_top.center=CGPoint(x:30,y:15)
    self.contentView.addSubview(l_top);
    l_bottom.frame=CGRect(x: 0, y: 0, width: 50, height: 30)
    l_bottom.center=CGPoint(x:self.frame.size.width-15,y:self.frame.size.height-15)
    l_bottom.transform=CGAffineTransform.init(rotationAngle: CGFloat((180.0*M_PI)/180.0))
    l_bottom.textAlignment=NSTextAlignment.center
    l_top.textAlignment=NSTextAlignment.center
    self.contentView.addSubview(l_bottom);
 
    
    }
    
    
    
   public func setCard(withCardNumber:NSInteger){

        let t_num:NSInteger=withCardNumber%4
        var cSuit:Suit?
        switch (t_num) {
        case 0:
            cSuit=Suit.Spades;
            break;
        case 1:
            cSuit=Suit.Clubs;
            break;
        case 2:
            cSuit=Suit.Diamonds;
            break;
        case 3:
            cSuit=Suit.Hearts;
            break;
        default:
            break;
        }
        
        //determine card value
        let cValue:NSInteger=NSInteger(floor(Double(withCardNumber/4)))+1
        currentCard=Card(suit: cSuit!, value: cValue)
        setUpView()
        
        
        
    }

    
    
    
    
    private func setUpView(){
        self.layer.borderWidth=0.1
        self.layer.borderColor=UIColor.brown.cgColor
        self.backgroundColor=UIColor.init(white: 0.8, alpha: 1.0)
        l_top.center=CGPoint(x:25,y:15)
        l_top.text=currentCard!.visibleValue
        self.addSubview(l_top);
    
        l_bottom.center=CGPoint(x:self.frame.size.width-30,y:self.frame.size.height-15)
        
        l_bottom.transform=CGAffineTransform.init(rotationAngle: CGFloat((180.0*M_PI)/180.0))
        l_bottom.text=currentCard!.visibleValue
        self.addSubview(l_bottom);
        
        if (currentCard!.suit==Suit.Diamonds||currentCard!.suit==Suit.Hearts){
            l_top.textColor=UIColor.red
            l_bottom.textColor=UIColor.red
        } else {
            l_top.textColor=UIColor.black
            l_bottom.textColor=UIColor.black
        }
        

        
    }

    
    
}
