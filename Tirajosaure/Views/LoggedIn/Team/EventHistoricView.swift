//
//  EventHistoricView.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 28/06/2024.
//

import SwiftUI
import ParseSwift

struct EventHistoricView: View {
    @StateObject private var controller = EventHistoricController()
    @State var event: Event
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView {
                    VStack {
                        if controller.isLoading {
                            loadingView()
                        } else if controller.teamsDraws.isEmpty {
                            emptyView()
                        } else {
                            drawsListView()
                        }
                    }
                    .frame(width: geometry.size.width)
                }
                .background(Color.skyBlue)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        CustomHeader(title: LocalizedString.history.localized)
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            .onAppear {
                controller.loadHistoricData(for: event)
            }
        }
    }
    
    private func loadingView() -> some View {
        ProgressView(LocalizedString.loading.localized)
            .padding()
    }
    
    private func emptyView() -> some View {
        Text(LocalizedString.noDrawFound.localized)
            .font(.customFont(.nunitoBold, size: 20))
            .foregroundColor(.gray)
            .padding(.top, 40)
    }
    
    private func drawsListView() -> some View {
        LazyVStack(spacing: 20) {
            ForEach(controller.teamsDraws) { draw in
                drawDisclosureGroup(draw: draw)
            }
        }
        .padding()
    }
    
    private func drawDisclosureGroup(draw: TeamsDraw) -> some View {
        DisclosureGroup("\(LocalizedString.drawOn.localized) \(draw.dateFormatted)") {
            if draw.teamResults.isEmpty {
                Text(LocalizedString.noDrawFound.localized)
                    .onAppear {
                        controller.loadTeamResults(for: draw)
                    }
            } else {
                ForEach(draw.teamResults.indices, id: \.self) { index in
                    let teamResult = draw.teamResults[index]
                    teamResultDisclosureGroup(teamResult: teamResult)
                }
            }
        }
        .padding()
        .foregroundColor(.oxfordBlue)
        .background(.antiqueWhite)
        .cornerRadius(10)
        .padding(.horizontal)
    }
    
    private func teamResultDisclosureGroup(teamResult: TeamResult) -> some View {
        DisclosureGroup(teamResult.name) {
            VStack(alignment: .leading) {
                ForEach(teamResult.members, id: \.self) { member in
                    Text(member)
                        .padding(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .padding(.leading)
    }
}

struct EventHistoricView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EventHistoricView(
                event: Event(
                    title: "Tournoi de foot",
                    user: Pointer<User>(objectId: "sampleUserId"),
                    equitableDistribution: true,
                    teams: ["Équipe 1", "Équipe 2"],
                    members: ["Membre 1", "Membre 2"]
                )
            )
        }
    }
}
