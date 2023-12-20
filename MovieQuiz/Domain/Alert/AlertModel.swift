//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Matvei Plokhov on 17.12.2023.
//

import Foundation

internal struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let buttonClicked: () -> Void
}
