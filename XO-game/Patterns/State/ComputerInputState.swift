//
//  ComputerInputState.swift
//  XO-game
//
//  Created by Maksim Romanov on 10.03.2020.
//  Copyright © 2020 plasmon. All rights reserved.
//

import Foundation

public class ComputerInputState: GameState {
    
    public private(set) var isCompleted = false
    public let player: Player
    public let markViewPrototype: MarkView
    private(set) weak var gameViewController: GameViewController?
    private(set) weak var gameboard: Gameboard?
    private(set) weak var gameboardView: GameboardView?
    
    //init(player: Player, gameViewController: GameViewController, gameboard: Gameboard, gameboardView: GameboardView) {
    init(player: Player, gameViewController: GameViewController, gameboard: Gameboard, gameboardView: GameboardView, markViewPrototype: MarkView) {
        self.player = player
        self.gameViewController = gameViewController
        self.gameboard = gameboard
        self.gameboardView = gameboardView
        self.markViewPrototype = markViewPrototype
    }
    
    public func begin() {
        self.gameViewController?.firstPlayerTurnLabel.isHidden = true
        self.gameViewController?.secondPlayerTurnLabel.isHidden = false
        self.gameViewController?.winnerLabel.isHidden = true
        let position: GameboardPosition = getMarkPosition()
        addMark(at: position)
    }
    
    public func addMark(at position: GameboardPosition) {
        //let markView = OView()
        let markView = self.player.markViewPrototype.makeCopy()
        self.gameboard?.setPlayer(self.player, at: position)
        self.gameboardView?.placeMarkView(markView, at: position)
        self.isCompleted = true
        
        //LogAction.log(.playerInput(player: self.player, position: position))
    }
    
    private func getMarkPosition() -> GameboardPosition {
        let freePositions = gameboard!.getFreePositions()
        return freePositions.randomElement()!
    }
}
