//
//  String+Extension.swift
//  AppstoreSearcher
//
//  Created by Dugong on 2020/08/11.
//  Copyright © 2020 dugong. All rights reserved.
//

import Foundation

extension String {
    func formattingKorean() -> String {
        var result = self
        // 만
        if self.count > 4 {
            if self.count == 5 {
                // 소수점 첫번째가 0이면 전부 생략
                if result[index(result.startIndex, offsetBy: 1)] == "0" {
                    result.removeLast(4)
                } else {
                    result.removeLast(3)
                    result.insert(".", at: result.index(result.startIndex, offsetBy: 1))
                }
            } else {
                result.removeLast(4)
            }
            result.append(contentsOf: "만")
            return result
        }
        // 천
        if self.count > 3 {
            if self.count == 4 {
                // 소수점 첫번째가 0이면 전부 생략
                if result[index(result.startIndex, offsetBy: 1)] == "0" {
                    result.removeLast(3)
                } else {
                    result.removeLast(2)
                    result.insert(".", at: result.index(result.startIndex, offsetBy: 1))
                }
            } else {
                result.removeLast(3)
            }
            result.append(contentsOf: "천")
            return result
        }
        
        return result
    }
}
