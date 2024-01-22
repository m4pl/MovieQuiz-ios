import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol, QuestionFactoryDelegate {
    
    private let presenter = MovieQuizPresenter()
    private let alertPresenter: AlertPresenter = AlertPresenterImpl()
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        presenter.initController(self)
        presenter.initQuestionFactory(self)
        alertPresenter.setParrentPresenter(self)
    }

    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        presenter.didRecieveNextQuestion(question)
    }
    
    // MARK: - QuestionFactoryDelegate
    func didLoadDataFromServer() {
        presenter.requestNextQuestion()
    }
    
    // MARK: - QuestionFactoryDelegate
    func didFailToLoadData(with error: Error) {
        presenter.showNetworkError(message: error.localizedDescription)
    }
    
    internal func show(model step: QuizStepViewModel) {
        imageView.layer.borderWidth = 0
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        noButton.isEnabled = true
        yesButton.isEnabled = true
    }
    
    internal func showAnswerResult(isCorrect: Bool) {
        let color = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        imageView.layer.borderColor = color
        imageView.layer.borderWidth = 8
        noButton.isEnabled = false
        yesButton.isEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.presenter.showNextQuestionOrResults(current: isCorrect)
        }
    }
    
    internal func presentAlert(_ alert : AlertModel){
        alertPresenter.presentAlert(alert)
    }
    
    internal func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    internal func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
}
