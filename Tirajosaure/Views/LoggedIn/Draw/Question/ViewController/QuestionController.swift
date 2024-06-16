//
//  QuestionController.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 17/06/2024.
//

import Foundation
import SwiftUI
import Combine

import SwiftUI
import Combine

class QuestionController: ObservableObject {
    @Published var questions: [Question] = [
        Question(title: "Que mange-t-on ce soir ?", options: ["Burger", "Pizza", "Fish and chips", "Sushi"]),
    ]
    
    @Published var newQuestionTitle: String = ""
    @Published var optionsController = OptionsController()
    
    func addQuestion() {
        let newQuestion = Question(title: newQuestionTitle, options: optionsController.options.filter { !$0.isEmpty })
        questions.append(newQuestion)
        newQuestionTitle = ""
        optionsController.options = []
    }
    
    func removeQuestion(at offsets: IndexSet) {
        questions.remove(atOffsets: offsets)
    }
    
    func moveQuestion(from source: IndexSet, to destination: Int) {
        questions.move(fromOffsets: source, toOffset: destination)
    }
}
