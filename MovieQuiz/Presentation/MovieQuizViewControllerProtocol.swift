//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Matvei Plokhov on 23.01.2024.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(model step: QuizStepViewModel)
    func showAnswerResult(isCorrect: Bool)
    
    func presentAlert(_ alert : AlertModel)
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
}
