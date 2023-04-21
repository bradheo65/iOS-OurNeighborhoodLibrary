//
//  HotBook.swift
//  OurNeighborhoodLibrary
//
//  Created by brad on 2023/04/21.
//

import Foundation


struct HotBook: Codable, Hashable {
    let response: HotBookResponse
}

struct HotBookResponse: Codable, Hashable {
    let request: HotBookRequest
    let results: [HotBookResultElement]
}

struct HotBookRequest: Codable, Hashable {
    let searchDt: String
}

struct HotBookResultElement: Codable, Hashable {
    let result: HotBookResultResult
}

struct HotBookResultResult: Codable, Hashable {
    let date: String
    let docs: [HotBookDocElement]
}

struct HotBookDocElement: Codable, Hashable {
    let doc: HotBookDocDoc
}

struct HotBookDocDoc: Codable, Hashable {
    let no, difference, baseWeekRank, pastWeekRank: Int
    let bookname, authors, publisher, publicationYear: String
    let isbn13, additionSymbol: String
    let vol: String?
    let classNo, classNm: String
    let bookImageURL: String
    let bookDtlURL: String

    enum CodingKeys: String, CodingKey {
        case no, difference, baseWeekRank, pastWeekRank, bookname, authors, publisher
        case publicationYear = "publication_year"
        case isbn13
        case additionSymbol = "addition_symbol"
        case vol
        case classNo = "class_no"
        case classNm = "class_nm"
        case bookImageURL
        case bookDtlURL = "bookDtlUrl"
    }
}
