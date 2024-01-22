//
//  MoviesLoaderTests.swift
//  MovieQuizTests
//
//  Created by Matvei Plokhov on 22.01.2024.
//

import XCTest
@testable import MovieQuiz

final class MoviesLoaderTests: XCTestCase {

    func testSuccessLoading() throws {
        let stubNetworkClient: NetworkClient = StubNetworkClientImpl(emulateError: false)
        let loader: MoviesLoader = MoviesLoaderImpl(networkClient: stubNetworkClient)

        let expectation = expectation(description: "Loading expectation")

        loader.loadMovies { result in
            switch result {
            case .success(let movies):
                XCTAssertEqual(movies.items.count, 2)
                expectation.fulfill()
            case .failure(_):
                XCTFail("Unexpected failure")
            }
        }

        waitForExpectations(timeout: 1)
    }

    func testFailureLoading() throws {
        let stubNetworkClient: NetworkClient = StubNetworkClientImpl(emulateError: true)
        let loader: MoviesLoader = MoviesLoaderImpl(networkClient: stubNetworkClient)

        let expectation = expectation(description: "Loading expectation")

        loader.loadMovies { result in
            switch result {
            case .failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            case .success(_):
                XCTFail("Unexpected failure")
            }
        }

        waitForExpectations(timeout: 1)
    }
}
