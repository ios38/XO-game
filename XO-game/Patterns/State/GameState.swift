//
//  GameState.swift
//  XO-game
//
//  Created by Maksim Romanov on 10.03.2020.
//  Copyright © 2020 plasmon. All rights reserved.
//

import Foundation

public protocol GameState {
    
    var isCompleted: Bool { get }
    
    func begin()
    
    func addMark(at position: GameboardPosition)
}
