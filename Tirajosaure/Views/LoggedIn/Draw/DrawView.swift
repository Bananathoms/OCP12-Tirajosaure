//  DrawView.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 15/06/2024.
//

import SwiftUI

struct DrawView: View {
    @State private var questions: [Question] = [
        Question(title: "Que mange-t-on ce soir ?", options: ["Burger", "Pizza", "Fish and chips", "Sushi"]),
    ]
    @State private var newQuestionTitle: String = ""
    @State private var showAddQuestion = false
    @State private var selectedQuestion: Question?
    @State private var isEditing = false
    
    var body: some View {
        NavigationView {
            VStack {
                CustomHeader(title: "Questions", fontSize: 36)
                
                Button(action: {
                    withAnimation {
                        isEditing.toggle()
                    }
                }) {
                    Text(isEditing ? "Terminer l'édition" : "Modifier les questions")
                        .font(.headline)
                        .foregroundColor(.blue)
                        .padding()
                }
                
                List {
                    ForEach(questions) { question in
                        QuestionItem(
                            question: question,
                            destination: {
                                QuestionDetailView(question: question)
                            }
                        )
                        .padding(.trailing)
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.antiqueWhite)
                    }
                    .onDelete(perform: removeQuestion)
                    .onMove(perform: moveQuestion)
                    
                }
                .environment(\.editMode, .constant(isEditing ? .active : .inactive))
                .scrollContentBackground(.hidden)
                
                NavigationLink(destination: AddQuestionView(questions: $questions)) {
                    AddButton(
                        text: "Ajouter une nouvelle question",
                        image: Image(systemName: "plus.circle.fill"),
                        buttonColor: .antiqueWhite,
                        textColor: .oxfordBlue,
                        width: 300,
                        height: 50
                    )
                    .padding()
                }
            }
            .background(Color.skyBlue)
        }
    }
    
    private func removeQuestion(at offsets: IndexSet) {
        questions.remove(atOffsets: offsets)
    }
    
    private func moveQuestion(from source: IndexSet, to destination: Int) {
        questions.move(fromOffsets: source, toOffset: destination)
    }
}

struct DrawView_Previews: PreviewProvider {
    static var previews: some View {
        DrawView()
    }
}
