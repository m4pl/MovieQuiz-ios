//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by Matvei Plokhov on 18.12.2023.
//

import Foundation

struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date
    
    func isBetterThan(_ another: GameRecord) -> Bool {
        return correct > another.correct
    }
}
