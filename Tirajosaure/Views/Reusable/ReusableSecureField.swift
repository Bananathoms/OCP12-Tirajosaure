//
//  ReusableSecureField.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 05/06/2024.
//

import SwiftUI

struct ReusableSecureField: View {
    
    @Binding var hint: String
    let icon: String?
    let title: String
    let fieldName: String
    
    var body: some View {
        VStack(spacing:0){
            HStack{
                Text("\(title)")
                    .font(.nunitoRegular(16))
                    .foregroundColor(.oxfordBlue)
                    .padding(.leading, 30)
                    .frame(alignment: .topLeading)
                
                Spacer()
            }
        
            HStack{
                if let iconUnwraped = icon {
                    Image(systemName: "\(iconUnwraped)")
                        .font(.nunitoRegular(16))
                        .foregroundColor(.oxfordBlue)
                        .padding(.leading, 20)
                        .frame(alignment: .topLeading)
                }
               

                SecureField("\(fieldName)", text: $hint)
                    
                    .padding()
                    .foregroundColor(.oxfordBlue)

            }
            .background(Color.antiqueWhite)
            .cornerRadius(15.0)
            .padding(.horizontal, 20)
        }.padding(.vertical, 5)
    }
}

struct ReusableSecureField_Previews: PreviewProvider {
    static var previews: some View {
       
        ReusableSecureField(hint: .constant("test"), icon: "lock", title: "Mot de passe", fieldName: "mdp")
            .previewDevice("iPhone SE (3rd generation)")
            .previewDisplayName("iPhone SE")
        ReusableSecureField(hint: .constant("test"), icon: "lock", title: "Mot de passe", fieldName: "mdp")
            .previewDevice("iPhone 14 Pro")
            .previewDisplayName("iPhone 14 Pro")
    }
}
