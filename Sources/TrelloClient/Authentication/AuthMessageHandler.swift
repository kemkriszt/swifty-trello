//
//  WebMessageHandler.swift
//  Briefed
//
//  Created by Krisztián Kemenes on 10.02.2025.
//

import WebKit

class AuthMessageHandler: NSObject, WKScriptMessageHandler {
    typealias Handler = (Result<String, Error>) -> Void
    
    // Trello only sends this string if the authorization fails
    private static let failMessage = "Token request rejected"
    
    /// Result handler. In case of success, the token is returned in the result
    let handler: Handler
    
    init(handler: @escaping Handler) {
        self.handler = handler
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let messageString = message.body as? String
        else { return }
        
        if messageString == Self.failMessage {
            handler(.failure(TrelloError.accessDenied))
        } else {
            handler(.success(messageString))
        }
    }
}
