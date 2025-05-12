//
//  extensionFont.swift
//  Harmonya
//
//  Created by Klesya on 5/12/25.
//

import SwiftUI

extension Font {
    enum PlayfairDisplaySC {
        static func regular(size: CGFloat) -> Font {
            .custom("PlayfairDisplaySC-Regular", size: size)
        }

        static func italic(size: CGFloat) -> Font {
            .custom("PlayfairDisplaySC-Italic", size: size)
        }

        static func bold(size: CGFloat) -> Font {
            .custom("PlayfairDisplaySC-Bold", size: size)
        }

        static func boldItalic(size: CGFloat) -> Font {
            .custom("PlayfairDisplaySC-BoldItalic", size: size)
        }

        static func black(size: CGFloat) -> Font {
            .custom("PlayfairDisplaySC-Black", size: size)
        }

        static func blackItalic(size: CGFloat) -> Font {
            .custom("PlayfairDisplaySC-BlackItalic", size: size)
        }
    }
}
