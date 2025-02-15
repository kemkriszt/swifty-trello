//
//  TrelloClient.swift
//  Briefed
//
//  Created by Krisztián Kemenes on 13.02.2025.
//

#if canImport(AppKit)
import AppKit
#else
import UIKit
#endif

/// A Trello API client
public class TrelloClient {
    private let authenticator: Authenticator
    
    public init(apiKey: String, accountKey: String) {
        authenticator = Authenticator(apiKey: apiKey, accountKey: accountKey)
    }
    
    // MARK: Auth
    
#if canImport(AppKit)
    public func authenticate() async throws {
        
    }
#else
    /// Initiate an authentication flow or token refrehs.
    /// - Parameters:
    ///     - context: The view controller to present the authentication window on. For more details see ``TrelloAuthenticator.authenticate``
    public func authenticate(in context: UIViewController? = nil) async throws {
        try await authenticator.authenticate(in: context)
    }
#endif
    
    // MARK: CRUD
    
}

// MARK: Helpers

extension TrelloClient {
    
}
