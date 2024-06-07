//
//  SplashView.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 05/06/2024.
//

import SwiftUI

struct SplashView: View {
    @ObservedObject var userController: UserController
    @State private var scale = 0.6
    
    var body: some View {
        ZStack{
            Color.celestialBlue.edgesIgnoringSafeArea(.all)
            Image.logo
                .resizable()
                .scaledToFit()
                .scaleEffect(scale)
                .onAppear {
                    withAnimation(Animation.easeInOut(duration: 1)
                        .repeatForever(autoreverses: true)) {
                            scale = 0.5
                        }
                }
        }
        .onAppear {
            UserService.current.splashData()
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView(userController: UserController())
    }
}
