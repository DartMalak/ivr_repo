//
//  StartFourPlayerGame.swift
//  TestTest
//
//  Created by Андрей Хромов on 14/10/2019.
//  Copyright © 2019 Андрей Хромов. All rights reserved.
//

import UIKit
import Firebase

class StartFourPlayerGame: UIViewController {
    
    var rait = 1
    let uid = Auth.auth().currentUser?.uid
    var key: String = ""
    

    @IBOutlet weak var MakeGame: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Background1.png")!)

        

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "StartFourSegue"{
            if let vc = segue.destination as? FourPlayersGame{
                //guard let playersInfo = sender as? Int else { return }
                vc.rait = rait
                if key != "" {
                    
                }
                
            }
        }
    }

    // MARK: - Navigation
    
    @IBAction func raitGame(_ sender: Any) {
        rait = abs(rait - 1)
        
    }
    
    @IBAction func pressedMakeGame(_ sender: Any) {
        DataService.instance.createGame(name: "MyGame", senderID: uid!, rait: rait) { (gameKey) in
            self.key = gameKey
        }
        self.performSegue(withIdentifier: "StartFourSegue", sender: 1)
    }
    



}
