//
//  TwoPlayerGame.swift
//  TestTest
//
//  Created by Андрей Хромов on 14/10/2019.
//  Copyright © 2019 Андрей Хромов. All rights reserved.
//

import UIKit
import Firebase

class TwoPlayerGame: UIViewController {
    
    let uid = Auth.auth().currentUser?.uid
    
    let dataservice = DataService.instance
    var playersInfo: [Int]!
    var number = 0
    var boardButton = [Int:UIButton]()
    let semaphore = DispatchSemaphore(value: 0)
    var moves = 0
    var coppy = GameData()
    var userSaves = [String]()
    var load = false
    var boardNumber = "1"
    var figureNumber = "1"
    var coordx = 34
    var coordy = 234
    
    @IBOutlet weak var boardImage: UIImageView!
    


    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Background1.png")!)
        self.dataservice.figure(userID: self.uid!) { (number) in
            self.figureNumber = number
        }
        self.dataservice.board(userID: self.uid!) { (number) in
            self.boardNumber = number
        }
        print("board is gone")
        
        if playersInfo != nil {
            startNewGame(playersInfo: playersInfo!)
        }
        // (42.0, 439.0, 38.0, 38.0)
        print("ooo, shit")

    }
    
    
    // jkdfd@gmail.com
    // jdjsawj
    
    // MARK: - Navigation
    @IBAction func saveGame(_ sender: Any) {
        
        DataService.instance.saveGame(userID: uid!, players: playersInfo[0], color: playersInfo[1], moves: moves, board: coppy.boardA)
    }
    
    func paint(board: GameData){
        print(board.boardA)
        self.boardImage.image = UIImage(named: self.boardNumber + "board")
        for i in 0...63 {
            boardButton[i] = UIButton()
            boardButton[i]?.frame = CGRect(x: 42.0 + Double(i % 8 * 38), y: 439.0 - Double(i / 8 * 38), width: 38.0, height: 38.0)
            if board.boardA[i]?.PType != PieceType.empty{
                boardButton[i]?.setImage(UIImage(named: self.figureNumber+(String(Array((board.boardA[i]?.Color.rawValue)!)[0]) + (board.boardA[i]?.PType.rawValue)!)), for: UIControl.State.normal)
                print("есть")
                print((String(Array((board.boardA[i]?.Color.rawValue)!)[0]) + (board.boardA[i]?.PType.rawValue)!))
            }
            self.view.addSubview(boardButton[i]!)
            boardButton[i]?.addTarget(self, action: #selector(buttonPressed(sender:)), for: .touchUpInside)
            
            
        }
    }

    
    @objc func buttonPressed(sender: UIButton) {
        print(20000)
        print(sender.center.x)
        print(sender.center.y)
        print(((-1 * (Int(sender.center.y)) + 19 + 439) / 38))
        print(((Int(sender.center.x) - 19 - 42) / 38) % 8)
        number = Int(((Int(sender.center.x) - 19 - 42) / 38) % 8 + ((-1 * (Int(sender.center.y)) + 19 + 439) / 38) * 8)
        semaphore.signal()
    }
    
    func replaceButton(position: Int, nextPosition: Int) {
        let row = position / 8
        let col = position % 8
        let row1 = nextPosition / 8
        let col1 = nextPosition % 8
        DispatchQueue.main.async {
            self.boardButton[position]?.frame = CGRect(x: 42.0 + Double(nextPosition % 8 * 38), y: 439.0 - Double(nextPosition / 8 * 38), width: 38.0, height: 38.0)
            //self.board[position]?.setTitle(String(row1 * 8 + col1), for: UIControl.State.normal)
            
            self.boardButton[nextPosition]?.frame = CGRect(x: 42.0 + Double(position % 8 * 38), y: 439.0 - Double(position / 8 * 38), width: 38.0, height: 38.0)
            //self.board[nextPosition]?.setTitle(String(row * 8 + col), for: UIControl.State.normal)
            let a = self.boardButton[row1 * 8 + col1]
            self.boardButton[row1 * 8 + col1] = self.boardButton[row * 8 + col]
            self.boardButton[row * 8 + col] = a
            
        }
    }
    
    func startNewGame(playersInfo: [Int]){
        GameData.instance.initBoardA()
        
        
        let verf = GameData()
        verf.initBoardA()
        self.coppy = verf
        var winner = true
        paint(board: verf)
        var row = -1
        var col = -1
        var row1 = -1
        var col1 = -1
        let dispatchQueue = DispatchQueue.global(qos: .background)
        var color = 0
        dispatchQueue.async {
            
            while winner {
                self.coppy = verf
                var ptcolor = Color.white
                if color == 1 {
                    ptcolor = Color.black
                }
         
                self.semaphore.wait(timeout: DispatchTime.distantFuture)
                print("number")
                print(self.number)
                row = self.number / 8
                col = self.number % 8
                
                while verf.boardA[row * 8 + col]?.PType == PieceType.empty || verf.boardA[row * 8 + col]?.Color != ptcolor{
                    print("not correct")
                    self.semaphore.wait(timeout: DispatchTime.distantFuture)
                    row = self.number / 8
                    col = self.number % 8
                }
                self.semaphore.wait(timeout: DispatchTime.distantFuture)
                row1 = self.number / 8
                col1 = self.number % 8
                while !verf.CanGoTo(position: row * 8 + col, nextPosition: row1 * 8 + col1) && !verf.canKill(position: row * 8 + col, nextPosition: row1 * 8 + col1){
                    print("not correct 2")
                    print(row * 8 + col)
                    print(row1 * 8 + col)
                    print(verf.boardA[row1 * 8 + col1]?.PType)
                    self.semaphore.wait(timeout: DispatchTime.distantFuture)
                    row1 = self.number / 8
                    col1 = self.number % 8
                }
                print("уже тут")
                if verf.CanGoTo(position: row * 8 + col, nextPosition: row1 * 8 + col1)
                {
                    print("вроде сходил")
                    verf.GoTo(position: row * 8 + col, nextPosition: row1 * 8 + col1)
                    self.replaceButton(position: row * 8 + col, nextPosition: row1 * 8 + col1)
                    
                }
                else if verf.canKill(position: row * 8 + col, nextPosition: row1 * 8 + col1)
                {
                    print("убил")
                    verf.kill(position: row * 8 + col, nextPosition: row1 * 8 + col1)
                    DispatchQueue.main.async { // вот эту шнягу надо протестить, вроде работает
                        self.boardButton[row * 8 + col]?.frame = CGRect(x: 42.0 + Double((row1 * 8 + col1) % 8 * 38), y: 439.0 - Double((row1 * 8 + col1) / 8 * 38), width: 38.0, height: 38.0)
                        self.boardButton[row1 * 8 + col1] = self.boardButton[row * 8 + col]
                        self.boardButton[row * 8 + col] = UIButton()
                        self.boardButton[row * 8 + col]?.frame = CGRect(x: 42.0 + Double((row * 8 + col) % 8 * 38), y: 439.0 - Double((row * 8 + col) / 8 * 38), width: 38.0, height: 38.0)
                        
                    }
                    
                }
                print("ep")
                for i in 0...63
                {
                    if verf.boardA[i]!.PType == PieceType.king && verf.boardA[i]!.Color != verf.boardA[row1 * 8 + col1]!.Color
                    {
                        if verf.check(position: i, killerPosition: row1 * 8 + col1) {
                            winner = false
                        }
                    }
                }
                self.moves += 1
                color = abs(color - 1)
            }
            if self.moves % 2 == 1{
                print("Black Win")
            }else {
                print("White Win")
            }
        }
    
        
        
    

    }
    
}
