//
//  File.swift
//  MyIVR
//
//  Created by Андрей Хромов on 18/10/2019.
//  Copyright © 2019 Андрей Хромов. All rights reserved.
//

import UIKit

class GameData {
    static let instance = GameData()
    
    public var boardA = [Int:Piece]()
    
    public func initBoardA() {
        
        // Lorem Ipsum BoardA
        boardA[0] = Piece(pieceType: .rook, position: 0, color: .white)
        boardA[1] = Piece(pieceType: .knight, position: 1, color: .white)
        boardA[2] = Piece(pieceType: .bishop, position: 2, color: .white)
        boardA[3] = Piece(pieceType: .queen, position: 3, color: .white)
        boardA[4] = Piece(pieceType: .king, position: 4, color: .white)
        boardA[5] = Piece(pieceType: .bishop, position: 5, color: .white)
        boardA[6] = Piece(pieceType: .knight, position: 6, color: .white)
        boardA[7] = Piece(pieceType: .rook, position: 7, color: .white)
        for i in 8...16{
            boardA[i] = Piece(pieceType: .pawn, position: i, color: .white)
        }
        for i in 16...48{
            boardA[i] = Piece(pieceType: .empty, position: i, color: .white)
        }
        for i in 48...56{
            boardA[i] = Piece(pieceType: .pawn, position: i, color: .black)
        }
        boardA[56] = Piece(pieceType: .rook, position: 56, color: .black)
        boardA[57] = Piece(pieceType: .knight, position: 57, color: .black)
        boardA[58] = Piece(pieceType: .bishop, position: 58, color: .black)
        boardA[59] = Piece(pieceType: .queen, position: 59, color: .black)
        boardA[60] = Piece(pieceType: .king, position: 60, color: .black)
        boardA[61] = Piece(pieceType: .bishop, position: 61, color: .black)
        boardA[62] = Piece(pieceType: .knight, position: 62, color: .black)
        boardA[63] = Piece(pieceType: .rook, position: 63, color: .black)
    }
    
    public func GoTo(position: Int, nextPosition: Int){
        boardA[nextPosition] = boardA[position]
        boardA[position] = Piece(pieceType: .empty, position: position, color: .white)

    }
    
    public func CanGoTo(position: Int, nextPosition: Int) -> Bool{
        let row = position / 8
        let col = position % 8
        let row1 = nextPosition / 8
        let col1 = nextPosition % 8
        switch boardA[position]!.PType{
            
            case PieceType.rook:
                print(col, col1, row, row1)
                print(boardA[nextPosition]!, boardA[position]!)
                if (col == col1 || row == row1) && (boardA[nextPosition]!.PType == PieceType.empty || boardA[nextPosition]!.Color != boardA[position]!.Color){
                    var need = [1, 1, 1]
                    if row == row1{
                        need = [col, col1, 1]
                        if col > col1{
                            need = [need[1], need[0], -1]
                        }
                    }
                    else{
                        need = [row, row1, 1]
                        if row > row1 {
                            need = [need[1], need[0], -1]
                        }
                    }
                    for i in need[0]...need[1]{
                        var j = i
                        if i == 0 {
                            j = 1
                        }else if i == 8{
                            j = 7
                        } // дебил поправь эту хуйню
                        if col == col1 && boardA[(row + j) * 8 + j]!.PType != PieceType.empty{
                            print(boardA[row1 * 8 + j]!.PType)
                            return false
                        }
                        if row == row1 && boardA[j * 8 + col]!.PType != PieceType.empty{
                            return false
                        }
                    }
                    return true
                }
            return false
            
        case PieceType.pawn:
            print("пешку поймал")
            var direction = 1
            var startRow = 1
            if boardA[position]!.Color == Color.black{
                direction = -1
                startRow = 6
            }
            print(direction, "direction")
            print(startRow, "startRow")
            print(row, "row")
            print(row1, "row1")
            print(boardA[nextPosition]!.PType)
            if row + direction == row1 && boardA[nextPosition]!.PType == PieceType.empty{
                return true
            }
            if startRow == row && row + direction * 2 == row1 && boardA[nextPosition]!.PType == PieceType.empty{
                return true
            }
            
        case PieceType.king:
            // ...
            return false
            
        case PieceType.queen:
            if (abs(row - row1) == abs(col - col1) || (col == col1 || row == row1)) && boardA[nextPosition]!.PType == PieceType.empty {
                if col == col1 || row == row1{
                    var need = [1, 1, 1]
                    if row == row1{
                        need = [col, col1, 1]
                        if col > col1{
                            need = [need[1], need[0], -1]
                        }
                    }
                    else{
                        need = [row, row1, 1]
                        if row > row1 {
                            need = [need[1], need[0], -1]
                        }
                    }
                    for i in need[0]...need[1]{
                        if col == col1 && boardA[row1 * 8 + i]!.PType != PieceType.empty{
                            return false
                        }
                        if row == row1 && boardA[i * 8 + col]!.PType != PieceType.empty{
                            return false
                        }
                    }
                    return true
                }
                else if abs(row - row1) == abs(col - col1) {
                    var coords = [row, col]
                    while coords != [row1, col1] {
                        coords[0] += (row - row1) / abs(row - row1)
                        coords[1] += (col - col1) / abs(col - col1)
                        if boardA[coords[0] * 8 + coords[1]]!.PType != PieceType.empty{
                            return false
                        }
                    }
                    return true
                }
            }
            return false
            
        case PieceType.bishop:
            print("лфдья")
            print(row, row1, col, col1)
            if abs(row - row1) == abs(col - col1){
                var coords = [row, col]
                print(coords)
                while coords != [row1, col1] {
                    coords[0] += (row1 - row) / abs(row - row1)
                    coords[1] += (col1 - col) / abs(col - col1)
                    print(coords)
                    if boardA[coords[0] * 8 + coords[1]]!.PType != PieceType.empty{
                        return false
                        
                    }
                }
                return true
            }
            return false
            
        case PieceType.knight:
            if (((row1 - 2 == row || row1 + 2 == row) && (col1 - 1 == col || col1 + 1 == col)) || ((row1 - 1 == row || row1 + 1 == row) && (col1 - 2 == col || col1 + 2 == col))) && boardA[nextPosition]!.PType == PieceType.empty{
                return true
            }
            return false
        default:
            return false
        }
        return false
    }
    
    public func canKill(position: Int, nextPosition: Int) -> Bool{
        if boardA[nextPosition]!.Color != boardA[position]!.Color{
            let a = boardA[nextPosition]
            boardA[nextPosition] = Piece(pieceType: .empty, position: nextPosition, color: .white)
            if CanGoTo(position: position, nextPosition: nextPosition) {
                boardA[nextPosition] = a
                return true
            }
            boardA[nextPosition] = a
            return false
        }
        return false
    }
    
    public func kill(position: Int, nextPosition: Int){
        // let a = boardA[nextPosition]
        boardA[nextPosition] = boardA[position]
        boardA[position] = Piece(pieceType: .empty, position: position, color: .white)
    }
    
    public func check(position: Int, killerPosition: Int) -> Bool {
        return false
    }
    
    
    func correctCoords(row: Int, col: Int) -> Bool{
        if (row > 8 || row < 0) || (col < 0 || col > 8){
            print("false")
            return false
        }
        print("true")
        return true
    }
}
