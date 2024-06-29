//  QuestionView.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 15/06/2024.
//

import SwiftUI

struct QuestionView: View {
    @StateObject private var questionController = QuestionController()
    @State private var isEditing = false
    @State private var navigateToAdd = false
    @State private var selectedQuestion: Question?
    
    var body: some View {
        NavigationStack {
            VStack {
                if questionController.questions.isEmpty {
                    emptyStateView
                } else {
                    questionListView
                }
                Button(action: {
                    navigateToAdd.toggle()
                }) {
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
                .navigationDestination(isPresented: $navigateToAdd) {
                    AddQuestionView(questionController: questionController)
                }
            }
            .frame(maxWidth: .infinity)
            .background(Color.skyBlue)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    CustomHeader(title: LocalizedString.questionsTitle.localized, showBackButton: false, fontSize: 36)
                        .padding(.vertical)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        withAnimation {
                            isEditing.toggle()
                        }
                    }) {
                        Image(systemName: isEditing ? IconNames.checkmarkCircleFill.rawValue : IconNames.pencilCircleFill.rawValue)
                            .resizable()
                            .frame(width: 30, height: 30)
                            .padding(.top)
                            .foregroundColor(.oxfordBlue)
                    }
                }
            }
            .padding(.top)
            .background(Color.skyBlue)
        }
        .cornerRadius(20, corners: [.topLeft, .topRight])
        .background(Color.thulianPink)
    }
    
    private var emptyStateView: some View {
        VStack {
            Text(LocalizedString.emptyQuestionsTitle.rawValue.localized)
                .font(.customFont(.nunitoBold, size: 20))
                .foregroundColor(.gray)
                .padding(.top, 40)
            Text(LocalizedString.emptyQuestionsMessage.rawValue.localized)
                .font(.customFont(.nunitoRegular, size: 16))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding([.leading, .trailing], 20)
                .padding(.top, 10)
            Spacer()
        }
    }
    
    private var questionListView: some View {
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
        .contentMargins(.top, 24)
        .environment(\.editMode, .constant(isEditing ? .active : .inactive))
        .scrollContentBackground(.hidden)
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
