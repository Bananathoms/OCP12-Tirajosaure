//
//  StatisticsChartView.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 20/06/2024.
//

import SwiftUI
import Charts
import ParseSwift

struct StatisticsChartView: View {
    let options: [String]
    let drawResults: [DrawResult]
    let statisticsController: StatisticsController

    var body: some View {
        Chart {
            ForEach(options, id: \.self) { option in
                BarMark(
                    x: .value(LocalizedString.optionLabel.localized, option),
                    y: .value(LocalizedString.countLabel.localized, statisticsController.countOccurrences(of: option, in: drawResults))
                )
                .foregroundStyle(by: .value(LocalizedString.optionLabel.localized, option))
            }
        }
        .chartLegend(.hidden)
        .background(Color.antiqueWhite)
        .cornerRadius(10)
    }
}

struct StatisticsChartView_Previews: PreviewProvider {
    static var previews: some View {
        let questionPointer = Pointer<Question>(objectId: "questionId")
        
        return StatisticsChartView(
            options: ["Burger", "Pizza"],
            drawResults: [
                DrawResult(option: "Burger", date: Date(), question: questionPointer),
                DrawResult(option: "Pizza", date: Date(), question: questionPointer)
            ],
            statisticsController: StatisticsController()
        )
    }
}
