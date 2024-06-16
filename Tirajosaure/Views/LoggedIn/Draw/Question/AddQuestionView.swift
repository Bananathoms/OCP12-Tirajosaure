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
        VStack {
            CustomHeader(title: "Ajouter une question", showBackButton: true) {
                self.presentationMode.wrappedValue.dismiss()
            }.padding(.bottom)
            
            ReusableTextField(hint: $questionController.newQuestionTitle, icon: "pencil", title: "Titre de la question", fieldName: "Entrez le titre de la question")
            
            OptionsListView(controller: questionController.optionsController)
            
            TextButton(
                text: "Ajouter la question",
                isLoading: false,
                onClick: {
                    questionController.addQuestion()
                    presentationMode.wrappedValue.dismiss()
                },
                buttonColor: .antiqueWhite,
                textColor: .oxfordBlue
            )
            .padding()
            
            Spacer()
        }
        .background(Color.skyBlue)
        .navigationBarHidden(true)
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

