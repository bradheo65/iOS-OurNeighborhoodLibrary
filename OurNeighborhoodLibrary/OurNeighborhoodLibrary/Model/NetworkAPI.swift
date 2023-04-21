//
//  Lib.swift
//  OurNeighborhoodLibrary
//
//  Created by brad on 2023/04/20.
//

import Foundation

struct Libs {
    let lib: [Lib]
}

struct Lib {
    var libCode: String
    var libName: String
    var address: String
    var tel: String
    var fax: String
    var latitude: String
    var longitude: String
    var homepage: String
    var closed: String
    var operatingTime: String
    var BookCount: String
}

enum LibXMLKey: String {
    case libCode = "libCode"
    case libName = "libName"
    case address = "address"
    case tel = "tel"
    case fax = "fax"
    case latitude = "latitude"
    case longitude = "longitude"
    case homepage = "homepage"
    case closed = "closed"
    case operatingTime = "operatingTime"
    case BookCount = "BookCount"
}
