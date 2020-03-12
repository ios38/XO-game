//
//  LogAction.swift
//  XO-game
//
//  Created by Maksim Romanov on 11.03.2020.
//  Copyright © 2020 plasmon. All rights reserved.
//

import Foundation

public enum LogAction {
    
    case playerInput(player: Player, position: GameboardPosition)
    
    case gameFinished(winner: Player?)
    
    case restartGame
    
    
    public static func log(_ action: LogAction) {
        let command = LogCommand(action: action)
        LoggerInvoker.shared.addLogCommand(command)
    }
}
