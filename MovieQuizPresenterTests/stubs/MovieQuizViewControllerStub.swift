//
//  MovieQuizViewControllerStub.swift
//  MovieQuizPresenterTests
//
//  Created by Matvei Plokhov on 23.01.2024.
//

@testable import MovieQuiz

final class MovieQuizViewControllerStub: MovieQuizViewControllerProtocol {
    
    func show(model step: QuizStepViewModel) {
        
    }
    
    func showAnswerResult(isCorrect: Bool) {
        
    }
    
    func presentAlert(_ alert : AlertModel) {
        
    }
    
    func showLoadingIndicator() {
        
    }
    
    func hideLoadingIndicator() {
        
    }
}
