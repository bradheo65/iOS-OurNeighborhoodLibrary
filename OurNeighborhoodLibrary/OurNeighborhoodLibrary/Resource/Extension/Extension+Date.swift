//
//  Extension+Date.swift
//  OurNeighborhoodLibrary
//
//  Created by brad on 2023/04/23.
//

import Foundation

extension Date {

    var today: Date {
        Calendar.current.date(byAdding: .day, value: -1, to: self) ?? Date()
    }
    
    var yesterday: Date {
        Calendar.current.date(byAdding: .day, value: -2, to: self) ?? Date()
    }
    
    var weekly: Date {
        Calendar.current.date(byAdding: .day, value: -7, to: self) ?? Date()
    }

    var dateFormatter: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        return dateFormatter.string(from: self)
    }

}
