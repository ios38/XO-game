//
//  GameViewController.swift
//  XO-game
//
//  Created by Maksim Romanov on 10.03.2020.
//  Copyright © 2020 plasmon. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet var gameboardView: GameboardView!
    @IBOutlet var firstPlayerTurnLabel: UILabel!
    @IBOutlet var secondPlayerTurnLabel: UILabel!
    @IBOutlet var winnerLabel: UILabel!
    @IBOutlet var restartButton: UIButton!
    @IBOutlet weak var GameModeSelector: UISegmentedControl!
    
    private var player: Player = .first
    private lazy var referee = Referee(gameboard: self.gameboard)
    private let gameboard = Gameboard()
    private let markInvoker = MarkInvoker.shared
    private var currentState: GameState! {
        didSet {
            self.currentState.begin()
        }
    }

    private var gameMode: GameMode {
        switch self.GameModeSelector.selectedSegmentIndex {
        case 0:
            return .two
        case 1:
            return .one
        case 2:
            return .blindly
        default:
            return .two
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
        goToFirstState()
        
        gameboardView.onSelectPosition = { [weak self] position in
            guard let self = self else { return }
            self.currentState.addMark(at: position)
            self.goToNextState()
        }
    }

    private func goToFirstState() {
        switch gameMode {
        case .blindly:
            goToBlindInputState(with: .first)
        default:
            goToPlayerInputState(with: .first)
        }
    }

    private func goToNextState() {
        guard self.currentState.isCompleted else { return }
        
        switch gameMode {
            
        case .blindly:
            guard !markInvoker.needExecute() else {
                markInvoker.executeCommandQueue { [weak self] in
                    guard let self = self else { return }
                    if let winner = self.referee.determineWinner() {
                        self.currentState = GameEndedState(winner: winner,
                                                           gameMode: self.gameMode,
                                                           gameViewController: self)
                    } else {
                        self.currentState = GameEndedState(winner: nil,
                                                           gameMode: nil,
                                                           gameViewController: self)
                    }
                }
                return
            }
            goToBlindInputState(with: .second)
            
        default:
            if let winner = referee.determineWinner() {
                currentState = GameEndedState(winner: winner,
                                              gameMode: gameMode,
                                              gameViewController: self)
                return
            } else if gameboard.getFreePositions().count == 0 {
                currentState = GameEndedState(winner: nil,
                                              gameMode: nil,
                                              gameViewController: self)
                return
            }
            
            player = player.next
            if player == .first {
                goToPlayerInputState(with: self.player)
            } else if gameMode == .two {
                goToPlayerInputState(with: self.player)
            } else {
                goToComputerInputState(with: self.player)
                goToNextState()
            }
        }
    }

    private func goToPlayerInputState(with player: Player) {
        currentState = PlayerInputState(player: player,
                                             gameViewController: self,
                                             gameboard: self.gameboard,
                                             gameboardView: self.gameboardView,
                                             markViewPrototype: player.markViewPrototype)
    }

    private func goToComputerInputState(with player: Player) {
        currentState = ComputerInputState(player: player,
                                             gameViewController: self,
                                             gameboard: self.gameboard,
                                             gameboardView: self.gameboardView,
                                             markViewPrototype: player.markViewPrototype)
    }

    private func goToBlindInputState(with player: Player) {
        currentState = BlindInputState(player: player,
                                             gameViewController: self,
                                             gameboard: self.gameboard,
                                             gameboardView: self.gameboardView)
    }

    private func restartGame() {
        gameboardView.clear()
        gameboard.clear()
        player = .first
        //markInvoker.clear()
        LogAction.log(.restartGame)
        goToFirstState()

    }

    @IBAction func gameModeSelected(_ sender: UISegmentedControl) {
        restartGame()
    }

    @IBAction func restartButtonTapped(_ sender: UIButton) {
        restartGame()
    }
}
