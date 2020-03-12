//
//  MarkInvoker.swift
//  XO-game
//
//  Created by Maksim Romanov on 11.03.2020.
//  Copyright © 2020 plasmon. All rights reserved.
//

import Foundation

internal final class MarkInvoker {

    // MARK: Singleton
    
    static let shared = MarkInvoker()
    
    // MARK: Private properties
    
    private let batchSize = 10
    private var commandQueue = [MarkCommand]()
    private var timer = Timer()
    private var completion:(() -> Void)?
    
    // MARK: Internal
    
    func addCommand(_ markCommand: MarkCommand) {
        self.commandQueue.append(markCommand)
    }
    /*
    func clear() {
        self.commandQueue.removeAll()
    }*/

    func needExecute() -> Bool {
        let needExecute =  commandQueue.count == batchSize
        return needExecute
    }

    // MARK: Private
    
    func executeCommandQueue(completion: @escaping () -> Void) {
        self.completion = completion
        commandQueue = sortedCommandQueue()
        startTimer()
    }

    func sortedCommandQueue() -> [MarkCommand] {
        let firstPlayerCommands = commandQueue[0...4]
        let secondPlayerCommands = commandQueue[5...9].compactMap{$0}
        var commands = [MarkCommand]()
        for i in 0...4 {
            commands.append(firstPlayerCommands[i])
            commands.append(secondPlayerCommands[i])
        }
        return commands
    }

    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(executeCommand), userInfo: nil, repeats: true)
    }
    
    @objc func executeCommand() {
        if commandQueue.count > 0 {
            commandQueue.first?.execute()
            commandQueue.removeFirst()
        } else {
            completion?()
            timer.invalidate()
        }
    }
}
