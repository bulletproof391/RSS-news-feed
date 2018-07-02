//
//  RSSParserExtension.swift
//  RSS news feed
//
//  Created by Дмитрий Вашлаев on 01.07.18.
//  Copyright © 2018 Дмитрий Вашлаев. All rights reserved.
//

import Foundation

extension RSSParser {
    var formattedDate: String {
        get {
            var subStrings = self.currentPublicationDate.split(separator: ",")
            subStrings.remove(at: 0)
            var dateString = subStrings[0]
            dateString.removeFirst()
            subStrings = dateString.split(separator: " ")
            dateString = ""
            dateString += "\(subStrings[2])-\(monthNumber(month: String(subStrings[1])))-\(subStrings[0])T\(subStrings[3])\(subStrings[4])"
            
            return String(dateString)
        }
    }
    
    private func monthNumber(month: String) -> String {
        var monthNumber = ""
        
        switch month.lowercased() {
        case "jan":
            monthNumber = "01"
            break
        case "feb":
            monthNumber = "02"
            break
        case "mar":
            monthNumber = "03"
            break
        case "apr":
            monthNumber = "04"
            break
        case "may":
            monthNumber = "05"
            break
        case "jun":
            monthNumber = "06"
            break
        case "jul":
            monthNumber = "07"
            break
        case "aug":
            monthNumber = "08"
            break
        case "sep":
            monthNumber = "09"
            break
        case "oct":
            monthNumber = "10"
            break
        case "nov":
            monthNumber = "11"
            break
        case "dec":
            monthNumber = "12"
            break
        default:
            monthNumber = "01"
            break
        }
        
        return monthNumber
    }
}
