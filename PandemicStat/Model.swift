//
//  Countries.swift
//  PandemicStat
//
//  Created by Rajesh M on 31/03/20.
//  Copyright © 2020 Rajesh M. All rights reserved.
//

import Foundation
import UIKit

var jsonString =  """
{
  "name": "Afghanistan",
  "topLevelDomain": [
    ".af"
  ],
  "alpha2Code": "AF",
  "alpha3Code": "AFG",
  "callingCodes": [
    "93"
  ],
  "capital": "Kabul",
  "altSpellings": [
    "AF",
    "Afġānistān"
  ],
  "region": "Asia",
  "subregion": "Southern Asia",
  "population": 27657145,
  "latlng": [
    33,
    65
  ],
  "demonym": "Afghan",
  "area": 652230,
  "gini": 27.8,
  "timezones": [
    "UTC+04:30"
  ],
  "borders": [
    "IRN",
    "PAK",
    "TKM",
    "UZB",
    "TJK",
    "CHN"
  ],
  "nativeName": "افغانستان",
  "numericCode": "004",
  "currencies": [
    {
      "code": "AFN",
      "name": "Afghan afghani",
      "symbol": "؋"
    }
  ],
  "languages": [
    {
      "iso639_1": "ps",
      "iso639_2": "pus",
      "name": "Pashto",
      "nativeName": "پښتو"
    },
    {
      "iso639_1": "uz",
      "iso639_2": "uzb",
      "name": "Uzbek",
      "nativeName": "Oʻzbek"
    },
    {
      "iso639_1": "tk",
      "iso639_2": "tuk",
      "name": "Turkmen",
      "nativeName": "Türkmen"
    }
  ],
  "translations": {
    "de": "Afghanistan",
    "es": "Afganistán",
    "fr": "Afghanistan",
    "ja": "アフガニスタン",
    "it": "Afghanistan",
    "br": "Afeganistão",
    "pt": "Afeganistão",
    "nl": "Afghanistan",
    "hr": "Afganistan",
    "fa": "افغانستان"
  },
  "flag": "https://restcountries.eu/data/afg.svg",
  "regionalBlocs": [
    {
      "acronym": "SAARC",
      "name": "South Asian Association for Regional Cooperation",
      "otherAcronyms": [],
      "otherNames": []
    }
  ],
  "cioc": "AFG"
}
"""
var response = """
    [{"confirmed":"1118193","recovered":"229154","critical":"39401","deaths":"59210"}]
"""
var country = """
[{"country":"Afghanistan","confirmed":299,"recovered":10,"critical":0,"deaths":6,"latitude":33.93911,"longitude":67.709953}]

"""

public struct ResponseBody: Codable {
    
    var totalResponse: [TotalResponse?]
}

public struct TotalResponse: Codable {
    
    var confirmed: Int?
    var critical: Int?
    var deaths: Int?
    var lastChange: String?
    var lastUpdate: String?
    var recovered: Int?
}

public struct CountryResponse: Codable {
    
    var country: String?
    var confirmed: Int?
    var recovered: Int?
    var critical: Int?
    var deaths: Int?
    var latitude: Double?
    var longitude: Double?
}

public struct Country: Codable {
    
    var topLevelDomain: [String?]
    var callingCodes: [String?]
    var name: String?

    var alpha2Code: String?
    var alpha3Code: String?
    var capital: String?
    var altSpellings: [String?]
    var region: String?
    var subregion: String?
    var population: Int?
    var latlng: [Double]
    var demonym: String?
    var area: Float?
    var gini: Float?
    var timezones: [String]
    var borders: [String]
    var nativeName: String?
    var numericCode: String?
    var currencies: [Dictionary<String, String?>]
    var languages: [Dictionary<String, String?>]
    var translations: Dictionary<String, String?>
    var flag: String?
    //var regionalBlocs: [Dictionary<String, String?>]
    var cioc: String?

    
//    enum CodingKeys: String, CodingKey {
//
//        case name = "name"
//        case alpha2Code = "alpha2Code"
//        case alpha3Code = "alpha3Code"
//        case capital = "capital"
//        case altSpellings
//        case region = "region"
//        case subregion = "subregion"
//        case population = "population"
//        case latlng
//        case demonym = "demonym"
//        case area = "area"
//        case gini = "gini"
//        case timezones
//        case borders
//        case nativeName = "nativeName"
//        case numericCode = "numericCode"
//        case currencies
//        case languages
//        case translations
//        case flag = "flag"
//        case regionalBlocs
//        case cioc = "cioc"
//    }
}


extension Bundle {
    func decode<T: Decodable>(_ type: T.Type, from file: String, dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate, keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = dateDecodingStrategy
        decoder.keyDecodingStrategy = keyDecodingStrategy

        do {
            return try decoder.decode([T].self, from: data) as! T
        } catch DecodingError.keyNotFound(let key, let context) {
            fatalError("Failed to decode \(file) from bundle due to missing key '\(key.stringValue)' not found – \(context.debugDescription)")
        } catch DecodingError.typeMismatch(_, let context) {
            fatalError("Failed to decode \(file) from bundle due to type mismatch – \(context.debugDescription)")
        } catch DecodingError.valueNotFound(let type, let context) {
            fatalError("Failed to decode \(file) from bundle due to missing \(type) value – \(context.debugDescription)")
        } catch DecodingError.dataCorrupted(_) {
            fatalError("Failed to decode \(file) from bundle because it appears to be invalid JSON")
        } catch {
            fatalError("Failed to decode \(file) from bundle: \(error.localizedDescription)")
        }
    }
}



