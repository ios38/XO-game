//
//  MarkCommand.swift
//  XO-game
//
//  Created by Maksim Romanov on 11.03.2020.
//  Copyright © 2020 plasmon. All rights reserved.
//

import Foundation

class MarkCommand {
    
    let position: GameboardPosition
    let player: Player
    let gameboard: Gameboard
    let gameboardView: GameboardView
    
    init(position: GameboardPosition, player: Player, gameboard: Gameboard, gameboardView: GameboardView) {
        self.position = position
        self.player = player
        self.gameboard = gameboard
        self.gameboardView = gameboardView
    }
    
    func execute() {
        self.gameboard.setPlayer(player, at: position)
        let markView = self.player.markViewPrototype
        self.gameboardView.replaceMarkView(markView, at: self.position)
    }
}
