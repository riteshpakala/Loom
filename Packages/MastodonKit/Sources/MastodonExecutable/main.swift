//
//  main.swift
//  
//
//  Created by PEXAVC on 7/11/23.
//

import Foundation
import MastodonKit


let client = Client(baseURL: "https://loom.nyc")

let timelines = try? await client.run(Timelines.public()).value


for value in timelines ?? [] {
    print(value.content)
}
