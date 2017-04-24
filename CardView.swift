//
//  CardView.swift
//  CardGameSwift
//
//  Created by Ruslan on 3/13/17.
//  Copyright © 2017 RAsoft. All rights reserved.
//

import UIKit

//
//  CardView.h
//  CardGame
//
//  Created by Ruslan on 8/21/15.
//  Copyright (c) 2015 Rsoft. All rights reserved.
//
/*
 ==========================================
 suits of the cards
 1 varlubs
 2 - Diamonds
 3 - Hearts
 4 - Spades
 --------------
 value of the card
 2..10- Numbers
 1  - Ace
 11 - Jack
 12 - Quine
 13 - King
 =============================================
 
 init with number
 "Ace" 0 1 2 3   "2" 4 5 6 7  "3" 8 9 10 11 ...
 -----------------------------------------------
 
 the class have two methods fo initialization
 1. number card on the deck
 - (CardView*) initWithNumber:(NSInteger) number
 2. init with card (suits/number)
 - (CardView*) initWithCard:(struct Card) card
 
 */






class CardView: UIView {
    var l_top: UILabel=UILabel()
    let l_bottom:UILabel=UILabel()
    public var currentCard:Card?
    public var currentNumber:NSInteger?
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    // MARK: Init Methods
   
    
    override init(frame: CGRect) {
        self.l_top=UILabel()
        
        super.init(frame: frame)
      
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(withCardNumber:NSInteger){
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        currentNumber=withCardNumber
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
    
    init(withCard:Card){
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        
        currentCard=withCard
        let cardNumber=((currentCard?.value)!-1)*4+(currentCard?.suit.hashValue)!
        currentNumber=cardNumber
        setUpView()
    }
    
    private func setUpView(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let v_width:CGFloat=(appDelegate.window?.frame.width)!
        self.frame=CGRect(x: 0, y: 0, width: v_width/5-10, height: 100)
        self.layer.borderWidth=0.5
        self.layer.borderColor=UIColor.red.cgColor
        self.backgroundColor=UIColor.init(white: 0.8, alpha: 1.0)
        let cd=Card(suit:Suit.Clubs, value: 12)
        self.l_top=UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        l_top.text=currentCard!.visibleValue
        self.addSubview(l_top);
        //=====================================================
        //Create constrains====================================
         self.translatesAutoresizingMaskIntoConstraints=false
         l_top.translatesAutoresizingMaskIntoConstraints=false
        let views = ["l_top": l_top,
                     "l_bottom": l_bottom,
                     "sv":self]
        let widthConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[sv(100)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
        let s_constr=String(format: "H:[sv(%f)]", v_width/5-10)
        let heightConstraints = NSLayoutConstraint.constraints(withVisualFormat: s_constr, options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
        
      
        NSLayoutConstraint.activate(widthConstraints)
        NSLayoutConstraint.activate(heightConstraints)
        
        var allConstraints = [NSLayoutConstraint]()
        
        let iconVerticalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-5-[l_top(30)]",
            options: [],
            metrics: nil,
            views: views)
        allConstraints += iconVerticalConstraints
        
        let iconVerticalConstraints1 = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-5-[l_top(30)]",
            options: [],
            metrics: nil,
            views: views)
        allConstraints += iconVerticalConstraints1
        
        NSLayoutConstraint.activate(allConstraints)
       
        self.layoutIfNeeded()
        self.updateConstraints()
        //===============================================================
        l_bottom.frame=CGRect(x: 0, y: 0, width: 30, height: 21)
        l_bottom.center=CGPoint(x:self.frame.size.width-20,y:self.frame.size.height-15)
        l_bottom.transform=CGAffineTransform.init(rotationAngle: CGFloat((180.0*M_PI)/180.0))
        l_bottom.text=currentCard!.visibleValue
        self.addSubview(l_bottom);
        if (cd.suit==Suit.Diamonds){
            print( cd.suit.rawValue)
        }
        if (currentCard!.suit==Suit.Diamonds||currentCard!.suit==Suit.Hearts){
            l_top.textColor=UIColor.red
            l_bottom.textColor=UIColor.red
        } else {
            l_top.textColor=UIColor.black
            l_bottom.textColor=UIColor.black
        }
       
        
        
        print("The width of someResolution is \(cd)")
        //self.backgroundColor=UIColor.yellow
        
    }
    
}
