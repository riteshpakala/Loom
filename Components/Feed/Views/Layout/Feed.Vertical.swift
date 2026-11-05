//
//  Feed.Vertical.swift
//  Loom
//
//  Created by Ritesh Pakala on 7/29/23.
//

import Foundation
import SwiftUI
import Granite
import GraniteUI
import FederationKit

extension Feed {
    var verticalLayout: some View {
        VStack(spacing: 0) {
            FeedMainView(location: state.location,
                         communityView: state.communityView,
                         feedStyle: config.state.feedStyle) {
                headerView
            }
             .onBubble {
                 On(.viewCommunity, FederatedCommunity.self) { community in
                     fetchCommunity(community, reset: true)
                 }
             }
             .graniteEvent(account.center.interact)
             .overlay(LogoView()
                .onBubble {
                    On(.write) {
                        ModalService
                            .shared
                            .showWriteModal(state.communityView)
                    }
                })
             .environmentObject(pager)
        }
        .edgesIgnoringSafeArea(edgesToIgnore)
        .sideMenuIf(state.community == nil && Device.isExpandedLayout == false,
                    isShowing: _state.isShowing) {
            accountExpandedMenuView
                .id("\(account.state.profiles.count)\(account.state.authenticated)")
        }
    }
    
    var edgesToIgnore: Edge.Set {
        if isCommunity {
            if Device.isIPhone {
                return [.bottom, .top]
            } else {
                return [.bottom]
            }
        } else {
            return []
        }
    }
}

