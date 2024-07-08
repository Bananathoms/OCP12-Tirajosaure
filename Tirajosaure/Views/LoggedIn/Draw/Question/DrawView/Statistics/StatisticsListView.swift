//  StatisticsListView.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 20/06/2024.
//

import SwiftUI
import ParseSwift

struct StatisticsListView: View {
    let options: [String]
    let drawResults: [DrawResult]
    let statisticsController: StatisticsController

    var body: some View {
        let statistics = statisticsController.getStatistics(for: options, in: drawResults)
        
        Group {
            StatisticsResultCard(statistics: OptionStatistics(option: LocalizedString.totalDraw.localized, count: drawResults.count, percentage: 100))
                .padding(.trailing)
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.antiqueWhite)

            ForEach(statistics, id: \.option) { stat in
                StatisticsResultCard(statistics: stat)
                    .padding(.trailing)
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.antiqueWhite)
            }
        }
    }
}

struct StatisticsListView_Previews: PreviewProvider {
    static var previews: some View {
        let questionPointer = Pointer<Question>(objectId: "questionId")
        
        return StatisticsListView(
            options: ["Burger", "Pizza"],
            drawResults: [
                DrawResult(option: "Burger", date: Date(), question: questionPointer),
                DrawResult(option: "Pizza", date: Date(), question: questionPointer)
            ],
            statisticsController: StatisticsController()
        )
    }
}
