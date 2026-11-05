//
//  Profile.InlineView.swift
//  Loom
//
//  Created by Ritesh Pakala on 7/29/23.
//

import Foundation
import SwiftUI
import Granite
import GraniteUI
import MarkdownView

extension Profile {
    var inlineView: some View {
        VStack(spacing: 0) {
            if let bio = state.person?.bio, bio.isEmpty == false {
                MarkdownView(text: bio)
                    .markdownViewRole(.editor)
                    .readability(bgColor: .secondaryBackground)
                    .outline()
                    .padding(.layer4)
            } else {
                EmptyView()
            }
            
            ProfilePickerView(kind: _state.viewingDataType, isMe: state.person?.isMe == true)
                .onBubble {
                    On(.refresh) {
                        pager.clear()
                        pager.fetch(force: true)
                    }
                }
        }
        .background(Color.background)
    }
}
