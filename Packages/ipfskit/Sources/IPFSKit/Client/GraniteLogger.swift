//
//  GraniteLogger.swift
//
//
//  Created by Ritesh Pakala on 2/26/21.
//

import Foundation
import os

public struct GraniteLogger {
    private static let subsystem = "granite"
    
    public enum Category: String {
        case expedition
        case command
        case center
        case relay
        case component
        case state
        case event
        case dependency
        case adAstra
        case signal
        case metal
        case ml
        case utility
        case network
        case none
        
        var log: OSLog {
            OSLog(subsystem: subsystem, category: self.rawValue)
        }
        
        var helper: String {
            switch self {
            case .expedition:
                return "🛥🛥🛥🛥"
            case .command:
                return "📡📡📡📡"
            case .center:
                return "🎛🎛🎛🎛"
            case .relay:
                return "🛰🛰🛰🛰"
            case .component:
                return "🛸🛸🛸🛸"
            case .state:
                return "🗽🗽🗽🗽"
            case .event:
                return "⛓⛓⛓⛓"
            case .dependency:
                return "📦📦📦📦"
            case .adAstra:
                return "🚀🚀🚀🚀"
            case .signal:
                return "🚥🚥🚥🚥"
            case .metal:
                return "🎸🎸🎸🎸"
            case .ml:
                return "🧬🧬🧬🧬"
            case .utility:
                return "🔧🔧🔧🔧"
            case .network:
                return "📬📬📬📬"
            case .none:
                return "-------"
            }
        }
        
        var disable: Bool {
            return true
        }
    }
    
    public class Counters {
        public var command: Int = 0
        
        func update(_ category: GraniteLogger.Category) {
            
            switch category {
            case .command:
                command += 1
            default:
                break
            }
        }
        
        func getLogCount(_ category: GraniteLogger.Category) -> String {
            switch category {
            case .command:
                return " log count: \(command) "
            default:
                return ""
            }
        }
    }
    static var counters: Counters = .init()
    
    static func focusText(_ isFocused: Bool) -> String {
        return isFocused ? "🧪" : ""
    }
    
    public static func info(_ object: Any,
                            _ logger: GraniteLogger.Category = .none,
                            focus: Bool = false,
                            symbol: String = "") {
        guard !logger.disable || focus else { return }
        
        counters.update(logger)
        
        os_log("%@",
               log: logger.log,
               type: .info,
               "\n🁡🁡🁡🁡🁡🁡\n"+logger.helper+" \(symbol)\(symbol.isEmpty ? "" : " ")\(focusText(focus))\n"+"\(object)"+"\n"+logger.helper+" \(focusText(focus))\n🁡🁡🁡\(counters.getLogCount(logger))🁡🁡🁡")
    }
    
    public static func info(_ text: String,
                            _ logger: GraniteLogger.Category = .none,
                            focus: Bool = false,
                            symbol: String = "") {
        guard !logger.disable || focus else { return }
        
        counters.update(logger)
        
        os_log("%@",
               log: logger.log,
               type: .info,
               "\n🁡🁡🁡🁡🁡🁡\n"+logger.helper+" \(symbol)\(symbol.isEmpty ? "" : " ")\(focusText(focus))\n"+text+"\n"+logger.helper+" \(focusText(focus))\n🁡🁡🁡\(counters.getLogCount(logger))🁡🁡🁡")
    }
    
    public static func debug(_ text: String,
                              _ logger: GraniteLogger.Category,
                              focus: Bool = false,
                              symbol: String = "") {
        guard !logger.disable else { return }
        os_log("%@",
               log: logger.log,
               type: .debug,
               logger.helper+"\(symbol)\(focusText(focus))\n"+text+"\n"+logger.helper+"\n🁡🁡🁡🁡🁡🁡\(focusText(focus))")
    }
    
    public static func error(_ text: String,
                              _ logger: GraniteLogger.Category,
                              focus: Bool = false,
                              symbol: String = "") {
        guard !logger.disable else { return }
        os_log("%@",
               log: logger.log,
               type: .error,
               logger.helper+"\(symbol)\(focusText(focus))\n"+text+"\n"+logger.helper+"\n🁡🁡🁡🁡🁡🁡\(focusText(focus))")
    }
}
