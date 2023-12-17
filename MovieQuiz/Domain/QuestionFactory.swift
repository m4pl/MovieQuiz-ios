//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Matvei Plokhov on 15.12.2023.
//

import Foundation

protocol QuestionFactory {
    func setRepository(_ repository: QuestionsRepository)
    func setDelegate(_ delegate: QuestionFactoryDelegate)
    func requestNextQuestion()
}

internal class QuestionFactoryImpl: QuestionFactory {
    
    private var repository: QuestionsRepository?
    private weak var delegate: QuestionFactoryDelegate?
    
    func setRepository(_ repository: QuestionsRepository) {
        self.repository = repository
    }
    
    func setDelegate(_ delegate: QuestionFactoryDelegate) {
        self.delegate = delegate
    }
    
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
