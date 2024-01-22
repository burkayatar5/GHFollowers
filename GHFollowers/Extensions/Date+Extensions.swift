//
//  Date+Extensions.swift
//  GHFollowers
//
//  Created by Burkay Atar on 22.01.2024.
//

import Foundation

extension Date {
    
    func convertToMonthYearFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        return dateFormatter.string(from: self)
    }
}
