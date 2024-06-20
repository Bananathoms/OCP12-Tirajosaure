//  StatisticsResultCard.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 20/06/2024.
//

import SwiftUI

struct StatisticsResultCard: View {
    let statistics: OptionStatistics

    let columns = [
        GridItem(.flexible(), alignment: .leading),
        GridItem(.flexible(), alignment: .center),
        GridItem(.flexible(), alignment: .trailing)
    ]

    var body: some View {
        LazyVGrid(columns: columns, alignment: .center) {
            Text(statistics.option)
                .font(.headline)
                .foregroundColor(.oxfordBlue)
                .multilineTextAlignment(.center)

            Text("\(statistics.count) \(LocalizedString.drawsLabel.localized)")
                .foregroundColor(.oxfordBlue)
                .multilineTextAlignment(.center)

            Text(String(format: Format.percent.key, statistics.percentage))
                .foregroundColor(.oxfordBlue)
                .multilineTextAlignment(.center)
        }
        .background(Color.antiqueWhite)
        .cornerRadius(10)
    }
}

struct StatisticsResultCard_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsResultCard(statistics: OptionStatistics(option: "Burger", count: 10, percentage: 10.0))
    }
}
