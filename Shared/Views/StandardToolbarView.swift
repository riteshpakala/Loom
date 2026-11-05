//
//  StandardToolbarView.swift
//  Loom
//
//  Created by Ritesh Pakala on 8/14/23.
//

import Foundation
import Granite
import GraniteUI
import SwiftUI

struct StandardToolbarView: View {
    
    var body: some View {
        Group {
            Spacer()
            
            Button {
                GraniteHaptic.light.invoke()
                
                #if os(iOS)
                UIApplication.hideKeyboard()
                #endif
            } label : {
                if #available(macOS 13.0, iOS 16.0, *) {
                    Image(systemName: "keyboard.chevron.compact.down.fill")
                        .font(.headline)
                } else {
                    Image(systemName: "chevron.down")
                        .font(.headline)
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            Spacer()
        }
    }
}
