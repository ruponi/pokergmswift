//
//  ViewController.swift
//  CardGameSwift
//
//  Created by Ruslan on 3/13/17.
//  Copyright © 2017 RAsoft. All rights reserved.
//

import UIKit

struct Address {
    var fullAddress: String
    var city: String
    
    init(fullAddress: String, city: String) {
        self.fullAddress = fullAddress
        self.city = city
    }
}

class Person {
    var name: String
    var address: Address
    
    init(name: String, address: Address) {
        self.name = name
        self.address = address
    }
}





class ViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,HandDelegate {
    let reuseIdentifier = "cell"
    var selectedPath:NSMutableArray=NSMutableArray()
    var hand:Hand=Hand()
    
    @IBOutlet weak var cv_cards: UICollectionView!
    @IBOutlet weak var v_result: UIView!
    @IBOutlet weak var v_place: UIView!
    @IBOutlet weak var l_result: UILabel!
    
    
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
       
      
        
        hand.delegate=self
        let cd1=CardView(withCardNumber: 47);
        cd1.center=CGPoint(x:100,y:300)
       self.v_result.isHidden=true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: colectionView delegate
    
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! CardCVCell
     
        cell.setCard(withCardNumber: indexPath.item)
         if(selectedPath.contains(indexPath)){
            cell.layer.borderColor=UIColor.green.cgColor
            cell.layer.borderWidth=4.0
         } else {
            cell.layer.borderColor=UIColor.clear.cgColor
            cell.layer.borderWidth=0.0
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let v_width:CGFloat=(appDelegate.window?.frame.width)!
        let cwidh=v_width/4-10
        let size=CGSize.init(width: cwidh, height: 150)
        return size
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var tmparr=NSArray.init(array: selectedPath)
        print(indexPath)
        var ishanged=false
        if(selectedPath.contains(indexPath)){
            selectedPath.remove(indexPath)
            let tmpCV:CardView=CardView.init(withCardNumber: indexPath.row)
           
             ishanged = hand.removeCard(card: tmpCV)
            
        } else {
            if (selectedPath.count<5){
                selectedPath.add(indexPath)
                tmparr=NSArray.init(array: selectedPath)
                let tmpCV:CardView=CardView.init(withCardNumber: indexPath.row)
                ishanged = hand.addCard(card: tmpCV)
            }
        }
        if (ishanged){
            cv_cards.reloadItems(at: tmparr as! [IndexPath])
            reloadPlaceView()
        }
    }
    
    func reloadPlaceView(){
        for view in v_place.subviews {
            if (view is CardView){
            view.removeFromSuperview()
            }
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let v_width:CGFloat=(appDelegate.window?.frame.width)!
        var i=0
        var dvView=Dictionary<String, Any>()
        var s_constr="H:|"
        var A_V_Constrains:[NSLayoutConstraint] = []
        for cv:CardView in hand.c_hand as! [CardView] {
            let space=(v_width-(cv.bounds.width*5))/6
            dvView[String (format:"v%d",i)] = cv
            v_place.addSubview(cv);
            s_constr = s_constr+String(format: "-%f-[v%d]", space,i)
            let vertical = NSLayoutConstraint.constraints(
                            withVisualFormat: String(format: "V:|-20-[v%d]",i),
                            options: NSLayoutFormatOptions(rawValue: 0),
                            metrics: nil,
                            views: [String(format: "v%d",i):cv])
            
             A_V_Constrains+=vertical
             i += 1
            
        }
        if i>0 {
        let heightConstraints = NSLayoutConstraint.constraints(withVisualFormat: s_constr, options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dvView)
        NSLayoutConstraint.activate(heightConstraints)
            NSLayoutConstraint.activate(A_V_Constrains)

        }
        
        
    }
   
    
    //MARK: Hand delegate when changed
    func isHandChanged(hand: Hand) {
        
        DispatchQueue.main.async {
            if (hand.isfullhand){
                self.v_result.isHidden=false
                self.v_place.bringSubview(toFront: self.v_result)
                self.l_result.text=hand.getHandResult()
            } else {
                 self.v_result.isHidden=true
            }
        }
 
    }
    
    
    

    
    
    
}


