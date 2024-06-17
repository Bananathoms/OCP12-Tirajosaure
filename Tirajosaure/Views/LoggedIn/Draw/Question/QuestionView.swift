//  QuestionView.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 15/06/2024.
//

import SwiftUI

struct QuestionView: View {
    @StateObject private var questionController = QuestionController()
    @State private var isEditing = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                CustomHeader(
                    title: LocalizedString.questionsTitle.rawValue.localized,
                    fontSize: 36,
                    showEditButton: true,
                    onEdit: {
                        withAnimation {
                            isEditing.toggle()
                        }
                    },
                    isEditing: isEditing
                )
                
                List {
                    ForEach(questionController.questions) { question in
                        QuestionItem(
                            question: question,
                            destination: {
                                QuestionDetailView(question: question, questionController: questionController)
                            }
                        )
                        .padding(.trailing)
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.antiqueWhite)
                    }
                    .onDelete(perform: questionController.removeQuestion)
                    .onMove(perform: questionController.moveQuestion)
                }
                .contentMargins(.top, 20)
                .environment(\.editMode, .constant(isEditing ? .active : .inactive))
                .scrollContentBackground(.hidden)
                
                NavigationLink(destination: AddQuestionView(questionController: questionController)) {
                    AddButton(
                        text: LocalizedString.addNewQuestion.rawValue.localized,
                        image: IconNames.plusCircleFill.systemImage,
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
}

struct QuestionView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionView()
            .previewDevice(PreviewDevices.iPhone14Pro.previewDevice)
            .previewDisplayName(PreviewDevices.iPhone14Pro.displayName)
        QuestionView()
            .previewDevice(PreviewDevices.iPhoneSE.previewDevice)
            .previewDisplayName(PreviewDevices.iPhoneSE.displayName)
    }
}

