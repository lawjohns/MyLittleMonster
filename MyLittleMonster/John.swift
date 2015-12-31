//
//  John.swift
//  MyLittleMonster
//
//  Created by Lawrence Johnson on 12/31/15.
//  Copyright © 2015 Lawrence Johnson. All rights reserved.
//

import Foundation
import  UIKit

class JohnImg: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        playJohnIdleAnimation()
    }
    
    func playJohnIdleAnimation() {
        self.image = UIImage(named: "jidle1.png")
        
        self.animationImages = nil
        
        var imgArray = [UIImage]()
        
        for var x = 1; x <= 4; x++ {
            let img = UIImage(named: "jidle\(x)")
            imgArray.append(img!)
        }
        
        self.animationImages = imgArray
        self.animationDuration = 0.8
        self.animationRepeatCount = 0
        self.startAnimating()
    }
    
    func playJohnDeathAnimation() {
        self.image = UIImage(named: "jdead5.png")
        
        self.animationImages = nil
        
        var imgArray = [UIImage]()
        for var x = 1; x <= 5; x++ {
            let img = UIImage(named: "jdead\(x)")
            imgArray.append(img!)
        }
        
        self.animationImages = imgArray
        self.animationDuration = 0.8
        self.animationRepeatCount = 1
        self.startAnimating()
    }
}