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

    let members: MemberResource
    let boards: BoardResource
    let cards: CardResource
    
    public init(apiKey: String,
                accountKey: String,
                urlSession: URLSession = .shared,
                decoder: JSONDecoder = JSONDecoder()) {
        self.authenticator = Authenticator(apiKey: apiKey, accountKey: accountKey)
        
        var weakSelf: TrelloClient!
        let authCallback: TrelloResource.AuthenticatorFunction = { [weak weakSelf] url in
            try await weakSelf?.authenticator.prepareRequest(for: url)
        }
        members = MemberResource(authenticate: authCallback, urlSession: urlSession, decoder: decoder)
        boards = BoardResource(authenticate: authCallback, urlSession: urlSession, decoder: decoder)
        cards = CardResource(authenticate: authCallback, urlSession: urlSession, decoder: decoder)
        
        weakSelf = self
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
}
