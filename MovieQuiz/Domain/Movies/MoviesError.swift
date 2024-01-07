//
//  MoviesError.swift
//  MovieQuiz
//
//  Created by Matvei Plokhov on 07.01.2024.
//

import Foundation

enum MoviesError: Error {
    case unknown
    case noMovies
    case noPreview
}

extension MoviesError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .unknown: return NSLocalizedString("Неизвестная ошибка, попробуйте позже", comment: "")
        case .noMovies: return NSLocalizedString("Фильмы не згрузились", comment: "")
        case .noPreview: return NSLocalizedString("Изображение не згрузились", comment: "")
        }
    }
}
