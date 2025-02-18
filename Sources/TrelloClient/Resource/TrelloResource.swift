//
//  TrelloResource.swift
//  TrelloClient
//
//  Created by Krisztián Kemenes on 16.02.2025.
//

import Foundation

/// Base Resource implementing common functionality
class TrelloResource {
    typealias AuthenticatorFunction = (URL) async throws -> URLRequest?
    
    internal let authenticate: AuthenticatorFunction
    internal let urlSession: URLSession
    internal let decoder: JSONDecoder
    
    init(authenticate: @escaping @Sendable AuthenticatorFunction,
                  urlSession: URLSession,
                  decoder: JSONDecoder) {
        self.authenticate = authenticate
        self.urlSession = urlSession
        self.decoder = decoder
    }
    
    /// Make a request to the API
    internal func makeRequest<T: Codable>(to endpoint: TrelloEndpoint) async throws -> T {
        guard let request = try await self.authenticate(endpoint.url)
        else { throw TrelloError.generalError }
        
        let responseData = try await urlSession.data(for: request)
        
        return try decoder.decode(T.self, from: responseData.0)
    }
}
