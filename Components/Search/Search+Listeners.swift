//
//  Search+Listeners.swift
//  Loom
//
//  Created by Ritesh Pakala on 8/26/23.
//

import Granite
import SwiftUI


extension Search {
    var listeners: Void {
        config
            .center
            .restart
            .listen(.broadcast("search")) { value in
                if (value as? StandardErrorMeta) == nil {
                    LoomLog("🟡 Restarting Search")
                    
                    conductor.reset()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        conductor.startTimer("")
                    }
                }
            }
    }
}
