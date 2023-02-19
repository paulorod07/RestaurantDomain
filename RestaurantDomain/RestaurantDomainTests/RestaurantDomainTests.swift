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
        let (sut, networkClient, url) = try makeSUT()
        
        _ = await sut.load()
        
        XCTAssertEqual(networkClient.urls, [url])
    }
    
    func test_load_twice() async throws {
        let (sut, networkClient, url) = try makeSUT()
        
        _ = await sut.load()
        _ = await sut.load()
        
        XCTAssertEqual(networkClient.urls, [url, url])
    }
    
    func test_load_and_returned_error_for_connectivity() async throws {
        let (sut, networkClient, _) = try makeSUT()
        
        networkClient.result = .failure(NSError(domain: "any error", code: -1))
        
        let returnedResult: RemoteRestaurantLoader.Error = await sut.load()
        
        XCTAssertEqual(returnedResult, .connectivity)
    }
    
    func test_load_and_returned_error_for_invalidData() async throws {
        let (sut, networkClient, url) = try makeSUT()
        let response = try XCTUnwrap(HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        ))
        
        networkClient.result = .success((Data(), response))
        
        let returnedResult: RemoteRestaurantLoader.Error = await sut.load()
        
        XCTAssertEqual(returnedResult, .invalidData)
    }
    
    private func makeSUT() throws -> (sut: RemoteRestaurantLoader, networkClient: NetworkClientSpy, url: URL) {
        let url = try XCTUnwrap(URL(string: "https://google.com"))
        let networkClient = NetworkClientSpy()
        let sut = RemoteRestaurantLoader(url: url, networkClient: networkClient)
        
        return (sut, networkClient, url)
    }

}

final class NetworkClientSpy: NetworkClientProtocol {
    
    private(set) var urls: [URL] = []
    
    var result: NetworkResult?
     
    func request(from url: URL) async -> NetworkResult {
        self.urls.append(url)
        return result ?? .failure(NSError(domain: "any error", code: -1))
    }
    
}
