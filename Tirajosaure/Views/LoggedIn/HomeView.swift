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
        TextButton(text: "logout_button".localized, isLoading: false, onClick: UserService.current.logOut, buttonColor: .customRed, textColor: .white)
            .padding(20)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let userController = UserController()
        return Group {
            HomeView(userController: userController)
                .previewDevice("iPhone SE (3rd generation)")
                .previewDisplayName("iPhone SE")
            
            HomeView(userController: userController)
                .previewDevice("iPhone 14 Pro")
                .previewDisplayName("iPhone 14 Pro")
        }
    }
}
