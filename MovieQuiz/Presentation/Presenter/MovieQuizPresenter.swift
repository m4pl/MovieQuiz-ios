//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Matvei Plokhov on 22.01.2024.
//

import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    
    weak var viewController: MovieQuizViewControllerProtocol?
    
    private var quizResultsFactory: QuizResultsFactory = {
        let quizResultsFactory = QuizResultsFactoryImpl()
        quizResultsFactory.setService(StatisticServiceImpl())
        return quizResultsFactory
    }()
    private var questionFactory: QuestionFactory = {
        let questionFactory = QuestionFactoryImpl()
        let questionsRepository = QuestionsRepositoryImpl()
        let moviesLoader = MoviesLoaderImpl()
        questionsRepository.setMoviesLoader(moviesLoader)
        questionFactory.setRepository(questionsRepository)
        return questionFactory
    }()
    
    private var currentQuestion: QuizQuestion?
    private let questionsAmount: Int = 10
    private var correctAnswers = 0
    private var currentQuestionIndex: Int = 0
    
    internal func initController(_ viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        viewController.showLoadingIndicator()
        questionFactory.setDelegate(self)
        questionFactory.loadData()
    }
    
    // MARK: - QuestionFactoryDelegate
    internal func didReceiveNextQuestion(question: QuizQuestion?) {
        didRecieveNextQuestion(question)
    }
    
    // MARK: - QuestionFactoryDelegate
    internal func didLoadDataFromServer() {
        requestNextQuestion()
    }
    
    // MARK: - QuestionFactoryDelegate
    internal func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    internal func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    
    internal func noButtonClicked() {
        didAnswer(isYes: false)
    }
    
    internal func didRecieveNextQuestion(_ question: QuizQuestion?) {
        guard let question = question else { return }
        
        currentQuestion = question
        let viewModel = convert(question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.hideLoadingIndicator()
            self?.viewController?.show(model: viewModel)
        }
    }
    
    internal func requestNextQuestion() {
        viewController?.showLoadingIndicator()
        questionFactory.requestNextQuestion()
    }
    
    internal func showNextQuestionOrResults(current isCorrect: Bool) {
        if (isCorrect) {
            correctAnswers += 1
        }
        
        if currentQuestionIndex == questionsAmount - 1 {
            guard let viewModel = quizResultsFactory.getQuizResults(
                correct: correctAnswers,
                total: questionsAmount
            ) else { return }
            
            let alert = AlertModel(
                title: viewModel.title,
                message: viewModel.text,
                buttonText: viewModel.buttonText
            ) { [weak self] in
                guard let self = self else { return }
                
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                self.requestNextQuestion()
            }
            
            viewController?.presentAlert(alert)
        } else {
            currentQuestionIndex += 1
            requestNextQuestion()
        }
    }
    
    internal func showNetworkError(message: String) {
        viewController?.hideLoadingIndicator()
        
        let alert = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать еще раз"
        ) { [weak self] in
            guard let self = self else { return }
            
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            self.viewController?.showLoadingIndicator()
            self.questionFactory.loadData()
        }
        
        viewController?.presentAlert(alert)
    }
    
    internal func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else { return }
        
        let givenAnswer = isYes
        
        viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    internal func convert(_ model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
    }
}
