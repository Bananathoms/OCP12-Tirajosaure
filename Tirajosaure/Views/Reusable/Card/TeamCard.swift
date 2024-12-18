//
//  TeamCard.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 28/06/2024.
//

import SwiftUI

struct TeamCard: View {
    let name: String
    let members: [String]
    
    var body: some View {
        VStack(alignment: .center) {
            Text(name)
                .foregroundColor(.oxfordBlue)
                .font(.title2)
                .minimumScaleFactor(0.5)
                .lineLimit(1)
                .frame(width: 120)
                .background(.antiqueWhite)
            ForEach(members, id: \.self) { member in
                MemberCard(member: member)
            }
        }
        .padding(10)
        .background(Color.antiqueWhite)
        .cornerRadius(10)
        .shadow(radius: 5)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(.oxfordBlue, lineWidth: 2)
        )
    }
}

struct TeamCard_Previews: PreviewProvider {
    static var previews: some View {
        
        TeamCard(name: "Équipe 1", members: ["Membre 1", "Membre 2"])
        
    }
}

