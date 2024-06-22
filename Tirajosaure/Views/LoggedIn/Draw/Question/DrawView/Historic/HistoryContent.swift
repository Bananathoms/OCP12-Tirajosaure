//
//  HistoryContent.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 20/06/2024.
//

import SwiftUI

struct HistoryContent: View {
    @ObservedObject var drawViewController: DrawViewController

    var body: some View {
        Group {
            if drawViewController.drawResults.isEmpty {
                HStack {
                    Text(LocalizedString.noResultsYet.localized)
                        .foregroundColor(.gray)
                }
                .listRowBackground(Color.antiqueWhite)
            } else {
                ForEach(drawViewController.drawResults) { result in
                    ResultCard(result: result)
                        .padding(.trailing)
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.antiqueWhite)
                }
            }
        }
    }
}

struct HistoryContent_Previews: PreviewProvider {
    static var previews: some View {
        HistoryContent(drawViewController: DrawViewController())
    }
}
