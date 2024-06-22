//
//  ReusableTextField.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 05/06/2024.
//

import SwiftUI

struct ReusableTextField: View {
    @Binding var hint: String
    let icon: String?
    let title: String
    let fieldName: String
    
    var body: some View {
        VStack{
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
                TextField("\(fieldName)", text: $hint)
                    .padding()
                    .foregroundColor(.oxfordBlue)
            }
            .background(Color.antiqueWhite)
            .cornerRadius(15.0)
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 5)
    }
}

struct ReusableTextField_Previews: PreviewProvider {
    static var previews: some View {
        ReusableTextField(
            hint: PreviewData.TextFieldData.email.hint,
            icon: PreviewData.TextFieldData.email.icon,
            title: PreviewData.TextFieldData.email.title,
            fieldName: PreviewData.TextFieldData.email.fieldName
        )
            .previewDevice(PreviewDevices.iPhone14Pro.previewDevice)
            .previewDisplayName(PreviewDevices.iPhone14Pro.displayName)
        ReusableTextField(
            hint: PreviewData.TextFieldData.email.hint,
            icon: PreviewData.TextFieldData.email.icon,
            title: PreviewData.TextFieldData.email.title,
            fieldName: PreviewData.TextFieldData.email.fieldName
        )
            .previewDevice(PreviewDevices.iPhoneSE.previewDevice)
            .previewDisplayName(PreviewDevices.iPhoneSE.displayName)
    }
}
