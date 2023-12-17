//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Matvei Plokhov on 15.12.2023.
//

import Foundation

protocol QuestionFactory {
    var repository: QuestionsRepository? { get set }
    var delegate: QuestionFactoryDelegate? { get set }
    func requestNextQuestion()
}

internal class QuestionFactoryImpl: Formatter, @unchecked Sendable, QuestionFactory {
    
    var repository: QuestionsRepository?
    weak var delegate: QuestionFactoryDelegate?
    
    func requestNextQuestion() {
        guard let questions = repository?.getQuestions() else {
            return
        }
        
        guard let index = (0..<questions.count).randomElement() else {
            return
        }
        
        let question = questions[safe: index]
        delegate?.didReceiveNextQuestion(question: question)
    }
}
