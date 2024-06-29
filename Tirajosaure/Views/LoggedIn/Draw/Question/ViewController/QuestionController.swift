//
//  QuestionController.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 17/06/2024.
//

import Foundation
import SwiftUI
import Combine
import ParseSwift

/// A controller class responsible for managing the list of questions and their states.
/// This class provides functionality to add, update, remove, and move questions within the list.
class QuestionController: ObservableObject {
    @Published var questions: [Question] = []
    
    @Published var newQuestionTitle: String = DefaultValues.emptyString
    @Published var optionsController = OptionsController()
    
    init() {
        UserService.current.$questions
            .receive(on: RunLoop.main)
            .assign(to: &$questions)
    }
    
    /// Add a question in the list
    @discardableResult
    func addQuestion() -> Bool {
        guard let userId = UserService.current.user?.objectId else {
            SnackBarService.current.error(ErrorMessage.userIDNotFound.localized)
            return false
        }
        
        guard !newQuestionTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            SnackBarService.current.error(ErrorMessage.emptyQuestionTitle.localized)
            return false
        }
        
        let validOptions = optionsController.options.filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
        guard validOptions.count >= 2 else {
            SnackBarService.current.error(ErrorMessage.insufficientOptions.localized)
            return false
        }
        
        let userPointer = Pointer<User>(objectId: userId)
        let newQuestion = Question(
            title: newQuestionTitle,
            options: validOptions,
            user: userPointer
        )
        QuestionService.shared.saveQuestion(newQuestion) { result in
            switch result {
            case .success(let savedQuestion):
                DispatchQueue.main.async {
                    self.questions.append(savedQuestion)
                    self.newQuestionTitle = DefaultValues.emptyString
                    self.optionsController.options = []
                }
            case .failure(let error):
                SnackBarService.current.error("\(ErrorMessage.failedToSaveQuestion.localized): \(error.localizedDescription)")
            }
        }
        return true
    }
    
    /// Updates an existing question in the list.
    /// - Parameter updatedQuestion: The question containing the updated data.
    func updateQuestion(_ updatedQuestion: Question) {
        if let index = questions.firstIndex(where: { $0.id == updatedQuestion.id }) {
            let originalQuestion = questions[index]
            
            if originalQuestion != updatedQuestion {
                self.questions[index] = updatedQuestion
                
                QuestionService.shared.saveQuestion(updatedQuestion) { result in
                    switch result {
                    case .success:
                        break
                    case .failure(let error):
                        SnackBarService.current.error("\(ErrorMessage.failedToUpdateQuestion.localized): \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    /// Removes a question from the list.
    /// - Parameter offsets: The set of indices specifying the questions to be removed.
    func removeQuestion(at offsets: IndexSet) {
        offsets.forEach { index in
            let question = questions[index]
            QuestionService.shared.deleteQuestion(question) { result in
                switch result {
                case .success:
                    DispatchQueue.main.async {
                        self.questions.remove(at: index)
                    }
                case .failure(let error):
                    SnackBarService.current.error("\(ErrorMessage.failedToDeleteQuestion.localized): \(error.localizedDescription)")
                }
            }
        }
    }
    
    /// Moves a question from one position to another within the list.
    /// - Parameters:
    ///   - source: The set of indices specifying the current positions of the questions to be moved.
    ///   - destination: The index specifying the new position for the questions.
    func moveQuestion(from source: IndexSet, to destination: Int) {
        self.questions.move(fromOffsets: source, toOffset: destination)
    }
}
