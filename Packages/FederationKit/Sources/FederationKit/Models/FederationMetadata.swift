//
//  FederationMetadata.swift
//  
//
//  Created by Ritesh Pakala on 8/30/23.
//

import Foundation

public class FederationMetadata: Equatable {
    public static func == (lhs: FederationMetadata,
                           rhs: FederationMetadata) -> Bool {
        lhs.site.id == rhs.site.id && lhs.site.hashValue == rhs.site.hashValue
    }
    
    public var site: FederatedSite
    public init(siteView: FederatedSiteResource) {
        self.site = siteView.site
    }
}
