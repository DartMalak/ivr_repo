//
//  Board.swift
//  TestTest
//
//  Created by Андрей Хромов on 16/10/2019.
//  Copyright © 2019 Андрей Хромов. All rights reserved.
//

import UIKit

class Board: NSObject {
    var field = [Int:Any]()
    
    public func configure(field: Dictionary<Int, Any>) {
        self.field = field
        print(self.field)
    }
}
