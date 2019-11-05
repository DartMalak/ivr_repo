//
//  FourPlayersGame.swift
//  MyIVR
//
//  Created by Андрей Хромов on 24/10/2019.
//  Copyright © 2019 Андрей Хромов. All rights reserved.
//

import UIKit
import Firebase

class FourPlayersGame: UIViewController {
    
    let uid = Auth.auth().currentUser?.uid
    let dataservice = DataService.instance
    var boardButton = [Int:UIButton]()
    var winner = false
    var rait = 0
    var game: Game! //вот здесь может быть косяк
    var person: Int!
    let semaphore = DispatchSemaphore(value: 0)
    let semaphore2 = DispatchSemaphore(value: 0)
    var number = 0
    var position = [0, 0]
    var position1 = [0, 0]
    var sucsess = false
    var boardNumber = 1
    var figureNumber = 1
    var coordx = 34
    var coordy = 234
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        dataservice.figure(userID: self.uid!) { (number) in
            self.figureNumber = Int(number)!
        }
        dataservice.board(userID: self.uid!) { (number) in
            self.boardNumber = Int(number)!
        }
        waitPlayers()

        
    }
    

    // MARK: - Navigation
    
    func paint(board: GameData){
        print(board.boardA)
        for i in 0...63 {
            print(i)
            boardButton[i] = UIButton()
            boardButton[i]?.frame = CGRect(x: coordx + i, y: coordy + i, width: 38, height: 38)
            boardButton[i]?.setImage(UIImage(named: (String(Array((board.boardA[i]?.Color.rawValue)!)[0]) + (board.boardA[i]?.PType.rawValue)!)), for: UIControl.State.normal)
            self.view.addSubview(boardButton[i]!)
            boardButton[i]?.addTarget(self, action: #selector(buttonPressed(sender:)), for: .touchUpInside)
        }
    }
    
    @objc func buttonPressed(sender: UIButton) {
        
        number = Int(((Int(sender.center.x) - 19 - coordx) / 38) % 8 + ((-1 * (Int(sender.center.y)) + 19 + coordy) / 38) * 8)
        semaphore.signal()
    }
    
    // MARK: - gameFunc
    func waitPlayers(){
        while sucsess != true {
            let seconds = 4.0
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                self.dataservice.checkStatus(gameID: self.game.uuid) { (status) in
                    self.game.status = status
                    if Int(status) == 4{
                        self.sucsess = true
                    }
                }
            }
        }
        startNewGames()
    }
    
    func cheking() {
        sucsess = false
        while sucsess != true {
            let seconds = 4.0
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                self.dataservice.updateGame(gameID: self.game.uuid, board: String(self.number)) { (pos, pos1) in
                    if self.position1 != [pos!, pos1!] {
                        self.position = self.position1
                        self.position1 = [pos!, pos1!]
                        self.sucsess = true
                    
                    }
                }
            }
        }
    }
    
    func playGame(board: GameData, number: Int){
        var row = 1
        var col = 1
        var row1 = 1
        var col1 = 1
        let dispatchQueue = DispatchQueue.global(qos: .background)
        
        dispatchQueue.async {
            if self.person % 2 == 0 {
                self.semaphore.wait(timeout: DispatchTime.distantFuture)
                row = self.number / 8
                col = self.number % 8
                
                while board.boardA[row * 8 + col]?.PType == PieceType.empty || board.boardA[row * 8 + col]?.Color != Color.black{
                    print("not correct")
                    self.semaphore.wait(timeout: DispatchTime.distantFuture)
                    row = self.number / 8
                    col = self.number % 8
                }
                let pos = number
                self.semaphore.wait(timeout: DispatchTime.distantFuture)
                row1 = self.number / 8
                col1 = self.number % 8
                while !board.CanGoTo(position: row * 8 + col, nextPosition: row1 * 8 + col1) && !board.canKill(position: row * 8 + col, nextPosition: row1 * 8 + col1){
                    self.semaphore.wait(timeout: DispatchTime.distantFuture)
                    row1 = self.number / 8
                    col1 = self.number % 8
                }
                if board.CanGoTo(position: row * 8 + col, nextPosition: row1 * 8 + col1)
                {
                    board.GoTo(position: row * 8 + col, nextPosition: row1 * 8 + col1)
                    
                    // self.replaceButton(position: row * 8 + col, nextPosition: row1 * 8 + col1)
                
            }// board kill прописать
                self.dataservice.makeMove(gameID: self.game.uuid, board: String(number), pos: pos, pos1: self.number)
                
            }
            while self.winner != true{
                self.cheking()
                self.semaphore2.wait(timeout: DispatchTime.distantFuture)
                if board.CanGoTo(position: self.position1[0], nextPosition: self.position1[1]){
                    board.GoTo(position: self.position1[0], nextPosition: self.position1[1])
                    } // скопировать kill выше + отрисовка тут и выше на строчку
                
                
                self.semaphore.wait(timeout: DispatchTime.distantFuture)
                row = self.number / 8
                col = self.number % 8
                
                while board.boardA[row * 8 + col]?.PType == PieceType.empty || board.boardA[row * 8 + col]?.Color != Color.black{
                    print("not correct")
                    self.semaphore.wait(timeout: DispatchTime.distantFuture)
                    row = self.number / 8
                    col = self.number % 8
                }
                let pos = number
                self.semaphore.wait(timeout: DispatchTime.distantFuture)
                row1 = self.number / 8
                col1 = self.number % 8
                while !board.CanGoTo(position: row * 8 + col, nextPosition: row1 * 8 + col1) && !board.canKill(position: row * 8 + col, nextPosition: row1 * 8 + col1){
                    self.semaphore.wait(timeout: DispatchTime.distantFuture)
                    row1 = self.number / 8
                    col1 = self.number % 8
                }
                if board.CanGoTo(position: row * 8 + col, nextPosition: row1 * 8 + col1)
                {
                    board.GoTo(position: row * 8 + col, nextPosition: row1 * 8 + col1)
                    
                    // self.replaceButton(position: row * 8 + col, nextPosition: row1 * 8 + col1)
                    
                }// board kill прописать
                self.dataservice.makeMove(gameID: self.game.uuid, board: String(number), pos: pos, pos1: self.number)
            }
            
        }
        
    }
    func startNewGames(){
        let board1 = GameData()
        let board2 = GameData()
        if self.person < 3 {
            playGame(board: board1, number: 1)
        }else { 
            playGame(board: board2, number: 2)
        }
        
    }
    

}
