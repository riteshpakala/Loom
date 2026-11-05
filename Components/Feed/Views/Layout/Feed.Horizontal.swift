//
//  Feed.Horizontal.swift
//  Loom
//
//  Created by Ritesh Pakala on 7/29/23.
//

import Foundation
import SwiftUI
import Granite
import FederationKit
import GraniteUI


extension Feed {
    var minFrameWidth: CGFloat? {
        if Device.isMacOS {
            return 480
        } else if Device.isiPad {
            return 360
        } else {
            return nil
        }
    }
    
    var minFrameWidthClosed: CGFloat {
        200 + ContainerConfig.iPhoneScreenWidth + .layer1
    }
    
    //Primarily for macOS
    var horizontalLayout: some View {
        HStack(spacing: 0) {
            FeedSidebar() {
                headerView
            }
            //TODO: the sidebar will hold looms, use fed data too
            .onBubble {
                On(.pickedCommunity, (FederatedCommunityResource, FederatedData?).self) { (model, federatedData) in
                    DispatchQueue.main.async {
                        self._state.community.wrappedValue = model.community
                        self._state.communityView.wrappedValue = model
                        self.pager.reset()
                    }
                }
            }
            .frame(width: 300)
            Divider()
            FeedMainView(location: state.location,
                         communityView: state.communityView,
                         feedStyle: config.state.feedStyle)
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
                .frame(minWidth: minFrameWidth, maxWidth: nil)
            FeedExtendedView(location: state.location)
                .onBubble {
                    On(.viewCommunity, FederatedCommunity.self) { community in
                        fetchCommunity(community, reset: true)
                    }
                }
        }
    }
}
