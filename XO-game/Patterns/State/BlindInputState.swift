//
//  BlindInputState.swift
//  XO-game
//
//  Created by Maksim Romanov on 11.03.2020.
//  Copyright © 2020 plasmon. All rights reserved.
//

import Foundation

public class BlindInputState: GameState {
    
    public private(set) var isCompleted = false    
    public let player: Player
    private(set) weak var gameViewController: GameViewController?
    private(set) weak var gameboard: Gameboard?
    private(set) weak var gameboardView: GameboardView?
    private let markInvoker = MarkInvoker.shared
    var playerMarks = [GameboardPosition]()
    let maxMarkCount = 5
    
    init(player: Player, gameViewController: GameViewController, gameboard: Gameboard, gameboardView: GameboardView) {
        self.player = player
        self.gameViewController = gameViewController
        self.gameboard = gameboard
        self.gameboardView = gameboardView
    }
    
    public func begin() {
        switch self.player {
        case .first:
            self.gameViewController?.firstPlayerTurnLabel.isHidden = false
            self.gameViewController?.secondPlayerTurnLabel.isHidden = true
        case .second:
            self.gameViewController?.firstPlayerTurnLabel.isHidden = true
            self.gameViewController?.secondPlayerTurnLabel.isHidden = false
        }
        self.gameViewController?.winnerLabel.isHidden = true
    }
    
    public func addMark(at position: GameboardPosition) {
        while playerMarks.count < maxMarkCount {
            guard !self.playerMarks.contains(position) else { return }
            addMarkCommand(at: position)
        }
        //print("Player \(player) turn is completed")
        self.isCompleted = true
    }
    
    public func addMarkCommand(at position: GameboardPosition) {
        playerMarks.append(position)
        guard let gameboard = gameboard,
            let gameboardView = gameboardView else { return }
        let command = MarkCommand(position: position, player: player, gameboard: gameboard, gameboardView: gameboardView)
        markInvoker.addCommand(command)
    }
}
