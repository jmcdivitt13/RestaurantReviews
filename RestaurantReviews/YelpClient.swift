//
//  YelpClient.swift
//  RestaurantReviews
//
//  Created by Jeff Ripke on 8/1/17.
//  Copyright © 2017 Jeff Ripke. All rights reserved.
//

import Foundation

class YelpClient: APIClient {
    let session: URLSession
    private let token: String
    
    init(configuration: URLSessionConfiguration, oauthToken: String) {
        self.session = URLSession(configuration: configuration)
        self.token = oauthToken
    }
    
    convenience init(oauthToken: String) {
        self.init(configuration: .default, oauthToken: oauthToken)
    }
    
    func search(withTerm term: String, at coordinate: Coordinate, categories: [YelpCategory] = [], radius: Int? = nil, limit: Int = 50, sortBy sortType: Yelp.YelpSortType = .rating, completion: @escaping (Result<[YelpBusiness], APIError>) -> Void) {
        
        let endpoint = Yelp.search(term: term, coordinate: coordinate, radius: radius, categories: categories, limit: limit, sortBy: sortType)
        
        let request = endpoint.requestWithAuthorizationHeader(oauthToken: token)
        
        fetch(with: request, parse: { json -> [YelpBusiness] in
            guard let businesses = json["businesses"] as? [[String: Any]] else { return [] }
            return businesses.flatMap { YelpBusiness(json: $0) }
            
        }, completion: completion)
    }
}
