//
//  ViewController.swift
//  BullsEye
//
//  Created by Cenker Demir on 5/24/16.
//  Copyright © 2016 Cenker Demir. All rights reserved.
//

import UIKit
//import QuartzCore

class ViewController: UIViewController {
    
    var currentValue: Int = 0
    @IBOutlet weak var slider: UISlider!
    var targetValue: Int = 0
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var roundLabel: UILabel!
    var score = 0
    var round = 0
    var targetMaxForRandomFunc = 0
    var possibleOperations: Array = ["summation", "substraction", "division", "multiplication"]
    var operationLabelDictionary = ["summation": "+", "substraction": "-", "division": "/", "multiplication": "*"]
    var operationToPerform = ""
    // outlets for max and min valiues for the sliders
    @IBOutlet weak var slider1Min: UILabel!
    @IBOutlet weak var slider1Max: UILabel!
    
    @IBOutlet weak var slider2Min: UILabel!
    @IBOutlet weak var slider2Max: UILabel!
    
    
    // second slider's current value
    var currentValue2: Int = 0
    
    // for the flatiron lab - second slider and operation label outlets
    @IBOutlet weak var operationLabel: UILabel!
    @IBOutlet weak var secondSlider: UISlider!
    
    func updateLabels() {
        targetLabel.text = String(targetValue)
        scoreLabel.text = String(score)
        roundLabel.text = String(round)
        operationLabel.text = operationLabelDictionary[operationToPerform]
    }
    
    //....let's find the target value in a function as it is more complex now with different operations
    func findTargetValue(operationForTarget:String) -> Int {
        var targetMax = 0
        var targetMin = 0
        var targetValueToReturn = 0
        
        //not using the function operation as the arguments are different in almost each case and it is unneccessary to make this harder to read and understand later 
        switch operationForTarget {
        case "summation":
            targetMax = Int(slider.maximumValue + secondSlider.maximumValue)
            targetMin = Int(slider.minimumValue + secondSlider.minimumValue)
        case "substraction":
            targetMax = Int(slider.maximumValue - secondSlider.minimumValue)
            targetMin = Int(slider.maximumValue - secondSlider.maximumValue)
        case "division":
            targetMax = Int(slider.maximumValue / secondSlider.minimumValue)
            targetMin = Int(slider.minimumValue / secondSlider.minimumValue)
        case "multiplication":
            targetMax = Int(slider.maximumValue * secondSlider.maximumValue)
            targetMin = Int(slider.minimumValue * secondSlider.minimumValue)
        default:
            return 0
        }
        targetValueToReturn = targetMin + Int(arc4random_uniform(UInt32(targetMax - targetMin + 1)))
        return targetValueToReturn
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //slider image section
        let thumbImageNormal = UIImage(named: "SliderThumb-Normal")
        slider.setThumbImage(thumbImageNormal, forState: .Normal)
        secondSlider.setThumbImage(thumbImageNormal, forState: .Normal)
        
        
        let thumbImageHighlighted = UIImage(named: "SliderThumb-Highlighted")
        slider.setThumbImage(thumbImageHighlighted, forState: .Highlighted)
        secondSlider.setThumbImage(thumbImageHighlighted, forState: .Highlighted)
        
        let insets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        
        if let trackLeftImage = UIImage(named: "SliderTrackLeft") {
            let trackLeftResizable = trackLeftImage.resizableImageWithCapInsets(insets)
            slider.setMinimumTrackImage(trackLeftResizable, forState: .Normal)
            secondSlider.setMinimumTrackImage(trackLeftResizable, forState: .Normal)
        }
        
        if let trackRightImage = UIImage(named: "SliderTrackRight") {
            let trackRightResizable = trackRightImage.resizableImageWithCapInsets(insets)
            slider.setMaximumTrackImage(trackRightResizable, forState: .Normal)
            secondSlider.setMaximumTrackImage(trackRightResizable, forState: .Normal)
        }
        
        
        //both sliders' min and max values
        slider.minimumValue = Float(1 + arc4random_uniform(50))
        slider1Min.text = String(slider.minimumValue)
        
        slider.maximumValue = Float(50 + arc4random_uniform(50))
        slider1Max.text = String(slider.maximumValue)
        
        secondSlider.minimumValue = Float(1 + arc4random_uniform(50))
        slider2Min.text = String(secondSlider.minimumValue)
        
        secondSlider.maximumValue = Float(50 + arc4random_uniform(50))
        slider2Max.text = String(secondSlider.maximumValue)
        
        //to start a round in and update the labels when the page is loaded
        startNewRound()
        updateLabels()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //operation function to choose the operation
    func operation(sliderResult1: Int, sliderResult2: Int, operationToPerform: String) -> Int {
        var operationResult = 0;
        if operationToPerform == "summation" {
            operationResult = (sliderResult1 + sliderResult2)
        }
        else if operationToPerform == "substraction" {
            operationResult = abs(sliderResult2 - sliderResult1)
        }
        else if operationToPerform == "division" {
            if sliderResult2 > sliderResult1 {
                operationResult = sliderResult2 / sliderResult1
            }
            else {
                operationResult = sliderResult1 / sliderResult2
            }
        }
        else if operationToPerform == "multiplication" {
            operationResult = sliderResult1 * sliderResult2
        }
        else {
            operationResult = 0
        }
        return operationResult
    }

    @IBAction func showAlert() {
        
        let difference: Int = abs(operation(currentValue, sliderResult2: currentValue2, operationToPerform: operationToPerform) - targetValue)
        let points = 200 - difference
        let title: String
        
        if difference == 0 {
            title = "Perfect!"
        }
        else if difference < 10 {
            title = "You almost had it!"
            if difference == 1 {
            }
        }
        else if difference < 20 {
            title = "Pretty Good!"
        }
        else {
            title = "Not even close..."
        }
        score += points
        print(currentValue,currentValue2)
        let message = "\nYou scored \(points) points!"
        let alert = UIAlertController(title: title,
            message: message,
            preferredStyle: .Alert)
        
        let action = UIAlertAction(title: "OK",
            style: .Default, handler: { action in
                                        self.startNewRound()
                                        self.updateLabels()
                                      })
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func sliderMoved(slider: UISlider) {
        currentValue = lroundf(slider.value);
    }
    
    @IBAction func secondSliderMoved(secondSlider: UISlider) {
        currentValue2 = lroundf(secondSlider.value)
    }
    
    func startNewRound() {
        round += 1
        operationToPerform = possibleOperations[Int(arc4random_uniform(4))]
        targetValue = findTargetValue(operationToPerform)
        currentValue = Int((slider.maximumValue + slider.minimumValue) / 2)
        currentValue2 = Int((secondSlider.maximumValue + secondSlider.minimumValue) / 2)
        slider.value = Float(currentValue)
        secondSlider.value = Float(currentValue2)
    }
    
    func startNewGame() {
        score = 0
        round = 0
        startNewRound()
    }
    
    @IBAction func startOver () {
        //starting over by calling these methods:
        startNewGame()
        updateLabels()
        
        // transition animation code when startOver is called
        let transition = CATransition()
        transition.type = kCATransitionFade
        transition.duration = 1
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        view.layer.addAnimation(transition, forKey: nil)
    }
    
}

