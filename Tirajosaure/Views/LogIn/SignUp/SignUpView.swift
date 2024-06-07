//
//  SignUpView.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 05/06/2024.
//

import SwiftUI

struct SignUpView: View {
    @ObservedObject var controller: SignUpController
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    private func makeHeader() -> some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack{
                Image(systemName: "chevron.backward")
                    .foregroundColor(.oxfordBlue)
                    .padding(.leading, 20)
                Text("signup_title".localized)
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
                ReusableTextField(hint: $controller.firstName, icon: nil, title: "first_name".localized, fieldName: "first_name".localized).textContentType(.oneTimeCode)
                ReusableTextField(hint: $controller.lastName, icon: nil, title: "last_name".localized, fieldName: "last_name".localized).textContentType(.oneTimeCode)
                ReusableTextField(hint: $controller.email, icon: nil, title: "email".localized, fieldName: "email".localized).textContentType(.oneTimeCode)
                ReusableSecureField(hint: $controller.password, icon: nil, title: "password".localized, fieldName: "enter_your_password".localized).textContentType(.oneTimeCode)
                ReusableSecureField(hint: $controller.confirmPwd, icon: nil, title: "confirm_password".localized, fieldName: "confirm_your_password".localized).textContentType(.oneTimeCode)
                TextButton(text: "continue_button".localized, isLoading: controller.isLoading, onClick: {
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

