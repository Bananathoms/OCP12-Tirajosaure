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
    @State private var isEditing = false
    
    var body: some View {
        NavigationStack {
            VStack {
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
            .frame(maxWidth: .infinity)
            .background(Color.skyBlue)
            .onAppear {
                loadOptions()
            }
            .onDisappear {
                saveChanges()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        CustomHeader(title: question.title)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: QuestionEditView(question: $question)) {
                        Image(systemName: IconNames.pencilCircleFill.rawValue)
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.oxfordBlue)
                            .padding(.leading, 5)
                            .padding(.top)
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
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

