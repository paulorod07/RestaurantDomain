//
//  NetworkClientSpy.swift
//  RestaurantDomainTests
//
//  Created by Paulo Rodrigues on 20/02/23.
//

import Foundation
import RestaurantDomain

final class NetworkClientSpy: NetworkClient {
    
    private(set) var urls: [URL] = []
    
    var result: NetworkResult?
     
    func request(from url: URL) async -> NetworkResult {
        self.urls.append(url)
        return result ?? .failure(NSError(domain: "any error", code: -1))
    }
    
}
