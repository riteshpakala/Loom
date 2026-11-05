//
//  FilterCollectionView.swift
//  Loom
//
//  Created by Ritesh Pakala on 9/1/23.
//

import Foundation
import SwiftUI
import Granite
import GraniteUI

struct FilterKeywordCollectionView: View {
    @Environment(\.graniteBubble) var bubble
    
    var config: FilterConfig
    
    var body: some View {
        ScrollView([.horizontal], showsIndicators: false) {
            HStack(spacing: .layer4) {
                Button {
                    GraniteHaptic.light.invoke()
                    bubble(.addKeyword, nil as FilterConfig.Keyword?)
                } label: {
                    Image(systemName: "plus")
                        .font(.footnote.bold())
                        .frame(width: 24, height: 24)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .aspectRatio(1.0, contentMode: .fit)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .foregroundColor(Color.alternateBackground.opacity(0.7))
                )
                .padding(.layer1)
                .outline(cornerRadius: 6)
                
                ForEach(config.keywords) { keyword in
                    Button {
                        GraniteHaptic.light.invoke()
                        bubble(.addKeyword, keyword as FilterConfig.Keyword?)
                    } label: {
                        Text(keyword.value)
                            .font(.headline)
                        Image(systemName: "pencil")
                            .font(.headline)
                    }
                    .frame(height: 24)
                    .contentShape(Rectangle())
                    .buttonStyle(.plain)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .foregroundColor(Color.alternateBackground.opacity(0.7))
                    )
                    .padding(.vertical, .layer1)
                    .padding(.horizontal, .layer2)
                    .outline(cornerRadius: 6)
                }
            }
        }
    }
}
