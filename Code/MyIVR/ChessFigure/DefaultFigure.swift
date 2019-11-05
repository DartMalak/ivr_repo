//
//  DefaultFigure.swift
//  TestTest
//
//  Created by Андрей Хромов on 15/10/2019.
//  Copyright © 2019 Андрей Хромов. All rights reserved.
//

import UIKit

class DefaultFigure: NSObject {
    var row: Int!
    var col: Int!
    var color: String!
    
    public func configure(row: Int, col: Int, color: String!){
        self.row = row
        self.col = col
        self.color = color
    }
    
    func correctCoords(row: Int, col: Int) -> Bool {
        if 0 <= row && 8 > row && 0 <= col && col < 8{
            return true
        } else {
            return false
        }
    }
    
    public func getColor() -> String{
        return self.color
    }
    
    public func setPosition(row: Int, col: Int){
        if correctCoords(row: row, col: col){
            self.col = col
            self.row = row
        
        }
    }
}
