//
//  MemberCard.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 28/06/2024.
//

//
//  TeamCard.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 28/06/2024.
//

import SwiftUI

struct MemberCard: View {
    let member: String

    var body: some View {
        Text(member)
            .foregroundColor(.oxfordBlue)
            .minimumScaleFactor(0.5)
            .lineLimit(1)
            .padding(5)
            .frame(width:  100 , height:  50 )
            .background(.antiqueWhite )
            .cornerRadius(10 )
            .shadow(radius: 5)
            .overlay(
                RoundedRectangle(cornerRadius:  10 )
                    .stroke(Color.oxfordBlue, lineWidth: 2)
            )
    }
}

struct MemberCard_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MemberCard(member: "Member")
        }
    }
}
