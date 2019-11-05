//
//  StartTwoPlayerGame.swift
//  TestTest
//
//  Created by Андрей Хромов on 14/10/2019.
//  Copyright © 2019 Андрей Хромов. All rights reserved.
//

import UIKit

class StartTwoPlayerGame: UIViewController {

    @IBOutlet weak var PlayerQuantityControl: UISegmentedControl!
    @IBOutlet weak var FigureColorControl: UISegmentedControl!
    
    var info = [1, 0]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Background1.png")!)

        
        self.PlayerQuantityControl.addTarget(self, action: #selector(switchPlayer(paramTarget:)), for: .valueChanged)
        
        self.FigureColorControl.addTarget(self, action: #selector(switchColor(paramTarget:)), for: .valueChanged)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TwoPlayerInfo"{
            if let vc = segue.destination as? TwoPlayerGame{
                //cguard let playersInfo = sender as? Int else { return }
                print(11)
                vc.playersInfo = info
            }
        }
    }

    // MARK: - Navigation

    @IBAction func GoToTwoPlayerGameScreenButton(_ sender: Any) {
        self.performSegue(withIdentifier: "TwoPlayerInfo", sender: 1)
    }
    @objc func switchPlayer(paramTarget: UISegmentedControl){
        if paramTarget.selectedSegmentIndex == 1{
            FigureColorControl.isMomentary = true
            FigureColorControl.selectedSegmentIndex = -1
            info[0] = 2
            info[1] = 0
        }
        else {
            FigureColorControl.isMomentary = false
            info[0] = 1
            
        }
        print(info)
    }
    
    @objc func switchColor(paramTarget: UISegmentedControl){
        if paramTarget.selectedSegmentIndex == 1 && FigureColorControl.isMomentary != true{
            info[1] = 1
        }
        else {
            info[1] = 0
        }
        print(info)
    }

}
