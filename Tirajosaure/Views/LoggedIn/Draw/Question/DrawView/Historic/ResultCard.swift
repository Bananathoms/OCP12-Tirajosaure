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

    var body: some View {
        HStack {
            Text(result.option)
                .foregroundColor(.oxfordBlue)
            Spacer()
            VStack {
                Text(result.date, style: .date)
                Text(result.date, style: .time)
            }
            .font(.caption)
            .foregroundColor(.gray)
        }
        .background(Color.antiqueWhite)
        .cornerRadius(10)
    }
}

struct ResultCard_Previews: PreviewProvider {
    static var previews: some View {
        let questionPointer = Pointer<Question>(objectId: "questionId")
        
        return ResultCard(result: DrawResult(option: "Burger", date: Date(), question: questionPointer))
    }
}
