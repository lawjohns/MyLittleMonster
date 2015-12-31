//
//  ViewController.swift
//  MyLittleMoster
//
//  Created by Lawrence Johnson on 12/30/15.
//  Copyright © 2015 Lawrence Johnson. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    // Always on screen
    @IBOutlet weak var monsterImg: MonsterImg!
    @IBOutlet weak var johnImg: MonsterImg!
    @IBOutlet weak var rockyBg: UIImageView!
    @IBOutlet weak var johnBg: UIImageView!
    
    // Start Screen UI
    @IBOutlet weak var upBtn: UIButton!
    @IBOutlet weak var downBtn: UIButton!
    @IBOutlet weak var charName: UILabel!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var logo: UIImageView!
    
    // In-game UI
    @IBOutlet weak var care: UIStackView!
    @IBOutlet weak var livesPanel: UIImageView!
    @IBOutlet weak var foodImg: DragImg!
    @IBOutlet weak var heartImg: DragImg!
    @IBOutlet weak var penalty1: UIImageView!
    @IBOutlet weak var penalty2: UIImageView!
    @IBOutlet weak var penalty3: UIImageView!
    @IBOutlet weak var skulls: UIStackView!
    
    // Death UI
    @IBOutlet weak var deadMsg: UILabel!
    @IBOutlet weak var reviveBtn: UIButton!
    
    var curCreature: Int = 0
    var numOfCreatures = 2
    
    let DIM_ALPHA: CGFloat = 0.2
    let OPAQUE: CGFloat = 1.0
    let MAX_PENALTIES = 3
    
    var curPenalties = 0
    var timer: NSTimer!
    
    var monsterHappy = false
    var curItem: UInt32 = 0
    
    var musicPlayer: AVAudioPlayer!
    var sfxBite: AVAudioPlayer!
    var sfxHeart: AVAudioPlayer!
    var sfxDead: AVAudioPlayer!
    var sfxSkull: AVAudioPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            try musicPlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("cave-music", ofType: "mp3")!))
            
            try sfxBite = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bite", ofType: "wav")!))
            
            try sfxHeart = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("heart", ofType: "wav")!))
            
            try sfxDead = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("death", ofType: "wav")!))
            
            try sfxSkull = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("skull", ofType: "wav")!))
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        musicPlayer.prepareToPlay()
        sfxBite.prepareToPlay()
        sfxHeart.prepareToPlay()
        sfxDead.prepareToPlay()
        sfxSkull.prepareToPlay()
        
        loadCreature()
        
        startScreen()
    }
    
    @IBAction func reviveMonster(sender: AnyObject) {
        startScreen()
    }
    
    func startScreen() {
        care.hidden = true
        livesPanel.hidden = true
        deadMsg.hidden = true
        reviveBtn.hidden = true
        skulls.hidden = true
        
        startBtn.hidden = false
        upBtn.hidden = false
        downBtn.hidden = false
        charName.hidden = false
        logo.hidden = false
        
        loadCreature()
    }
    @IBAction func onUpBtnPress(sender: AnyObject) {
        curCreature++
        if curCreature >= numOfCreatures {
            curCreature = 0
        }
        loadCreature()
    }
    @IBAction func onDownBtnPress(sender: AnyObject) {
        curCreature--
        if curCreature < 0 {
            curCreature = numOfCreatures - 1
        }
        loadCreature()
    }
    @IBAction func onStartBtnPress(sender: AnyObject) {
        revive()
    }
    
    func loadCreature() {
        if curCreature == 0 {
            monsterImg.hidden = false
            rockyBg.hidden = false
            
            johnImg.hidden = true
            johnBg.hidden = true
            
            charName.text = "Rocky"
            
            monsterImg.playIdleAnimation()
        } else if curCreature == 1 {
            monsterImg.hidden = true
            rockyBg.hidden = true
            
            johnImg.hidden = false
            johnBg.hidden = false
            
            charName.text = "John"
            
            johnImg.playJohnIdleAnimation()
        } else {
            monsterImg.hidden = false
            rockyBg.hidden = false
            
            johnImg.hidden = true
            johnBg.hidden = true
            
            charName.text = "Rocky"
        }
    }
    
    func revive() {
        if curCreature == 0 {
            foodImg.dropTarget = monsterImg
            heartImg.dropTarget = monsterImg
        } else if curCreature == 1 {
            foodImg.dropTarget = johnImg
            heartImg.dropTarget = johnImg
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "itemDroppedOnCharacter:", name: "onTargetDropped", object: nil)
        
        curPenalties = 0
        
        care.hidden = false
        livesPanel.hidden = false
        deadMsg.hidden = true
        reviveBtn.hidden = true
        skulls.hidden = false
        
        startBtn.hidden = true
        upBtn.hidden = true
        downBtn.hidden = true
        charName.hidden = true
        logo.hidden = true
        
        penalty1.alpha = DIM_ALPHA
        penalty2.alpha = DIM_ALPHA
        penalty3.alpha = DIM_ALPHA
        
        musicPlayer.play()
        
        loadCreature()
        
        startTimer()
    }
    
    func itemDroppedOnCharacter(notif: AnyObject) {
        if curItem == 0 {
            sfxHeart.play()
        } else {
            sfxBite.play()
        }
        
        monsterHappy = true
        startTimer()
        
        foodImg.alpha = DIM_ALPHA
        foodImg.userInteractionEnabled = false
        
        heartImg.alpha = DIM_ALPHA
        heartImg.userInteractionEnabled = false
    }
    
    func startTimer() {
        if timer != nil {
            timer.invalidate()
        }
        
        timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "changeGameState", userInfo: nil, repeats: true)
    }
    
    func changeGameState() {
        if !monsterHappy {
            curPenalties++
            
            sfxSkull.play()
            
            if curPenalties == 1 {
                penalty1.alpha = OPAQUE
                penalty2.alpha = DIM_ALPHA
                penalty3.alpha = DIM_ALPHA
            } else if curPenalties == 2 {
                penalty1.alpha = OPAQUE
                penalty2.alpha = OPAQUE
                penalty3.alpha = DIM_ALPHA
            } else if curPenalties >= 3 {
                penalty1.alpha = OPAQUE
                penalty2.alpha = OPAQUE
                penalty3.alpha = OPAQUE
            } else {
                penalty1.alpha = DIM_ALPHA
                penalty2.alpha = DIM_ALPHA
                penalty3.alpha = DIM_ALPHA
            }
            
            if curPenalties >= MAX_PENALTIES {
                gameOver()
            }
        }
        
        let rand = arc4random_uniform(2)
        if rand == 0 {
            heartImg.alpha = OPAQUE
            heartImg.userInteractionEnabled = true
            
            foodImg.alpha = DIM_ALPHA
            foodImg.userInteractionEnabled = false
        } else {
            heartImg.alpha = DIM_ALPHA
            heartImg.userInteractionEnabled = false
            
            foodImg.alpha = OPAQUE
            foodImg.userInteractionEnabled = true
        }
        
        curItem = rand
        monsterHappy = false
    }
    
    func gameOver() {
        timer.invalidate()
        
        musicPlayer.stop()
        sfxDead.play()
        
        if curCreature == 0 {
            monsterImg.playDeathAnimation()
        } else if curCreature == 1 {
            johnImg.playJohnDeathAnimation()
        }
        
        deadMsg.hidden = false
        reviveBtn.hidden = false
    }
}

