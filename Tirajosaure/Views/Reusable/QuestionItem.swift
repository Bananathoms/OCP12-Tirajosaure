//
//  QuestionItem.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 16/06/2024.
//

import SwiftUI

struct QuestionItem<Destination: View>: View {
    var question: Question
    var destination: () -> Destination

    var body: some View {
        NavigationLink(destination: destination()) {
            HStack {
                Image(systemName: "questionmark.circle.fill")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.blue)
                    .padding(.leading, 10)
                    .padding(.vertical)
                
                VStack(alignment: .leading) {
                    Text(question.title)
                        .font(.headline)
                        .foregroundColor(.oxfordBlue)
                    Text(question.options.joined(separator: ", "))
                        .font(.subheadline)
                        .foregroundColor(.black)
                }
                Spacer()
            }
            .background(Color.antiqueWhite)
            .cornerRadius(10)
        }.frame(height: 60)
    }
}

struct QuestionItem_Previews: PreviewProvider {
    static var previews: some View {
        QuestionItem(
            question: Question(title: "Que mange-t-on ce soir ?", options: ["🍔 Burger", "🍕 Pizza", "🐟 Fish and chips"]),
            destination: { Text("Detail View") }
        )
    }
}
