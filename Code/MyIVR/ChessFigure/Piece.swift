//
//  Piece.swift
//  MyIVR
//
//  Created by Андрей Хромов on 18/10/2019.
//  Copyright © 2019 Андрей Хромов. All rights reserved.
//

import UIKit

class Piece {
    private var pieceType: PieceType
    private var color: Color
    private var position: Int
    
    var PType: PieceType {
        return pieceType
    }
    
    var Color: Color {
        return color
    }
    
    var Position: Int {
        return position
    }
    
    init(pieceType:PieceType, position:Int, color:Color) {
        self.pieceType = pieceType
        self.position = position
        self.color = color
    }
    
    public func isValidMove(currentColor: Color) -> Bool {
        if self.color != currentColor { return false }
        
        switch pieceType {
            case .rook:
                // if ...
                break
            case .king:
                // ...
                break
            case .queen:
                // ...
                break
            default:
                // ...
                break
        }
        
        return true
    }
}

