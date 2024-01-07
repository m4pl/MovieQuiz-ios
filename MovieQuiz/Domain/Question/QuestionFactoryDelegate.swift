//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Matvei Plokhov on 17.12.2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
}
