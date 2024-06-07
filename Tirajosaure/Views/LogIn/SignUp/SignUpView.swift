//
//  SignUpView.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 05/06/2024.
//

import SwiftUI

/// <#Description#>
struct SignUpView: View {
    @ObservedObject var controller: SignUpController
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    /// <#Description#>
    /// - Returns: <#description#>
    private func makeHeader() -> some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack{
                Image(systemName: "chevron.backward")
                    .foregroundColor(.oxfordBlue)
                    .padding(.leading, 20)
                Text("Inscription")
                    .font(.nunitoBold(20))
                    .foregroundColor(.oxfordBlue)
                    .padding([.top, .bottom, .trailing], 20)
                    .frame(alignment: .topLeading)
                Spacer()
            }
        }
    }
    
    var body: some View {
        VStack{
            self.makeHeader()
            ScrollView{
                ReusableTextField(hint: $controller.firstName, icon: nil, title: "Prénom", fieldName: "Prénom").textContentType(.oneTimeCode)
                ReusableTextField(hint: $controller.lastName  , icon: nil, title: "Nom", fieldName: "Nom").textContentType(.oneTimeCode)
                ReusableTextField(hint: $controller.email, icon: nil, title: "E-mail", fieldName: "E-mail").textContentType(.oneTimeCode)
                ReusableSecureField(hint: $controller.password, icon: nil, title: "Mot de passe", fieldName: "Entrez votre mot de passe").textContentType(.oneTimeCode)
                ReusableSecureField(hint: $controller.confirmPwd, icon: nil, title: "Confirmation mot de passe", fieldName: "Confirmez votre mot de passe").textContentType(.oneTimeCode)
                TextButton(text: "Continuer", isLoading: controller.isLoading, onClick: {
                    controller.signUp()
                }, buttonColor: .oxfordBlue, textColor: .antiqueWhite)
                Spacer()
            }
        }.background(Color.skyBlue)
            .cornerRadius(20, corners: [.topLeft, .topRight])
            .ignoresSafeArea()
            .navigationBarHidden(true)
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        let controller = SignUpController()
        controller.email = "test@example.com"
        controller.firstName = "John"
        controller.lastName = "Doe"
        controller.password = "Password123"
        controller.confirmPwd = "Password123"
        return Group {
            SignUpView(controller: controller)
                .previewDevice("iPhone SE (3rd generation)")
                .previewDisplayName("iPhone SE")
            SignUpView(controller: controller)
                .previewDevice("iPhone 14 Pro")
                .previewDisplayName("iPhone 14 Pro")
        }
    }
}

