//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Matvei Plokhov on 17.12.2023.
//

import Foundation
import UIKit

protocol AlertPresenter {
    func setParrentPresenter(_ parrentPresenter: UIViewController)
    func presentAlert(_ alertModel: AlertModel)
}

class AlertPresenterImpl: AlertPresenter, AlertFactoryDelegate {
    
    private var alertFactory: AlertFactory = AlertFactoryImpl()
    private weak var parrentPresenter: UIViewController?
    
    func setParrentPresenter(_ parrentPresenter: UIViewController) {
        self.parrentPresenter = parrentPresenter
    }
    
    func presentAlert(_ alertModel: AlertModel) {
        alertFactory.setDelegate(self)
        let alert = alertFactory.createNewAlert(alertModel)
        parrentPresenter?.present(alert, animated: true, completion: nil)
    }
    
    func didAlertButtonClicked(_ alertModel: AlertModel) {
        alertModel.buttonClicked()
    }
}
