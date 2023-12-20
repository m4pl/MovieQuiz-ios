//
//  AlertFactory.swift
//  MovieQuiz
//
//  Created by Matvei Plokhov on 17.12.2023.
//

import Foundation
import UIKit

protocol AlertFactory {
    func setDelegate(_ delegate: AlertFactoryDelegate)
    func createNewAlert(_ alert: AlertModel) -> UIAlertController
}

internal class AlertFactoryImpl: AlertFactory {
    
    private weak var delegate: AlertFactoryDelegate?
    
    func setDelegate(_ delegate: AlertFactoryDelegate) {
        self.delegate = delegate
    }
    
    func createNewAlert(_ alertModel: AlertModel) -> UIAlertController {
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(title: alertModel.buttonText, style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.didAlertButtonClicked(alertModel)
        }
        
        alert.addAction(action)
        
        return alert
    }
}

