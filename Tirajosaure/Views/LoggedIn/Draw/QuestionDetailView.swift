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
    @State private var newOption: String = ""
    
    private func addOption() {
        if !newOption.isEmpty {
            question.options.append(newOption)
            newOption = ""
        }
    }
    
    private func removeOption(_ option: String) {
        question.options.removeAll { $0 == option }
    }
    
    private func moveOption(from source: IndexSet, to destination: Int) {
        question.options.move(fromOffsets: source, toOffset: destination)
    }
    
    var body: some View {
        VStack {
            CustomHeader(title: question.title, showBackButton: true) {
                presentationMode.wrappedValue.dismiss()
            }
            
            ReusableTextField(
                hint: $question.title,
                icon: nil,
                title: "Titre de la question",
                fieldName: "Titre de la question"
            )
            
            VStack{

                
                List {
                    HStack {
                        Button(action: {
                            addOption()
                        }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(.green)
                                Text("Ajouter un élément")
                                    .foregroundColor(.black)
                            }
                            .padding(.vertical, 10)
                            .padding(.horizontal)
                            .background(Color.antiqueWhite)
                            .cornerRadius(10)
                        }
                        Spacer()
                    }
                    .listRowBackground(Color.antiqueWhite)
                    ForEach(question.options, id: \.self) { option in
                        HStack {
                            Button(action: {
                                removeOption(option)
                            }) {
                                Image(systemName: "minus.circle.fill")
                                    .foregroundColor(.red)
                            }
                            Text(option)
                        }.listRowBackground(Color.antiqueWhite)
                    }
                    .onMove(perform: moveOption)
                }.scrollContentBackground(.hidden)
                    .listStyle(InsetGroupedListStyle())
                    .environment(\.editMode, .constant(.active))
            }.background(Color.skyBlue)
            
            TextButton(
                text: "Tirage",
                isLoading: false,
                onClick: {
                    
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

struct QuestionDetailView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionDetailView(question: Question(title: "Que mange-t-on ce soir ?", options: ["Burger", "Pizza", "Fish and chips"]))
    }
}


