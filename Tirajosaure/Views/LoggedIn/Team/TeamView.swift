//
//  TeamView.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 15/06/2024.
//

import SwiftUI

struct TeamView: View {
    var body: some View {
        VStack {
            Text("Team View")
                .font(.largeTitle)
                .padding()
        }
        .background(Color.white.edgesIgnoringSafeArea(.all))
    }
}

struct TeamView_Previews: PreviewProvider {
    static var previews: some View {
        TeamView()
    }
}
