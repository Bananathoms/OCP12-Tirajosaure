//
//  ResultCard.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 19/06/2024.
//

import SwiftUI
import ParseSwift

struct ResultCard: View {
    let result: DrawResult
    @ObservedObject var languageController = LanguageController.shared
    @State private var formattedDate: String = ""
    @State private var formattedTime: String = ""


    var body: some View {
        HStack {
            Text(result.option)
                .foregroundColor(.oxfordBlue)
            Spacer()
            VStack {
                Text(formattedDate)
                Text(formattedTime)
            }
            .font(.caption)
            .foregroundColor(.gray)
        }
        .background(Color.antiqueWhite)
        .cornerRadius(10)
        .onChange(of: languageController.currentLanguage) { _ in
            updateFormattedDate()
        }
        .onAppear {
            updateFormattedDate()
        }
    }

    private func updateFormattedDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: languageController.currentLanguage)

        formattedDate = dateFormatter.string(from: result.date)

        let timeFormatter = DateFormatter()
        timeFormatter.dateStyle = .none
        timeFormatter.timeStyle = .short
        timeFormatter.locale = Locale(identifier: languageController.currentLanguage)

        formattedTime = timeFormatter.string(from: result.date)
    }
}

struct ResultCard_Previews: PreviewProvider {
    static var previews: some View {
        let questionPointer = Pointer<Question>(objectId: "questionId")
        
        return ResultCard(result: DrawResult(option: "Burger", date: Date(), question: questionPointer))
    }
}
