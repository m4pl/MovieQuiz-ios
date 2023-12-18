//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Matvei Plokhov on 18.12.2023.
//

import Foundation

protocol StatisticService {
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
    func store(correct count: Int, total amount: Int)
}

class StatisticServiceImpl: StatisticService {
    
    var totalAccuracy: Double {
        get {
            return userDefaults.double(forKey: Keys.total.rawValue)
        }
        
        set {
            userDefaults.set(newValue, forKey: Keys.total.rawValue)
        }
    }
    
    var gamesCount: Int {
        get {
            return userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        }
        
        set {
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                  let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }
            
            return record
        }
        
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    private let userDefaults = UserDefaults.standard
    
    func store(correct count: Int, total amount: Int) {
        let lastGame = bestGame
        let lastGamesCount = gamesCount
        let lasttotalAccuracy = totalAccuracy
        
        let newGame = GameRecord(
            correct: count,
            total: amount,
            date: Date()
        )
        
        totalAccuracy = (lasttotalAccuracy * Double(lastGamesCount) + (Double(count) / Double(amount))) / Double(lastGamesCount + 1)
        gamesCount = lastGamesCount + 1
        
        if(newGame.isBetterThan(lastGame)) {
            bestGame = newGame
        }
    }
    
    private enum Keys: String {
        case total, bestGame, gamesCount
    }
}
