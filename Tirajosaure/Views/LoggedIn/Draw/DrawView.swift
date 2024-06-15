//
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
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(questions) { question in
                        NavigationLink(destination: QuestionDetailView(question: question)) {
                            HStack {
                                Image(systemName: "questionmark.circle")
                                    .foregroundColor(.blue)
                                VStack(alignment: .leading) {
                                    Text(question.title)
                                        .font(.headline)
                                    Text(question.options.joined(separator: ", "))
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.blue)
                            }
                            .padding(.vertical, 5)
                        }
                    }
                    .onDelete(perform: removeQuestion)
                }
                
                NavigationLink(destination: AddQuestionView(questions: $questions)) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Ajouter une nouvelle question")
                    }
                    .font(.headline)
                    .foregroundColor(.blue)
                    .padding()
                }
            }
            .navigationTitle("Questions")
        }
    }
    
    private func removeQuestion(at offsets: IndexSet) {
        questions.remove(atOffsets: offsets)
    }
}

struct DrawView_Previews: PreviewProvider {
    static var previews: some View {
        DrawView()
    }
}


