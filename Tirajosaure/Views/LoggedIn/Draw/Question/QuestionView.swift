//
//  QuestionView.swift
//  Tirajosaure
//
//  Created par Thomas Carlier le 15/06/2024.
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
                questionController.isLoading ? AnyView(LoadingStateView()) : AnyView(questionListStateView)
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
                    if !questionController.questions.isEmpty {
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
            }
            .padding(.top)
            .background(Color.skyBlue)
        }
        .cornerRadius(20, corners: [.topLeft, .topRight])
        .background(Color.thulianPink)
    }
    
    private var emptyStateView: some View {
        EmptyStateView(
            title: LocalizedString.emptyQuestionsTitle.rawValue.localized,
            message: LocalizedString.emptyQuestionsMessage.rawValue.localized
        )
    }
    
    private var questionListStateView: some View {
        ReusableListStateView(
            data: questionController.questions,
            emptyView: emptyStateView,
            contentView: questionListView,
            buttonText: LocalizedString.addNewQuestion.rawValue.localized,
            buttonImage: IconNames.plusCircleFill.systemImage,
            buttonColor: .antiqueWhite,
            textColor: .oxfordBlue,
            destinationView: AddQuestionView(questionController: questionController),
            navigateToAdd: $navigateToAdd,
            buttonAction: {
                MixpanelEvent.deleteQuestionButtonClicked.trackEvent()
            }
        )
    }

    private var questionListView: some View {
        ReusableListView(
            data: questionController.questions,
            content: { question in
                QuestionItem(
                    question: question,
                    destination: {
                        QuestionDetailView(question: question, questionController: questionController)
                    }
                )
            },
            onDelete: questionController.removeQuestion,
            onMove: questionController.moveQuestion,
            isEditing: isEditing
        )
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
