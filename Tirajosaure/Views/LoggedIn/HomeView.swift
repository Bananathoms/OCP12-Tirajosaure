//
//  HomeView.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 05/06/2024.
//

import SwiftUI

struct HomeView: View {
    
    @ObservedObject var userController: UserController

    var body: some View {
        TextButton(text: LocalizedString.logoutButton.localized, isLoading: false, onClick: UserService.current.logOut, buttonColor: .customRed, textColor: .white)
            .padding(20)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let userController = UserController()
        return Group {
            HomeView(userController: userController)
                .previewDevice(PreviewDevices.iPhone14Pro.previewDevice)
                .previewDisplayName(PreviewDevices.iPhone14Pro.displayName)
            HomeView(userController: userController)
                .previewDevice(PreviewDevices.iPhoneSE.previewDevice)
                .previewDisplayName(PreviewDevices.iPhoneSE.displayName)
        }
    }
}
