//
//  MovieQuizPresenterTests.swift
//  MovieQuizPresenterTests
//
//  Created by Matvei Plokhov on 23.01.2024.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizPresenterTests: XCTestCase {
    
    func testPresenterConvertModel() throws {
        let viewControllerStub = MovieQuizViewControllerStub()
        let sut = MovieQuizPresenter()
        sut.initController(viewControllerStub)
        
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
        let viewModel = sut.convert(question)
        
        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}
