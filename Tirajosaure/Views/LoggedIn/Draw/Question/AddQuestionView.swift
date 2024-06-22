//
//  AddQuestionView.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 15/06/2024.
//

import SwiftUI

struct AddQuestionView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var questionController: QuestionController
    
    var body: some View {
        NavigationStack {
            VStack {
                ReusableTextField(hint: $questionController.newQuestionTitle, icon: IconNames.pencil.rawValue, title: LocalizedString.questionTitlePlaceholder.rawValue.localized, fieldName: LocalizedString.enterQuestionTitle.rawValue.localized)
                
                OptionsListView(controller: questionController.optionsController)
                
                TextButton(
                    text: LocalizedString.addNewQuestion.rawValue.localized,
                    isLoading: false,
                    onClick: {
                        if questionController.addQuestion() {
                            presentationMode.wrappedValue.dismiss()
                        }
                    },
                    buttonColor: .antiqueWhite,
                    textColor: .oxfordBlue
                )
                .padding()
                
                Spacer()
            }
            .padding(.top)
            .background(Color.skyBlue)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        CustomHeader(title: LocalizedString.addNewQuestion.localized)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct AddQuestionView_Previews: PreviewProvider {
    static var previews: some View {
        AddQuestionView(questionController: QuestionController())
            .previewDevice(PreviewDevices.iPhone14Pro.previewDevice)
            .previewDisplayName(PreviewDevices.iPhone14Pro.displayName)
        AddQuestionView(questionController: QuestionController())
            .previewDevice(PreviewDevices.iPhoneSE.previewDevice)
            .previewDisplayName(PreviewDevices.iPhoneSE.displayName)
    }
}
