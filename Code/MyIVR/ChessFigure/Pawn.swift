//
//  Pawn.swift
//  MyIVR
//
//  Created by Андрей Хромов on 18/10/2019.
//  Copyright © 2019 Андрей Хромов. All rights reserved.
//

import UIKit

class Pawn: DefaultFigure {
    public func canMove(row: Int, col: Int) -> Bool {
        print(row)
        print(col)
        return true
    }
}
