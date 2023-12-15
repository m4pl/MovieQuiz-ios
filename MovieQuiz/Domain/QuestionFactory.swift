//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Matvei Plokhov on 15.12.2023.
//

import Foundation

protocol QuestionFactory {
    func requestNextQuestion() -> QuizQuestion?
}

internal class QuestionFactoryImpl: QuestionFactory {
    
    let repository: QuestionsRepository
    
    init(repository: QuestionsRepository) {
        self.repository = repository
    }
    
    func requestNextQuestion() -> QuizQuestion? {
        guard let questions = repository.getQuestions() else {
            return nil
        }
        
        guard let index = (0..<questions.count).randomElement() else {
            return nil
        }
        
        return questions[safe: index]
    }
}
