//
//  GameEndedState.swift
//  XO-game
//
//  Created by Maksim Romanov on 10.03.2020.
//  Copyright © 2020 plasmon. All rights reserved.
//

import Foundation

public class GameEndedState: GameState {
    
    public let isCompleted = false
    public let winner: Player?
    let gameMode: GameMode?
    private(set) weak var gameViewController: GameViewController?
    
    init(winner: Player?, gameMode: GameMode?, gameViewController: GameViewController) {
        self.winner = winner
        self.gameMode = gameMode
        self.gameViewController = gameViewController
    }
    
    public func begin() {
        
        LogAction.log(.gameFinished(winner: winner))
        self.gameViewController?.winnerLabel.isHidden = false
        if let winner = winner {
            self.gameViewController?.winnerLabel.text = self.winnerName(from: winner) + " win"
        } else {
            self.gameViewController?.winnerLabel.text = "No winner"
        }
        self.gameViewController?.firstPlayerTurnLabel.isHidden = true
        self.gameViewController?.secondPlayerTurnLabel.isHidden = true
        
    }
    
    public func addMark(at position: GameboardPosition) { }
    
    private func winnerName(from winner: Player) -> String {
        switch winner {
        case .first:
            return "1st player"
        case .second:
            guard gameMode == .one else {
                return "2nd player"}
            return "Computer"
        }
    }
}
