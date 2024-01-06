//
//  QuestionsRepository.swift
//  MovieQuiz
//
//  Created by Matvei Plokhov on 15.12.2023.
//

import Foundation

protocol QuestionsRepository {
    func setMoviesLoader(_ moviesLoader: MoviesLoader)
    func loadData(onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void)
    func getMovies() -> [MostPopularMovie]?
}

internal class QuestionsRepositoryImpl: QuestionsRepository {
    
    private var moviesLoader: MoviesLoader?
    
    private var movies: [MostPopularMovie] = []
    
    func setMoviesLoader(_ moviesLoader: MoviesLoader) {
        self.moviesLoader = moviesLoader
    }
    
    func loadData(onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void) {
        moviesLoader?.loadMovies { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    
                    if (mostPopularMovies.errorMessage.isEmpty) {
                        onSuccess()
                    } else {
                        onFailure(MoviesError.unknown)
                    }
                case .failure(let error):
                    onFailure(error)
                }
            }
        }
    }
    
    func getMovies() -> [MostPopularMovie]? {
        if(movies.isEmpty) {
            return nil
        }
        
        return movies
    }
}
