//  DrawView.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 19/06/2024.
//

import SwiftUI
import Charts
import ParseSwift

struct DrawView: View {
    @StateObject private var drawViewController = DrawViewController()
    @StateObject private var statisticsController = StatisticsController()
    @State private var showChart: Bool = true
    @State private var showHistory: Bool = false
    @State private var showStatistics: Bool = false
    let options: [String]
    let question: Pointer<Question>

    var body: some View {
        VStack {
            HStack {
                if options.count > 1 {
                    OptionCard(option: options[drawViewController.leftOptionIndex], isSelected: false)
                }

                OptionCard(option: options[drawViewController.selectedOptionIndex], isSelected: true)

                if options.count > 2 {
                    OptionCard(option: options[drawViewController.rightOptionIndex], isSelected: false)
                }
            }
            .padding(.bottom, 20)

            List {
                Section {
                    DisclosureGroup(isExpanded: $showHistory) {
                        HistoryContent(drawViewController: drawViewController)
                    } label: {
                        Text(LocalizedString.historyTitle.localized)
                            .font(.customFont(.nunitoBold, size: 20))
                            .foregroundColor(.oxfordBlue)
                    }
                }
                .listRowBackground(Color.antiqueWhite)

                Section {
                    DisclosureGroup(isExpanded: $showStatistics) {
                        if showChart {
                            StatisticsChartView(options: options, drawResults: drawViewController.drawResults, statisticsController: statisticsController)
                        } else {
                            StatisticsListView(options: options, drawResults: drawViewController.drawResults, statisticsController: statisticsController)
                        }
                    } label: {
                        HStack {
                            Text(LocalizedString.statisticsTitle.localized)
                                .font(.customFont(.nunitoBold, size: 20))
                                .foregroundColor(.oxfordBlue)
                            Spacer()
                            Button(action: {
                                showChart.toggle()
                            }) {
                                Image(systemName: showChart ? IconNames.chartBar.rawValue : IconNames.listBullet.rawValue)
                                    .font(.title2)
                                    .foregroundColor(.oxfordBlue)
                            }
                        }
                    }
                }
                .listRowBackground(Color.antiqueWhite)
            }
            TextButton(
                text: LocalizedString.draw.localized,
                isLoading: false,
                onClick: {
                    drawViewController.startDrawing(options: options, question: question)
                },
                buttonColor: .antiqueWhite,
                textColor: .oxfordBlue
            )
        }
        .onAppear {
            drawViewController.setupInitialIndices(options: options)
            drawViewController.loadDrawResults(for: question)
        }
        .scrollContentBackground(.hidden)
        .background(Color.skyBlue)
    }
}

struct DrawView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DrawView(options: ["Burger", "Pizza"], question: Pointer<Question>(objectId: "questionId"))
                .previewDevice(PreviewDevices.iPhone14Pro.previewDevice)
                .previewDisplayName(PreviewDevices.iPhone14Pro.displayName)
            DrawView(options: ["Burger", "Pizza", "Fish and chips"], question: Pointer<Question>(objectId: "questionId"))
                .previewDevice(PreviewDevices.iPhoneSE.previewDevice)
                .previewDisplayName(PreviewDevices.iPhoneSE.displayName)
        }
    }
}
