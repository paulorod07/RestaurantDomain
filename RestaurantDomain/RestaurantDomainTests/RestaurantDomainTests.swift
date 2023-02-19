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
        
        let returnedResult: RemoteRestaurantLoader.RemoteRestaurantResult = await sut.load()
        
        XCTAssertEqual(returnedResult, .failure(.connectivity))
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
        
        let returnedResult: RemoteRestaurantLoader.RemoteRestaurantResult = await sut.load()
        
        XCTAssertEqual(returnedResult, .failure(.invalidData))
    }
    
    func test_load_and_returned_success_with_empty_list() async throws {
        let (sut, networkClient, url) = try makeSUT()
        
        let response = try XCTUnwrap(HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        ))
        
        networkClient.result = .success((emptyData(), response))
        
        let returnedResult: RemoteRestaurantLoader.RemoteRestaurantResult = await sut.load()
        
        XCTAssertEqual(returnedResult, .success([]))
    }
    
    func test_load_and_returned_success_with_restaurant_item_list() async throws {
        let (sut, networkClient, url) = try makeSUT()
        
        let response = try XCTUnwrap(HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        ))
        
        let (model1, json1) = makeItem()
        let (model2, json2) = makeItem()
        
        let jsonItem = ["items": [json1, json2]]
        
        let data = try JSONSerialization.data(withJSONObject: jsonItem)
        
        networkClient.result = .success((data, response))
        
        let returnedResult: RemoteRestaurantLoader.RemoteRestaurantResult = await sut.load()
        
        XCTAssertEqual(returnedResult, .success([model1, model2]))
    }
    
    private func makeSUT() throws -> (sut: RemoteRestaurantLoader, networkClient: NetworkClientSpy, url: URL) {
        let url = try XCTUnwrap(URL(string: "https://google.com"))
        let networkClient = NetworkClientSpy()
        let sut = RemoteRestaurantLoader(url: url, networkClient: networkClient)
        
        return (sut, networkClient, url)
    }
    
    private func emptyData() -> Data {
        Data("{ \"items\": [] }".utf8)
    }
    
    func makeItem(
        id: UUID = UUID(),
        name: String = "name",
        location: String = "location",
        distance: Float = 5.5,
        ratings: Int = 4,
        parasols: Int = 10
    ) -> (model: RestaurantItem, json: [String:Any]) {
        
        let model = RestaurantItem(
            id: UUID(),
            name: "name",
            location: "location",
            distance: 5.5,
            ratings: 0,
            parasols: 0
        )
        
        let itemJson: [String:Any] = [
            "id": model.id.uuidString,
            "name": model.name,
            "location": model.location,
            "distance": model.distance,
            "ratings": model.ratings,
            "parasols": model.parasols
        ]
        
        return (model, itemJson)
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
