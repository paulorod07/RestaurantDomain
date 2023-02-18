//
//  RestaurantDomainTests.swift
//  RestaurantDomainTests
//
//  Created by Paulo Rodrigues on 18/02/23.
//

import XCTest
@testable import RestaurantDomain

final class RestaurantDomainTests: XCTestCase {

    func test_initializer_remoteRestaurantLoader_and_validate_url() async throws {
        let url = try XCTUnwrap(URL(string: "https://google.com"))
        let networkClient = NetworkClientSpy()
        let sut = RemoteRestaurantLoader(url: url, networkClient: networkClient)
        
        _ = await sut.load()
        
        XCTAssertEqual(networkClient.urls, [url])
    }
    
    func test_load_twice() async throws {
        let url = try XCTUnwrap(URL(string: "https://google.com"))
        let networkClient = NetworkClientSpy()
        let sut = RemoteRestaurantLoader(url: url, networkClient: networkClient)
        
        _ = await sut.load()
        _ = await sut.load()
        
        XCTAssertEqual(networkClient.urls, [url, url])
    }
    
    func test_load_and_returned_error_for_connectivity() async throws {
        let url = try XCTUnwrap(URL(string: "https://google.com"))
        let networkClient = NetworkClientSpy()
        let sut = RemoteRestaurantLoader(url: url, networkClient: networkClient)
        
        let error = await sut.load()
        
        XCTAssertNotNil(error)
    }

}

final class NetworkClientSpy: NetworkClientProtocol {
    
    private(set) var urls: [URL] = []
     
    func request(from url: URL) async -> Error {
        self.urls.append(url)
        return NSError(domain: "any error", code: -1)
    }
    
}
