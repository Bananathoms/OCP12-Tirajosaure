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
                VStack(alignment: .leading) {
                    Text(question.title)
                        .font(.headline)
                        .foregroundColor(.oxfordBlue)
                    Text(question.options.joined(separator: DefaultValues.separator))
                        .font(.subheadline)
                        .foregroundColor(.black)
                }.padding( 20)
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
