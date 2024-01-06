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
    func loadData()
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
    
    func loadData() {
        repository?.loadData(
            onSuccess: { [weak self] in
                self?.delegate?.didLoadDataFromServer()
            },
            onFailure: {[weak self] error in
                self?.delegate?.didFailToLoadData(with: error)
            }
        )
    }
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            
            guard let movies = repository?.getMovies() else {
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.didFailToLoadData(with: MoviesError.noMovies)
                }
                return
            }
            
            let index = (0..<movies.count).randomElement() ?? 0
            
            guard let movie = movies[safe: index] else { return }
            
            var imageData = Data()
            
            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
            } catch {
                print("Failed to load image")
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.didFailToLoadData(with: MoviesError.noPreview)
                }
            }
            
            let rating = Float(movie.rating) ?? 0
            
            let text = "Рейтинг этого фильма больше чем 7?"
            let correctAnswer = rating > 7
            
            let question = QuizQuestion(
                image: imageData,
                text: text,
                correctAnswer: correctAnswer
            )
            
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }
}
