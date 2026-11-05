//
//  FilterKeywordView.swift
//  Loom
//
//  Created by Ritesh Pakala on 9/1/23.
//

import Foundation
import Granite
import GraniteUI
import SwiftUI
import FederationKit

struct FilterKeywordView: View {
    @Environment(\.graniteBubble) var bubble
    
    var keywordToEdit: FilterConfig.Keyword? = nil
    var isEditing: Bool {
        keywordToEdit != nil
    }
    
    @State var keyword: String = ""
    @State var filterTitle: Bool = false
    @State var filterBody: Bool = false
    @State var filterLink: Bool = false
    @State var filterCommunityName: Bool = false
    @State var filterCreator: Bool = false
    @State var filterInstanceLink: Bool = false
    
    var body: some View {
        //TODO: localize
        GraniteStandardModalView {
            HStack(spacing: .layer4) {
                //TODO: localize
                Text("Add Keyword Filter")
                    .font(.title.bold())
                
                Spacer()
                
                if isEditing, let keyword = keywordToEdit {
                    Button {
                        GraniteHaptic.light.invoke()
                        bubble(.remove, keyword)
                    } label: {
                        Image(systemName: "trash")
                            .font(.headline.bold())
                            .foregroundColor(.red)
                    }.buttonStyle(.plain)
                    
                    Button {
                        GraniteHaptic.light.invoke()
                        let keyword: FilterConfig.Keyword = .init(value: self.keyword, attributes: generateAttributes())
                        bubble(.save, keyword)
                    } label: {
                        Image(systemName: "sdcard.fill")
                            .font(.title3)
                    }.buttonStyle(.plain)
                } else {
                    Button {
                        GraniteHaptic.light.invoke()
                        
                        let keyword: FilterConfig.Keyword = .init(value: self.keyword, attributes: generateAttributes())
                        
                        bubble(.save, keyword)
                    } label: {
                        Image(systemName: "checkmark")
                            .font(.title3)
                    }.buttonStyle(.plain)
                }
            }
        } content: {
            keywordForm
        }
        .task {
            keyword = keywordToEdit?.value ?? keyword
            filterTitle = keywordToEdit?.attributes.contains(.title) == true
            filterBody = keywordToEdit?.attributes.contains(.body) == true
            filterLink = keywordToEdit?.attributes.contains(.link) == true
            filterCommunityName = keywordToEdit?.attributes.contains(.communityName) == true
            filterCreator = keywordToEdit?.attributes.contains(.creator) == true
            filterInstanceLink = keywordToEdit?.attributes.contains(.instanceLink) == true
        }
    }
    
    func generateAttributes() -> [FilterConfig.ContentAttribute] {
        var attributes: [FilterConfig.ContentAttribute] = []
        if filterTitle {
            attributes.append(.title)
        }
        if filterBody {
            attributes.append(.body)
        }
        if filterLink {
            attributes.append(.link)
        }
        if filterCommunityName {
            attributes.append(.communityName)
        }
        if filterCreator {
            attributes.append(.creator)
        }
        if filterInstanceLink {
            attributes.append(.instanceLink)
        }
        return attributes
    }
}

extension FilterKeywordView {
    var keywordForm: some View {
        VStack(spacing: 0) {
            //TODO: localize
            StandardTextField(text: $keyword, placeholder: "Keyword")
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: .layer4) {
                    Toggle(isOn: $filterTitle) {
                        //TODO: localize
                        Text("Post Title")
                            .font(.headline)
                    }
                    
                    Toggle(isOn: $filterLink) {
                        //TODO: localize
                        Text("Post URL")
                            .font(.headline)
                    }
                    
                    Toggle(isOn: $filterBody) {
                        //TODO: localize
                        Text("Post/Comment Content")
                            .font(.headline)
                    }
                    
                    Toggle(isOn: $filterCommunityName) {
                        //TODO: localize
                        Text("Community Name")
                            .font(.headline)
                    }
                    
                    Toggle(isOn: $filterCreator) {
                        //TODO: localize
                        Text("Creator")
                            .font(.headline)
                    }
                    
                    Toggle(isOn: $filterInstanceLink) {
                        //TODO: localize
                        Text("Instance")
                            .font(.headline)
                    }
                }
                .padding(.horizontal, .layer2)
            }
            .padding(.vertical, .layer4)
        }
    }
}
