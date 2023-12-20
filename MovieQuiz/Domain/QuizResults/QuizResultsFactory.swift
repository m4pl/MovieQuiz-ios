//
//  QuizResultsFactory.swift
//  MovieQuiz
//
//  Created by Matvei Plokhov on 18.12.2023.
//

import Foundation

protocol QuizResultsFactory {
    func setService(_ service: StatisticService)
    func getQuizResults(correct count: Int, total amount: Int) -> QuizResultsViewModel?
}

class QuizResultsFactoryImpl: QuizResultsFactory {
    
    private var service: StatisticService?
    
    func setService(_ service: StatisticService) {
        self.service = service
    }
    
    func getQuizResults(correct count: Int, total amount: Int) -> QuizResultsViewModel? {
        service?.store(correct: count, total: amount)
        
        guard let bestGame = service?.bestGame else { return nil }
        guard let gamesCount = service?.gamesCount else { return nil }
        guard let totalAccuracy = service?.totalAccuracy else { return nil }
        
        let message = getMessage(
            correct: count,
            total: amount,
            gamesCount: gamesCount,
            totalAccuracy: totalAccuracy,
            bestGame: bestGame
        )
        
        return QuizResultsViewModel(
            title: "Этот раунд окончен!", 
            text: message,
            buttonText: "Сыграть ещё раз"
        )
    }
    
    private func getMessage(
        correct: Int,
        total: Int,
        gamesCount: Int, 
        totalAccuracy: Double,
        bestGame: GameRecord
    ) -> String {
        return "Ваш результат: \(correct)/\(total)\n" +
        "Количество сыгранных квизов: \(gamesCount)\n" +
        "Рекорд: \(bestGame.correct)/\(bestGame.total) \(bestGame.date.dateTimeString)\n" +
        "Средняя точность: \(String(format: "%.2f", totalAccuracy * 100))%"
    }
}
