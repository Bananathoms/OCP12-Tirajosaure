//
//  QuestionDetailView.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 15/06/2024.
//

import SwiftUI

struct QuestionDetailView: View {
    @State var question: Question
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var optionsController = OptionsController()
    @ObservedObject var questionController: QuestionController
    
    var body: some View {
        VStack {
            CustomHeader(title: question.title, showBackButton: true) {
                presentationMode.wrappedValue.dismiss()
            }
            
            ReusableTextField(
                hint: $question.title,
                icon: nil,
                title: LocalizedString.questionTitlePlaceholder.rawValue.localized,
                fieldName: LocalizedString.enterQuestionTitle.rawValue.localized
            )
            
            OptionsListView(controller: optionsController)
            
            TextButton(
                text: LocalizedString.draw.rawValue.localized,
                isLoading: false,
                onClick: {
                    // Action for the button
                },
                buttonColor: .antiqueWhite,
                textColor: .oxfordBlue
            )
            .padding()
            
            Spacer()
        }
        .background(Color.skyBlue)
        .navigationBarHidden(true)
        .onAppear {
            loadOptions()
        }
        .onDisappear {
            saveChanges()
        }
    }
    
    private func saveChanges() {
        question.options = optionsController.options
        questionController.updateQuestion(question)
    }
    
    private func loadOptions() {
        optionsController.options = question.options
    }
}

struct QuestionDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let questionController = QuestionController()
        let sampleUserPointer = PreviewData.UserData.sampleUserPointer
        return QuestionDetailView(
            question: Question(
                title: "Que mange-t-on ce soir ?",
                options: ["Burger", "Pizza", "Fish and chips"],
                user: sampleUserPointer
            ),
            questionController: questionController
        )
    }
}

