//
//  AddQuestionView.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 15/06/2024.
//

import SwiftUI

struct AddQuestionView: View {
    @Binding var questions: [Question]
    @Environment(\.presentationMode) var presentationMode
    
    @State private var newQuestionTitle: String = ""
    @State private var newOptions: String = ""
    
    var body: some View {
        VStack {
            CustomHeader(title: "Ajouter une question", showBackButton: true) {
                self.presentationMode.wrappedValue.dismiss()
            }.padding(.bottom)
            
            ReusableTextField(hint: $newQuestionTitle, icon: "pencil", title: "Titre de la question", fieldName: "Entrez le titre de la question")

            
            ReusableTextField(hint: $newOptions, icon: "list.bullet", title: "Options (séparées par des virgules)", fieldName: "Entrez les options")

            
            TextButton(
                text: "Ajouter la question",
                isLoading: false,
                onClick: addQuestion,
                buttonColor: .antiqueWhite,
                textColor: .oxfordBlue
            )
            
            Spacer()
        }
        .background(Color.skyBlue)
        .navigationBarHidden(true)
    }
    
    private func addQuestion() {
        let optionsArray = newOptions.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        let newQuestion = Question(title: newQuestionTitle, options: optionsArray)
        questions.append(newQuestion)
        presentationMode.wrappedValue.dismiss()
    }
}

struct AddQuestionView_Previews: PreviewProvider {
    static var previews: some View {
        AddQuestionView(questions: .constant([]))
    }
}


