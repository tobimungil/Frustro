//
//  ViewController.swift
//  FrustrationEmotion
//
//  Created by Mirza Fachreza 2 on 16/05/19.
//  Copyright © 2019 Mirza Fachreza. All rights reserved.
//

import UIKit
import AVFoundation
import SAConfettiView

class ViewController: UIViewController, AVAudioPlayerDelegate {

    @IBOutlet weak var rightButton: UIButton!
    
    @IBOutlet var falseButtons: [UIButton]!
    
    @IBOutlet weak var initButton: UIButton!
    
    @IBOutlet weak var replayButton: UIButton!
    
    
    
    var audioPlayer =  AVAudioPlayer()
    
    var timer = Timer()
    var duration = 10
    
    var currentIndex = 0
    
    var red: Float = 1.0, green: Float = 0
    var circleAlpha = 1.0
    
    var initial = 0
    
    let confettiFail = SAConfettiView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        confettiFail.frame = self.view.bounds
        
        
        
//        view.addSubview(confettiViewFail)
//        confettiViewFail.startConfetti()
        
        //Initial BG Color
        self.view.backgroundColor = UIColor(red: CGFloat(red), green: CGFloat(green), blue: 0.0, alpha: 1.0)
        
        //Bentuk Lingkaran Button
        rightButton.layer.cornerRadius = 0.5 * rightButton.bounds.size.width
        rightButton.alpha = CGFloat(circleAlpha)
        
        initButton.alpha = CGFloat(circleAlpha)
        
        rightButton.isHidden = true
        
        for falseButton in falseButtons{
            falseButton.isHidden = true
        }
        
        replayButton.alpha = 0
        
        
    }

    
    
    @IBAction func resetBtnPressed(_ sender: UIButton) {
        
        initial = 0
        
        UIView.animate(withDuration: 1.0) {
            self.initButton.alpha = 1
            self.replayButton.alpha = 0
        }
        
        setToDefault()
        confettiFail.stopConfetti()
        
        view.sendSubviewToBack(replayButton)
        view.sendSubviewToBack(confettiFail)
        
    }
    
    @IBAction func initBtnPressed(_ sender: UIButton) {
        
        if initial < 1 {
            activateTimer()
            print(duration)
            moveInitButton()
            
            
            initial += 1
        }

        else if initial >= 1{
            
            rightButton.isHidden = false
            initButton.alpha = 0
            
            moveRightButton()
        
        }
        
        
    }
    
    
    
    @IBAction func rightBtnPressed(_ sender: UIButton) {
        
        
        
        moveRightButton()
        addFalseButton()
        moveFalseButton()
        
        if currentIndex == 9{
            congratulationsAlert()
        }
        
        
       
    }
    
    @IBAction func falseBtnPressed(_ sender: UIButton) {
        gameOver()
    }
    
    
    
    
    
    
    //===================================================================================//
    
    
    
    
    
    
    
    func congratulationsAlert(){
        print("Congrats")
        
        rightButton.alpha = 0
        for falsebutton in falseButtons{
            falsebutton.alpha = 0
        }
        
        self.timer.invalidate()
        
        let congratsAlert = UIAlertController(title: "Congratulations", message: "", preferredStyle: .alert)
        
        congratsAlert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: {_ in
            self.setToDefault()
        }))
        
        self.present(congratsAlert, animated: true, completion: nil)
        
        do{
            if let fileURL = Bundle.main.path(forResource: "Cheers", ofType: "wav"){
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: fileURL))
            } else{
                print("Nil")
            }
        } catch _{
            print("Nil")
        }
        
        audioPlayer.play()
    }
    
    func activateTimer(){
        timer = Timer.scheduledTimer(timeInterval: 20, target: self, selector: #selector(gameOver), userInfo: nil, repeats: false)
        
        do{
            if let fileURL = Bundle.main.path(forResource: "Ticking", ofType: "wav"){
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: fileURL))
            } else{
                print("Nil")
            }
        } catch _{
            print("Nil")
        }
        
        audioPlayer.play()
    }
    
    @objc func gameOver(){
        showFailedAlert()
    }
    
    func showFailedAlert(){
        
        self.timer.invalidate()
        
        
        self.view.addSubview(confettiFail)
        
            confettiFail.type = .Image(UIImage(named: "angryface")!)
        
            confettiFail.colors = [UIColor.white]
        
            confettiFail.startConfetti()
        
        
        do{
            if let fileURL = Bundle.main.path(forResource: "Boo", ofType: "wav"){
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: fileURL))
            } else{
                print("Nil")
            }
        } catch _{
            print("Nil")
        }
        
        audioPlayer.play()
        
        UIView.animate(withDuration: 1.0) {
            self.rightButton.alpha = 0
            for falsebutton in self.falseButtons{
            falsebutton.alpha = 0
            
        }
           self.initButton.alpha = 0
           self.replayButton.alpha = 1
        
        }
        self.view.addSubview(self.replayButton)
        
        
    }
    
    func setToDefault(){
        red = 1.0
        green = 0.0
        
        circleAlpha = 1.0
        
        currentIndex = 0
        
        UIView.animate(withDuration: 2.0) {
            self.view.backgroundColor = UIColor(red: CGFloat(self.red), green: CGFloat(self.green), blue: 0.0, alpha: 1.0)
            
        }
        
        initButton.isHidden = false
        
        
        rightButton.alpha = CGFloat(circleAlpha)
        rightButton.frame = CGRect(x: 175, y: 670, width: 64, height: 64)
        
        initButton.frame = CGRect(x: 150, y: 670, width: 114, height: 108)
        
        for falseButton in falseButtons{
            UIView.animate(withDuration: 1.0) {
            falseButton.isHidden = true
                falseButton.alpha = CGFloat(self.circleAlpha)
            }
        }
    }
    
    func moveRightButton(){
        red -= 0.1
        green += 0.1
        
        circleAlpha -= 0.04
        
        let buttonWidth = rightButton.frame.width
        let buttonHeight = rightButton.frame.height
        let viewWidth = rightButton.superview!.bounds.width
        let viewHeight = rightButton.superview!.bounds.height
        let xwidth = viewWidth - buttonWidth
        let yheight = viewHeight - buttonHeight
        let xoffset = CGFloat(arc4random_uniform(UInt32(xwidth)))
        let yoffset = CGFloat(arc4random_uniform(UInt32(yheight)))
        rightButton.center.x = xoffset + buttonWidth / 2
        rightButton.center.y = yoffset + buttonHeight / 2
        
        
        
        UIView.animate(withDuration: 1.0) {
            self.view.backgroundColor = UIColor(red: CGFloat(self.red), green: CGFloat(self.green), blue: 0.0, alpha: 1.0)
            
            self.rightButton.alpha = CGFloat(self.circleAlpha)
            
        }
    }
    
    func moveFalseButton(){
        for falseButton in falseButtons{
            falseButton.alpha = CGFloat(circleAlpha)
            
            
            
            let buttonWidths = falseButton.frame.width
            let buttonHeights = falseButton.frame.height
            let viewWidths = falseButton.superview!.bounds.width
            let viewHeights = falseButton.superview!.bounds.height
            let xwidths = viewWidths - buttonWidths
            let yheights = viewHeights - buttonHeights
            let xoffsets = CGFloat(arc4random_uniform(UInt32(xwidths)))
            let yoffsets = CGFloat(arc4random_uniform(UInt32(yheights)))
            falseButton.center.x = xoffsets + buttonWidths / 2
            falseButton.center.y = yoffsets + buttonHeights / 2
        }
    }
    
    func addFalseButton(){
        if currentIndex < falseButtons.count{
            falseButtons[currentIndex].isHidden = false
            currentIndex += 1
        }
    }
    
    func moveInitButton(){
        red -= 0.1
        green += 0.1
        
        circleAlpha -= 0.07
        
        let buttonWidth = initButton.frame.width
        let buttonHeight = initButton.frame.height
        let viewWidth = initButton.superview!.bounds.width
        let viewHeight = initButton.superview!.bounds.height
        let xwidth = viewWidth - buttonWidth
        let yheight = viewHeight - buttonHeight
        let xoffset = CGFloat(arc4random_uniform(UInt32(xwidth)))
        let yoffset = CGFloat(arc4random_uniform(UInt32(yheight)))
        initButton.center.x = xoffset + buttonWidth / 2
        initButton.center.y = yoffset + buttonHeight / 2
        
        
        
        UIView.animate(withDuration: 1.0) {
            self.view.backgroundColor = UIColor(red: CGFloat(self.red), green: CGFloat(self.green), blue: 0.0, alpha: 1.0)
            
            self.initButton.alpha = CGFloat(self.circleAlpha)
            
        }
    }
}

