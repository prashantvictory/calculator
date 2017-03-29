//
//  ViewController.swift
//  calculator
//
//  Created by Prashant Air on 28/03/17.
//  Copyright © 2017 prashantvictory. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var btnPushSound: AVAudioPlayer!
    @IBOutlet weak var outputLabel: UILabel!
    
    var runningNumber = ""
    
    enum Operation: String {
        case Divide = "/"
        case Multiply = "*"
        case Subtract = "-"
        case Add = "+"
        case Empty = "Empty"
    }
    
    var currentOperation = Operation.Empty
    var rightValue = ""
    var leftValue = ""
    var operationResult = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let path = Bundle.main.path(forResource: "button-push", ofType: "wav")
        let soundURL = URL(fileURLWithPath: path!)
        
        do {
            try btnPushSound = AVAudioPlayer(contentsOf: soundURL)
            btnPushSound.prepareToPlay()
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func numberPressed(sender: UIButton) {
        playPushSound()
        
        runningNumber += "\(sender.titleLabel?.text ?? "0")"
        outputLabel.text = runningNumber
    }
    
    func playPushSound() {
        if btnPushSound.isPlaying {
            btnPushSound.stop()
        }
        
        btnPushSound.play()
    }
    
    func processOperation(operation: Operation) {
        playPushSound()
        if currentOperation != Operation.Empty {
            if runningNumber != "" {
                rightValue = runningNumber
                runningNumber = ""
                
                if currentOperation == Operation.Divide {
                    operationResult = "\(Double(leftValue)! / Double(rightValue)!)";
                } else if currentOperation == Operation.Multiply {
                    operationResult = "\(Double(leftValue)! * Double(rightValue)!)";
                } else if currentOperation == Operation.Subtract {
                    operationResult = "\(Double(leftValue)! - Double(rightValue)!)";
                } else if currentOperation == Operation.Add {
                    operationResult = "\(Double(leftValue)! + Double(rightValue)!)";
                }
                
                leftValue = operationResult
                
                if floor(Double(operationResult)!) == Double(operationResult) {
                    operationResult = "\(Int(Double(operationResult)!))"
                }
                
                outputLabel.text = operationResult
            }
            
            currentOperation = operation
        } else {
            leftValue = runningNumber
            runningNumber = ""
            currentOperation = operation
        }
    }

    @IBAction func onDividePressed(sender: AnyObject) {
        processOperation(operation: .Divide)
    }
    
    @IBAction func onMultiplyPressed(sender: AnyObject) {
        processOperation(operation: .Multiply)
    }
    
    @IBAction func onSubtractPressed(sender: AnyObject) {
        processOperation(operation: .Subtract)
    }
    
    @IBAction func onAddPressed(sender: AnyObject) {
        processOperation(operation: .Add)
    }
    
    @IBAction func onEqualPressed(sender: AnyObject) {
        processOperation(operation: currentOperation)
    }
    
    @IBAction func onClearPressed(_ sender: Any) {
        outputLabel.text = "0"
        runningNumber = ""
        currentOperation = Operation.Empty
    }
    
}

