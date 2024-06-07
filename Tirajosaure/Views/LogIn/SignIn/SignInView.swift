//
//  SignInView.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 05/06/2024.
//

import SwiftUI

struct SignInView: View {
    @ObservedObject var controller: SignInController
    
    private func makeHeader() -> some View {
        HStack{
            Text("Connexion")
                .font(.nunitoBold(20))
                .foregroundColor(.oxfordBlue)
                .padding(.all, 20)
                .frame(alignment: .topLeading)
            Spacer()
        }
    }
    
    private func newAccount() -> some View {
        NavigationLink(destination: SignUpView(controller: SignUpController())) {
            VStack{
                Text("Vous n'avez pas encore de compte?")
                    .font(.nunitoRegular(14))
                    .foregroundColor(.oxfordBlue)
                    .padding(.leading, 20)
                Text("Inscrivez-vous ici")
                    .frame(alignment: .bottom)
                    .font(.nunitoRegular(14))
                    .foregroundColor(.oxfordBlue)
                    .padding([.leading, .bottom], 20)
            }
        }
    }
    
    private func forgotPassword() -> some View {
        HStack{
            Spacer()
            Button(action: {print("")}) {
                Text("Mot de passe oublié?")
                    .font(.nunitoRegular(14))
                    .underline()
                    .foregroundColor(.oxfordBlue)
                    .padding(.trailing, 30)
                    .padding(.bottom, 25)
            }
        }
    }
    
    var body: some View {
        VStack{
            Image.logo
                .resizable()
                .frame(width: 60, height: 60)
                .padding(.top, 60)
                .padding(.bottom, 10)
            NavigationView{
                VStack{
                    makeHeader()
                    ReusableTextField(hint: $controller.email, icon: "at", title: "E-mail", fieldName: "E-mail").textContentType(.oneTimeCode)
                    ReusableSecureField(hint: $controller.password, icon: "lock", title: "Mot de passe", fieldName: "Entrez votre mot de passe").textContentType(.oneTimeCode)
                    forgotPassword()
                    TextButton(text: "Se connecter", isLoading: controller.isLoading, onClick: controller.signIn, buttonColor: .oxfordBlue, textColor: .white)
                    Spacer()
                    newAccount()
                }.background(Color.skyBlue) .ignoresSafeArea()
            }.navigationBarHidden(true).cornerRadius(20, corners: [.topLeft, .topRight])
        }.background(Color.thulianPink)
            .ignoresSafeArea()
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        let controller = SignInController()
        controller.email = "test@example.com"
        controller.password = "password"
        return Group {
            SignInView(controller: controller)
                .previewDevice("iPhone SE (3rd generation)")
                .previewDisplayName("iPhone SE")
            SignInView(controller: controller)
                .previewDevice("iPhone 14 Pro")
                .previewDisplayName("iPhone 14 Pro")
        }
    }
}
