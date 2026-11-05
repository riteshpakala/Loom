//
//  Feed.SetInstanceURL.swift
//  Loom
//
//  Created by Ritesh Pakala on 8/17/23.
//

import Foundation
import SwiftUI
import Granite
import GraniteUI

extension Feed {
    func setInstanceURL() {
        ModalService.shared.presentSheet {
            //TODO: localize
            GraniteStandardModalView(title: "Set Instance URL", maxHeight: 210) {
                SetInstanceView()
                    .onBubble {
                        On(.commit, String.self) { value in
                            config
                                .center
                                .restart
                                .send(
                                    ConfigService
                                        .Restart
                                        .Meta(host: value))
                            ModalService.shared.dismissSheet()
                        }
                    }
            }
        }
    }
}
