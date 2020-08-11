//
//  FileManager.swift
//  AppstoreSearcher
//
//  Created by Dugong on 2020/08/11.
//  Copyright © 2020 dugong. All rights reserved.
//

import Foundation

class FileManager {
    static let shared = FileManager()
    let resource = "History"
    
    func loadHistory() -> [History] {
        var histories: [History]?
        guard let url = Bundle.main.url(forResource: resource, withExtension: "plist") else {
            fatalError("resource not exist")
        }
        
        if let data = try? Data(contentsOf: url) {
          let decoder = PropertyListDecoder()
          histories = try? decoder.decode([History].self, from: data)
        }
        
        return histories?.sorted(by: { $0.createdAt > $1.createdAt }) ?? []
    }
    
    func updateHistory(histories: [History], newHistory: History) -> [History] {
        var updatedHistories = histories
        if let shouldUpdatedKeyword = histories.first(where: { $0.keyword == newHistory.keyword })?.keyword {
            updatedHistories.removeAll(where: { $0.keyword == newHistory.keyword })
            updatedHistories.insert(History(keyword: shouldUpdatedKeyword, createdAt: Date()), at: 0)
        } else {
            updatedHistories.insert(newHistory, at: 0)
        }
        
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        guard let url = Bundle.main.url(forResource: resource, withExtension: "plist") else {
            fatalError("resource not exist")
        }
        
        do {
          let data = try encoder.encode(updatedHistories)
          try data.write(to: url)
        } catch {
          fatalError("plist update failed")
        }
        
        return updatedHistories
    }
}
