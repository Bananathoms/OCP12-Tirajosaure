//
//  Extension+Font.swift
//  Tirajosaure
//
//  Created by Thomas Carlier on 05/06/2024.
//

import SwiftUI

extension Font {
    static func nunitoSemiBold(_ size: CGFloat = 26) -> Font {
        return .custom("Nunito-SemiBold", size: size)
    }
    static func nunitoBold(_ size: CGFloat = 26) -> Font {
        return .custom("Nunito-Bold", size: size)
    }
    static func nunitoLight(_ size: CGFloat = 26) -> Font {
        return .custom("Nunito-Light", size: size)
    }
    static func nunitoRegular(_ size: CGFloat = 26) -> Font {
        return .custom("Nunito-Regular", size: size)
    }
    static func nunitoMedium(_ size: CGFloat = 26) -> Font {
        return .custom("Nunito-Medium", size: size)
    }
}
