//
//  Response.swift
//  AppstoreSearcher
//
//  Created by Dugong on 2020/08/06.
//  Copyright © 2020 dugong. All rights reserved.
//

import Foundation

struct Response: Codable {
    let resultCount: Int
    let results: [App]
}
