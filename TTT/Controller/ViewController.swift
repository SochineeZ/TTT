//
//  ViewController.swift
//  TTT
//
//  Created by cate on 1/22/19.
//  Copyright © 2019 Sean Zhan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var settingsScreen: UIButton!
    
    var game = Game()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let recevierVC = segue.destination as! ReceiverVC
    }

    @IBAction func tiles(_ sender: UIButton) {
        game.numOfClicks += 1
        
        var a = 1
        var b = 0
        
        if game.isCross == false {
            a = 1
            b = 0
        } else {
            a = 0
            b = 1
        }
        
        //determine whether an image of a cross or a circle will show up depending on whether players have switched turns
        if game.numOfClicks % 2 == a {
            game.coordinates["crossX"]!.append(sender.tag % 3)
            game.coordinates["crossY"]!.append(sender.tag / 3)
            sender.setBackgroundImage(UIImage(named: "cross"), for: .normal)
        } else if game.numOfClicks % 2 == b {
            game.coordinates["circleX"]!.append(sender.tag % 3)
            game.coordinates["circleY"]!.append(sender.tag / 3)
            sender.setBackgroundImage(UIImage(named: "circle"), for: .normal)
        }
        
        //disable the buttons that have been pressed
        for button in buttonsPressed {
            if button.tag == sender.tag {
                button.isEnabled = false
            }
        }
        
        if game.numOfClicks == 1 {
            switchButton.isHidden = true
        }
        
        print(game.coordinates)
        game.checkWinner()
        updateGame()
    }
    
    
    @IBOutlet weak var switchButton: UIButton!
    @IBAction func switchTurns(_ sender: UIButton) {
        if game.isCross == false {
            game.isCross = true
        } else {
            game.isCross = false
        }
    }
    
    
    @IBOutlet var buttonsPressed: [UIButton]!
    @IBOutlet weak var crossScore: UILabel!
    @IBOutlet weak var circleScore: UILabel!
    
    @IBOutlet weak var resetButton: UIButton!
    @IBAction func resetGame(_ sender: UIButton) {
        //reset everything
        for button in buttonsPressed {
            button.setBackgroundImage(UIImage(named: "blank"), for: .normal)
            
                game.numOfClicks = 0
                game.index = 0
                game.count = 0
                game.crossIsWinner = false
                game.circleIsWinner = false
                game.coordinates = [
                "crossX" : [Int](),
                "crossY" : [Int](),
                "circleX" : [Int](),
                "circleY" : [Int]()]
                resetButton.isHidden = true
                switchButton.isHidden = false
                button.isEnabled = true
            
        }
    }
    
    //update the scores for cross and circle players
    func updateGame() {
        
        //if there's a win
        if game.crossIsWinner == true || game.circleIsWinner == true {
            resetButton.isHidden = false
            crossScore.text = ": \(game.numOfCrossWins)"
            circleScore.text = ": \(game.numOfCircleWins)"
        }
        
        //if it's a tie
        if game.numOfClicks == 9 {
            if game.crossIsWinner == false || game.circleIsWinner == false {
                resetButton.isHidden = false
            }
        }
        
    }
    
}

//attempting to programmatically set up a collectionview of buttons for game boards of different dimentions.
/*extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as UICollectionViewCell
        let Button = cell.viewWithTag(0) as! UIButton
        Button.borderColor = UIColor.darkGray
        return cell
    }
    
}
*/


//I grabbed this extension from stackoverflow just so I can easily put a rounded rectangular border around buttons
@IBDesignable extension UIButton {
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}
