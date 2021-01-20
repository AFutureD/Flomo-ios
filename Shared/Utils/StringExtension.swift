//
//  StringExtension.swift
//  flomo
//
//  Created by AFuture on 2021/1/14.
//

import Foundation

extension String {
    
    func parseRichTextElements(regex: String) -> [(String,Bool)] {
        let regex = try! NSRegularExpression(pattern: regex)
        let range = NSRange(location: 0, length: count)
        
        /// Find all the ranges that match the regex *CONTENT*.
        let matches: [NSTextCheckingResult] = regex.matches(in: self, options: [], range: range)
        let matchingRanges = matches.compactMap { Range<Int>($0.range) }
        var elements: [(String,Bool)] = []
        
        let firstRange = 0..<(matchingRanges.count == 0 ? count : matchingRanges[0].lowerBound)
        
        if !self[firstRange].isEmpty {
            elements.append((self[firstRange],false))
        }
        
        
        for (index, matchingRange) in matchingRanges.enumerated() {
            let isLast = matchingRange == matchingRanges.last
            
            let matchContent = self[matchingRange]

            elements.append((matchContent,true))
            
            let endLocation = isLast ? count : matchingRanges[index + 1].lowerBound
            let range = matchingRange.upperBound..<endLocation

            if !self[range].isEmpty {
                elements.append((self[range],false))
            }
        }
        
        return elements
    }
    
    /// - Returns: A string subscript based on the given range.
    subscript(range: Range<Int>) -> String {
        let startIndex = index(self.startIndex, offsetBy: range.lowerBound)
        let endIndex = index(self.startIndex, offsetBy: range.upperBound)
        return String(self[startIndex..<endIndex])
    }
}
