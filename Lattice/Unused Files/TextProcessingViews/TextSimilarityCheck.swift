////
////  TextSimilarityCheck.swift
////  Lattice
////
////  Created by Eli Zhang on 12/20/18.
////  Copyright © 2018 Eli Zhang. All rights reserved.
////
//
//import Foundation
//
//class TextSimilarityCheck {
//    static func findClosestStrings(inputString: String) -> Set<String> {
//        let excessChars = CharacterSet.alphanumerics.inverted.union(CharacterSet(charactersIn: " "))    // Alphaneumerics + spaces aren't removed
//        let alphanumeric  = inputString.components(separatedBy: excessChars).joined(separator: " ")
//        let separators = CharacterSet(charactersIn: " ,")
//        let substrings = alphanumeric.components(separatedBy: separators)    // Splices into separate strings to check
//        let viableStrings: [String] = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday",
//                                        "January", "February", "March", "April", "May", "June", "July", "August", "September",
//                                        "October", "November", "December"]
//        var parsedStrings: Set<String> = []
//        for viable in viableStrings {
//            let jaroWinkler = inputString.jaroWinkler(viable)
//            if jaroWinkler > 80 {
//                parsedStrings.insert(viable)
//            }
//        }
//
//        for string in substrings {
//            for viable in viableStrings {
//                let levenshtein = string.levenshtein(viable)
//                if levenshtein < 2 {
//                    parsedStrings.insert(viable)
//                }
//            }
//        }
//        print(parsedStrings)
//        return parsedStrings
//    }
//}
//// Word similarity functions found at https://github.com/autozimu/StringMetric.swift/blob/master/Sources/StringMetric.swift by user Junfeng Li
//extension String {
//    public func jaroWinkler(_ other: String) -> Int {
//        if self.count == 0 && other.count == 0 {
//            return 100
//        }
//
//        let matchingWindowSize = max(self.count, other.count) / 2 - 1
//        var selfFlags = Array(repeating: false, count: self.count)
//        var otherFlags = Array(repeating: false, count: other.count)
//
//        // Count matching characters.
//        var m: Double = 0
//        for i in 0..<self.count {
//            let left = max(0, i - matchingWindowSize)
//            let right = min(other.count - 1, i + matchingWindowSize)
//
//            if left <= right {
//                for j in left...right {
//                    // Already has a match, or does not match
//                    if otherFlags[j] || self[i] != other[j] {
//                        continue;
//                    }
//
//                    m += 1
//                    selfFlags[i] = true
//                    otherFlags[j] = true
//                    break
//                }
//            }
//        }
//
//        if m == 0.0 {
//            return 0
//        }
//
//        // Count transposition.
//        var t: Double = 0
//        var k = 0
//        for i in 0..<self.count {
//            if (selfFlags[i] == false) {
//                continue
//            }
//            while (otherFlags[k] == false) {
//                k += 1
//            }
//            if (self[i] != other[k]) {
//                t += 1
//            }
//            k += 1
//        }
//        t /= 2.0
//
//        // Count common prefix.
//        var l: Double = 0
//        for i in 0..<4 {
//            if self[i] == other[i] {
//                l += 1
//            } else {
//                break
//            }
//        }
//
//        let dj = (m / Double(self.count) + m / Double(other.count) + (m - t) / m) / 3
//
//        let p = 0.1
//        let dw = dj + l * p * (1 - dj)
//
//        return Int(dw * 100);
//    }
//}
//
//// Levenshtein distance used to calculate how similar scanned text is to actual dates
//// Code from user RuiCarneiro at https://gist.github.com/RuiCarneiro/82bf91214e3e09222233b1fc04139c86
//extension String {
//    subscript(index: Int) -> Character {
//        return self[self.index(self.startIndex, offsetBy: index)]
//    }
//}
//
//
//extension String {
//    public func levenshtein(_ other: String) -> Int {
//        let sCount = self.count
//        let oCount = other.count
//
//        guard sCount != 0 else {
//            return oCount
//        }
//
//        guard oCount != 0 else {
//            return sCount
//        }
//
//        let line : [Int]  = Array(repeating: 0, count: oCount + 1)
//        var mat : [[Int]] = Array(repeating: line, count: sCount + 1)
//
//        for i in 0...sCount {
//            mat[i][0] = i
//        }
//
//        for j in 0...oCount {
//            mat[0][j] = j
//        }
//
//        for j in 1...oCount {
//            for i in 1...sCount {
//                if self[i - 1] == other[j - 1] {
//                    mat[i][j] = mat[i - 1][j - 1]       // no operation
//                }
//                else {
//                    let del = mat[i - 1][j] + 1         // deletion
//                    let ins = mat[i][j - 1] + 1         // insertion
//                    let sub = mat[i - 1][j - 1] + 1     // substitution
//                    mat[i][j] = min(min(del, ins), sub)
//                }
//            }
//        }
//
//        return mat[sCount][oCount]
//    }
//}
