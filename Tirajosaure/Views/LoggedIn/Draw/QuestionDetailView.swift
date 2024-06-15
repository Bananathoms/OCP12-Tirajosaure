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

    var body: some View {
        VStack {
            TextField("Titre de la question", text: $question.title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            List {
                ForEach(question.options, id: \.self) { option in
                    Text(option)
                }
            }
            
            Spacer()
        }
        .navigationTitle(question.title)
        .navigationBarItems(trailing: Button("Done") {
            presentationMode.wrappedValue.dismiss()
        })
    }
}

struct QuestionDetailView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionDetailView(question: Question(title: "Que mange-t-on ce soir ?", options: ["Burger", "Pizza", "Fish and chips"]))
    }
}

