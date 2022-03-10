//
//  AddressEntity.swift
//  Data
//
//  Created by Rodrigo Kreutz on 07/12/2018.
//  Copyright © 2018 Teamwork. All rights reserved.
//

import Foundation

public struct AddressEntity: Codable, Equatable, Hashable {
    
    public var firstLine: String?
    public var secondLine: String?
    public var postalCode: String?
    public var city: String?
    public var state: String?
    public var country: String?
    public var countryCode: String?
    
    enum CodingKeys: String, CodingKey {
        
        case firstLine = "line1"
        case secondLine = "line2"
        case postalCode = "zipcode"
        case city = "city"
        case state = "state"
        case country = "country"
        case countryCode = "countrycode"
    }
} 
