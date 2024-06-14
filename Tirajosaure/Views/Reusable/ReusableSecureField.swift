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
                    .font(.customFont(.nunitoRegular, size: 16))
                    .foregroundColor(.oxfordBlue)
                    .padding(.leading, 30)
                    .padding(.bottom, 5)
                    .frame(alignment: .topLeading)
                
                Spacer()
            }
        
            HStack{
                if let iconUnwraped = icon {
                    Image(systemName: "\(iconUnwraped)")
                        .font(.customFont(.nunitoRegular, size: 16))
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
       
        ReusableSecureField(
            hint: PreviewData.SecureFieldData.withHint.hint,
            icon: PreviewData.SecureFieldData.withHint.icon,
            title: PreviewData.SecureFieldData.withHint.title,
            fieldName: PreviewData.SecureFieldData.withHint.fieldName
        )
            .previewDevice(PreviewDevices.iPhone14Pro.previewDevice)
            .previewDisplayName(PreviewDevices.iPhone14Pro.displayName)
        ReusableSecureField(
            hint: PreviewData.SecureFieldData.withHint.hint,
            icon: PreviewData.SecureFieldData.withHint.icon,
            title: PreviewData.SecureFieldData.withHint.title,
            fieldName: PreviewData.SecureFieldData.withHint.fieldName
        )
            .previewDevice(PreviewDevices.iPhoneSE.previewDevice)
            .previewDisplayName(PreviewDevices.iPhoneSE.displayName)
    }
}
