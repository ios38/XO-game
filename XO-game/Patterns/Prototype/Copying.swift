//
//  Copying.swift
//  XO-game
//
//  Created by Maksim Romanov on 11.03.2020.
//  Copyright © 2020 plasmon. All rights reserved.
//

import Foundation

protocol Copying {
    init(_ prototype: Self)
}

extension Copying {
    func makeCopy() -> Self {
        return type(of: self).init(self)
    }
}
