//
//  Rook.swift
//  TestTest
//
//  Created by Андрей Хромов on 15/10/2019.
//  Copyright © 2019 Андрей Хромов. All rights reserved.
//

import UIKit

class Rook: DefaultFigure {
    
    public func canMove(row: Int, col: Int) -> Bool{
        if correctCoords(row: row, col: col) && ((abs(self.row - row) == abs(self.col - col)) || self.col == col || self.row == row){
            return false
        }
        return true
    }
}
