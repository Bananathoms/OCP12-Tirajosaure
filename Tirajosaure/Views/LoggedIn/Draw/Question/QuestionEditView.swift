//  QuestionEditView.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 19/06/2024.
//

import SwiftUI

struct QuestionEditView: View {
    @Binding var question: Question
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var optionsController = OptionsController()
    
    var body: some View {
        NavigationStack {
            VStack {
                ReusableTextField(
                    hint: $question.title,
                    icon: nil,
                    title: LocalizedString.questionTitlePlaceholder.rawValue.localized,
                    fieldName: LocalizedString.enterQuestionTitle.rawValue.localized
                )
                
                OptionsListView(controller: optionsController)
                
                Spacer()
            }
            .padding(.top)
            .background(Color.skyBlue)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        saveChanges()
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        CustomHeader(title: LocalizedString.editQuestion.localized)
                    }
                }
            }
            .onAppear {
                MixpanelEvent.editQuestionButtonClicked.trackEvent()
                loadOptions()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private func saveChanges() {
        question.options = optionsController.options
    }
    
    private func loadOptions() {
        optionsController.options = question.options
    }
}

struct QuestionEditView_Previews: PreviewProvider {
    @State static var question = Question(
        title: "Que mange-t-on ce soir ?",
        options: ["Burger", "Pizza", "Fish and chips"],
        user: PreviewData.UserData.sampleUserPointer
    )
    
    static var previews: some View {
        QuestionEditView(question: $question)
    }
}
