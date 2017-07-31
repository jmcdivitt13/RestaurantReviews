//
//  JSONDecodable.swift
//  RestaurantReviews
//
//  Created by Jeff Ripke on 7/31/17.
//  Copyright © 2017 Jeff Ripke. All rights reserved.
//

import Foundation

protocol JSONDecodable {
    /// Instantiates an instance of the conforming type with a JSON dictionary
    ///
    /// Returns 'nil' if the JSON dictionary does not contain all the values
    /// neeeded for instantiation of the conforming type
    init?(json: [String: Any])
}
