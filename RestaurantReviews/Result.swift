//
//  Result.swift
//  RestaurantReviews
//
//  Created by Jeff Ripke on 8/1/17.
//  Copyright © 2017 Jeff Ripke. All rights reserved.
//

import Foundation

enum Result<T, U> where U: Error {
    case success(T)
    case failure(U)
}
