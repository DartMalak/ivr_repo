//
//  File.swift
//  MyIVR
//
//  Created by Андрей Хромов on 22/10/2019.
//  Copyright © 2019 Андрей Хромов. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

let DB_base = Database.database().reference()


class Game {
    var name: String
    var status: String
    var senderID: String
    var uuid: String
    var rait: String
    
    init(name: String, status: String, senderID: String, uuid: String, rait: String) {
        self.name = name
        self.status = status
        self.senderID = senderID
        self.uuid = uuid
        self.rait = rait
    }
}

class DataService {
    static let instance = DataService()
    
    private var _REF_Users = DB_base.child("users")
    private var _REF_Games = DB_base.child("games")
    
    var REF_Users: DatabaseReference {
        return _REF_Users
    }
    
    var REF_Games: DatabaseReference {
        return _REF_Games
    }
    
    
    // MARK: - UserInfo
    func setBoard(userID: String, number: String){
        let ref = REF_Users.child(userID)
        ref.updateChildValues(["board": number])
    }
    
    func board(userID: String, handler: @escaping(_ number: String) -> ()){
        let ref = REF_Users.child(userID)
        ref.observeSingleEvent(of: .value) { (snapshot) in
        guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else { return }
        snapshot.forEach { (snap) in
            let number = snap.childSnapshot(forPath: "number").value as? String ?? "1"
            handler(number)
            }
        }
        
    }
    
    func setFigure(userID: String, number: String){
        let ref = REF_Users.child(userID)
        ref.updateChildValues(["figure": number])
    }
    
    func figure(userID: String, handler: @escaping(_ number: String) -> ()){
        let ref = REF_Users.child(userID)
        ref.observeSingleEvent(of: .value) { (snapshot) in
        guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else { return }
        snapshot.forEach { (snap) in
            print(snap.childSnapshot(forPath: "figure").value)
            let number = snap.childSnapshot(forPath: "figure").value as? String ?? "1"
            
            handler(number)
            
            }
        }
    }
    
    // MARK: - MultiUserCommand
    
    func createGame(name: String, senderID: String, rait: Int, success: @escaping(_ uuid: String) -> ()) {
        let ref = REF_Games.childByAutoId()
        let key = ref.key
        ref.updateChildValues(["name":name,
                               "status": "1",
                               "senderID": senderID,
                               "uuid": key!,
                               "rait": String(rait)
        ])
        REF_Users.child(senderID).child("userGames").childByAutoId().setValue(key)

        success(key!)
    }
    
    func searchGame(handler: @escaping (_ games: [Game]) -> ()) {
        var gameArray = [Game]()
        let ref = REF_Games
        ref.observeSingleEvent(of: .value) { (snapshot) in
        guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else { return }
        snapshot.forEach { (snap) in
            let gameName = snap.childSnapshot(forPath: "name").value as! String
            let gameStatus = snap.childSnapshot(forPath: "status").value as! String
            let senderID = snap.childSnapshot(forPath: "senderID").value as! String
            let uuid = snap.childSnapshot(forPath: "uuid").value as! String
            let rait = snap.childSnapshot(forPath: "rait").value as! String
            let game = Game(name: gameName, status: gameStatus, senderID: senderID, uuid: uuid, rait: rait)
            if Int(gameStatus)! < 4 {
                gameArray.append(game)
                }
            }
        }
        handler(gameArray)
    }
    
    func enterGame(userID: String, gameID: String, status: String) {
        let ref = REF_Games.child(gameID)
        REF_Users.child(userID).child("userGames").childByAutoId().setValue(gameID)
        ref.updateChildValues(["status": status])
        
        
    }
    
    func checkStatus(gameID: String, handler: @escaping(_ status: String) -> ()) {
        let ref = REF_Games.child(gameID)
        ref.observeSingleEvent(of: .value) { (snapshot) in
                guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else { return }
                snapshot.forEach { (snap) in
                    
                    let status = snap.childSnapshot(forPath: "status").value as! String
        
                    handler(status)
        
                }
            }
    }
    
    
    
    func updateGame(gameID: String, board: String, handler: @escaping (_ from: Int?, _ to: Int?) -> ()) {
        let ref = REF_Games.child(gameID).child(board)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else { return }
            snapshot.forEach { (snap) in
                
                let from:Int? = Int(snap.childSnapshot(forPath: "LastFrom").value as! String)
                let to: Int? = Int(snap.childSnapshot(forPath: "LastTo").value as! String)
                handler(from, to)
    
            }
        }
        
    }
    
    func makeMove(gameID: String, board: String,pos: Int, pos1: Int) {
        let ref = REF_Games.child(gameID).child(board)
        ref.updateChildValues(["LastFrom":String(pos),
                               "LastTo": String(pos1)
        ])
    }
    
    func setDead(gameID: String, board: String, figure: String) {
        let ref = REF_Games.child(gameID).child(board)
        ref.updateChildValues(["" : figure])
    }
    
    func checkDead(gameID: String, board: String, handler: @escaping (_ figure: [String]) -> ()) {
        let ref = REF_Games.child(gameID).child(board)
        ref.observeSingleEvent(of: .value) { (snapshot) in
                guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else { return }
                snapshot.forEach { (snap) in
                    
                    let to = snap.childSnapshot(forPath: "LastTo").value as! String
                    handler([to])
        
                }
            }
    }
    
    
    // MARK: - OneUserCommand
    func saveGame(userID: String, players: Int, color: Int, moves: Int, board: [Int : Piece]) {
        let ref = REF_Games.child("saves").childByAutoId()
        let gameID = ref.key
        for i in 0...63 {
            var k = String(i)
            if i < 10 {
                k = "0" + k
            }
            ref.updateChildValues([k + "PieceType": board[i]!.PType.rawValue,
                                   k + "Color": board[i]!.Color.rawValue,
            ])
            
        }
        ref.updateChildValues(["players" : String(players)])
        ref.updateChildValues(["moves" : String(moves)])
        ref.updateChildValues(["date" : Date().description])
        ref.updateChildValues(["color" : color])
        REF_Users.child(userID).child("userSaves").childByAutoId().setValue(gameID)
        
        
        
    }
    func checkSaves(userID: String, handler: @escaping (_ saves: [String]) -> ()){
        let ref = REF_Users.child(userID).child("userSaves")
        var saveGamesID = [String]()
        ref.observeSingleEvent(of: .value) { (snapshot) in
        guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else { return }
            snapshot.forEach { (snap) in
                saveGamesID.append(snap.value as! String)
            }
        handler(saveGamesID)
        }
        
    }
    func loadGame(gameID: String, handler: @escaping (_ save: [Int : Piece], _ players: Int, _ color: Int, _ date: String, _ moves: Int) -> ()){
        let ref = REF_Games.child("saves")
        var pieces = [Int : Piece]()
        ref.observeSingleEvent(of: .value) { (snapshot) in
        guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else { return }
            snapshot.forEach { (snap) in
                for i in 0...63{
                    var k = String(i)
                    if i < 10 {
                        k = "0" + k
                    }
                    let piece = snap.childSnapshot(forPath: k + "PieceType").value as! String
                    let color = snap.childSnapshot(forPath: k + "Color").value as! String
                    pieces[i] = Piece(pieceType: PieceType(rawValue: piece)!, position: i, color: Color(rawValue: color)!)
                }
                let players:Int? = Int(snap.childSnapshot(forPath: "players").value as! String)
                let color: Int? = Int(snap.childSnapshot(forPath: "color").value as! String)
                let date: String? = snap.childSnapshot(forPath: "date").value as? String
                let moves: Int? = Int(snap.childSnapshot(forPath: "moves").value as! String)
                handler(pieces, players!, color!, date!, moves!)
            }
            
        }
        
    }
    
    
    
    
    
}
