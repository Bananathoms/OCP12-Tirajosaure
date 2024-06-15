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
            TextField("Titre de la question", text: $newQuestionTitle)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Options (séparées par des virgules)", text: $newOptions)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: addQuestion) {
                Text("Ajouter la question")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
            
            Spacer()
        }
        .navigationTitle("Ajouter une question")
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

