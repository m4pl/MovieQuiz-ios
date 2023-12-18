//
//  AlertFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Matvei Plokhov on 17.12.2023.
//

import Foundation

protocol AlertFactoryDelegate: AnyObject {
    func didAlertButtonClicked(_ alert: AlertModel)
}
