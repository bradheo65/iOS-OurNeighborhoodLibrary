//
//  PopularBook.swift
//  OurNeighborhoodLibrary
//
//  Created by brad on 2023/04/20.
//

import Foundation

struct PopularBook: Codable, Hashable {
    let response: Response
}

struct Response: Codable, Hashable {
    let request: Request
    let resultNum, numFound: Int
    let docs: [DocElement]
}

struct DocElement: Codable, Hashable {
    let doc: DocDoc
}

struct DocDoc: Codable, Hashable {
    let no: Int
    let ranking, bookname, authors, publisher: String
    let publicationYear, isbn13, additionSymbol, vol: String
    let classNo, classNm, loanCount: String
    let bookImageURL: String
    let bookDtlURL: String

    enum CodingKeys: String, CodingKey {
        case no, ranking, bookname, authors, publisher
        case publicationYear = "publication_year"
        case isbn13
        case additionSymbol = "addition_symbol"
        case vol
        case classNo = "class_no"
        case classNm = "class_nm"
        case loanCount = "loan_count"
        case bookImageURL
        case bookDtlURL = "bookDtlUrl"
    }
}

struct Request: Codable, Hashable {
    let startDt, endDt, fromAge, toAge: String
    let addCode, kdc, region: String
    let pageNo, pageSize: Int

    enum CodingKeys: String, CodingKey {
        case startDt, endDt
        case fromAge = "from_age"
        case toAge = "to_age"
        case addCode, kdc, region, pageNo, pageSize
    }
}
