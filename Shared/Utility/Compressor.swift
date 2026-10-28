//
//  Compressor.swift
//  Loom
//
//  Created by PEXAVC on 8/22/23.
//

import Foundation
import SwiftUI

struct Compressor {
    enum ImageQuality {
        case small
        case medium
        case large
        case custom(CGFloat)
        
        var bytes: CGFloat {
            switch self {
            case .small:
                return 100000
            case .medium:
                return 300000
            case .large:
                return 500000
            case .custom(let value):
                return value
            }
        }
    }
    
    func getImageSize(quality: ImageQuality = .small) {
        
    }
}

extension CGSize {
    func newSize(ratio: CGFloat) -> CGSize {
        //new_width/new_height = aspect
        //new_width * new_height = new_area
        
        //aspect * new_height = new_width
        //aspect * new_height^2 = new_area
        
        //sqrt(new_area/aspect) = new_height
        //new_area / new_height = new_width
        
        let area = (width * height)
        let aspect = width / height
        let new_area = area * ratio
        
        let new_height = sqrt(new_area / aspect)
        let new_width = new_area / new_height
        
        return .init(width: new_width, height: new_height)
    }
}

#if os(macOS)
extension NSImage {
    func compress(_ quality: Compressor.ImageQuality = .small) -> NSImage {
        guard let data = self.pngData() else { return self }
        
        let totalBytes = CGFloat(data.count)
        let targetBytes = quality.bytes
        
        guard totalBytes > targetBytes else {
            return self
        }
        
        let ratio = targetBytes / totalBytes
        
        let new_size = self.size.newSize(ratio: ratio)
        
        let resized = self.resizeWhileMaintainingAspectRatioToSize(size: .init(width: new_size.width, height: new_size.height))

        return resized ?? self
    }

    func pngData() -> Data? {
        guard let tiff = tiffRepresentation,
              let bitmap = NSBitmapImageRep(data: tiff) else { return nil }
        return bitmap.representation(using: .png, properties: [:])
    }

    //Fits within `size`, keeping the original aspect ratio
    func resizeWhileMaintainingAspectRatioToSize(size: NSSize) -> NSImage? {
        guard self.size.width > 0, self.size.height > 0 else { return nil }

        let scale = min(size.width / self.size.width, size.height / self.size.height)
        let target = NSSize(width: (self.size.width * scale).rounded(),
                            height: (self.size.height * scale).rounded())

        let resized = NSImage(size: target)
        resized.lockFocus()
        draw(in: .init(origin: .zero, size: target),
             from: .init(origin: .zero, size: self.size),
             operation: .copy,
             fraction: 1.0)
        resized.unlockFocus()
        return resized
    }
}
#else
extension UIImage {
    func compress(_ quality: Compressor.ImageQuality = .small) -> UIImage {
        guard let data = self.png else { return self }
        
        let totalBytes = CGFloat(data.count)
        let targetBytes = quality.bytes
        
        guard totalBytes > targetBytes else {
            return self
        }
        
        LoomLog("Compressing: \(totalBytes) -> \(targetBytes)", level: .debug)
        
        let ratio = targetBytes / totalBytes
        
        let new_size = self.size.newSize(ratio: ratio)
        
        let resized = self.resize(targetSize: new_size)
        
        return resized
    }
}

#endif
