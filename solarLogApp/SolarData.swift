// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct Welcome: Decodable {
    let the801: The801

    enum CodingKeys: String, CodingKey {
        case the801 = "801"
    }
}

// MARK: - The801
struct The801: Decodable {
    let the170: The170

    enum CodingKeys: String, CodingKey {
        case the170 = "170"
    }
}

struct The170: Decodable {

    let lastUpdateTime : String
    let pac : Int
    let pdc : Int
    let uac : Int
    let udc : Int
    let yieldDay : Int
    let yieldYesterday : Int
    let yieldMonth : Int
    let yieldYear : Int
    let yieldTotal : Int
    let consPac : Int
    let consYieldDay : Int
    let consYieldYesterday : Int
    let consYieldMonth : Int
    let consYieldYear : Int
    let consYieldTotal : Int
    let totalPower : Int

    enum CodingKeys: String, CodingKey {
        case lastUpdateTime = "100"
        case pac = "101"
        case pdc = "102"
        case uac = "103"
        case udc = "104"
        case yieldDay = "105"
        case yieldYesterday = "106"
        case yieldMonth = "107"
        case yieldYear = "108"
        case yieldTotal = "109"
        case consPac = "110"
        case consYieldDay = "111"
        case consYieldYesterday = "112"
        case consYieldMonth = "113"
        case consYieldYear = "114"
        case consYieldTotal = "115"
        case totalPower = "116"
    }
}
