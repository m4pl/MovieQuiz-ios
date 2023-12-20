import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var yesButton: UIButton!
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private let questionsAmount: Int = 5
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenter?
    private var questionFactory: QuestionFactory = {
        let questionFactory = QuestionFactoryImpl()
        questionFactory.setRepository(QuestionsRepositoryImpl())
        return questionFactory
    }()
    private var quizResultsFactory: QuizResultsFactory = {
        let quizResultsFactory = QuizResultsFactoryImpl()
        quizResultsFactory.setService(StatisticServiceImpl())
        return quizResultsFactory
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        questionFactory.setDelegate(self)
        questionFactory.requestNextQuestion()
    }
    
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        
        currentQuestion = question
        let viewModel = convert(question)
        DispatchQueue.main.async { [weak self] in
            self?.show(model: viewModel)
        }
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else { return }
        showAnswerResult(isCorrect: currentQuestion.correctAnswer == true)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {  return }
        showAnswerResult(isCorrect: currentQuestion.correctAnswer == false)
    }
    
    private func show(model step: QuizStepViewModel) {
        imageView.layer.borderWidth = 0
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        noButton.isEnabled = true
        yesButton.isEnabled = true
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        alertPresenter = AlertPresenterImpl()
        alertPresenter?.setParrentPresenter(self)

        let alert = AlertModel(
            title: result.title,
            message: result.text,
            buttonText: result.buttonText
        ) { [weak self] in
            guard let self = self else { return }
            
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            self.questionFactory.requestNextQuestion()
        }
        
        alertPresenter?.presentAlert(alert)
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        let color = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        imageView.layer.borderColor = color
        imageView.layer.borderWidth = 8
        noButton.isEnabled = false
        yesButton.isEnabled = false
        
        if (isCorrect) {
            correctAnswers += 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            guard let viewModel = quizResultsFactory.getQuizResults(correct: correctAnswers, total: questionsAmount) else { return }
            show(quiz: viewModel)
        } else {
            currentQuestionIndex += 1
            questionFactory.requestNextQuestion()
        }
    }
    
    private func convert(_ model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
        return questionStep
    }
}
