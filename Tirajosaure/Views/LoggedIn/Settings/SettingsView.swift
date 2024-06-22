//
//  SettingsView.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 15/06/2024.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        VStack {
            Text("Settings View")
                .font(.largeTitle)
                .padding()

            TextButton(text: LocalizedString.logoutButton.localized, isLoading: false, onClick: {
                UserService.current.logOut()
                self.presentationMode.wrappedValue.dismiss()
            }, buttonColor: .customRed, textColor: .white)
                .padding()
        }
        .background(Color.white.edgesIgnoringSafeArea(.all))
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
