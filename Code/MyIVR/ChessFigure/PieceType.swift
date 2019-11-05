//
//  PieceType.swift
//  MyIVR
//
//  Created by Андрей Хромов on 19/10/2019.
//  Copyright © 2019 Андрей Хромов. All rights reserved.
//

import Foundation

enum PieceType: String {
    case rook = "rook"
    case king = "king"
    case knight = "knight"
    case queen = "quenn"
    case bishop = "bishop"
    case pawn = "pawn"
    case empty = "empty"
}

enum Color: String {
    case white = "white"
    case black = "black"
}
