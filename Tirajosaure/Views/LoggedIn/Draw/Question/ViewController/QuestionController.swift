//
//  QuestionController.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 17/06/2024.
//

import Foundation
import SwiftUI
import Combine

/// A controller class responsible for managing the list of questions and their states.
/// This class provides functionality to add, update, remove, and move questions within the list.
class QuestionController: ObservableObject {
    @Published var questions: [Question] = [
        Question(title: "Que mange-t-on ce soir ?", options: ["Burger", "Pizza", "Fish and chips", "Sushi"]),
    ]
    
    @Published var newQuestionTitle: String = DefaultValues.emptyString
    @Published var optionsController = OptionsController()
    
    /// Adds a new question to the list of questions.
    func addQuestion() {
        let newQuestion = Question(title: newQuestionTitle, options: optionsController.options.filter { !$0.isEmpty })
        self.questions.append(newQuestion)
        self.newQuestionTitle = DefaultValues.emptyString
        self.optionsController.options = []
    }
    
    /// Updates an existing question in the list.
    /// - Parameter updatedQuestion: The question containing the updated data.
    func updateQuestion(_ updatedQuestion: Question) {
        if let index = questions.firstIndex(where: { $0.id == updatedQuestion.id }) {
            self.questions[index] = updatedQuestion
        }
    }
    
    /// Removes a question from the list.
    /// - Parameter offsets: The set of indices specifying the questions to be removed.
    func removeQuestion(at offsets: IndexSet) {
        self.questions.remove(atOffsets: offsets)
    }
    
    /// Moves a question from one position to another within the list.
    /// - Parameters:
    ///   - source: The set of indices specifying the current positions of the questions to be moved.
    ///   - destination: The index specifying the new position for the questions.
    func moveQuestion(from source: IndexSet, to destination: Int) {
        self.questions.move(fromOffsets: source, toOffset: destination)
    }
}
