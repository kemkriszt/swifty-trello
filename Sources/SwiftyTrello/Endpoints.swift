//
//  TrelloEndpoints.swift
//  Briefed
//
//  Created by Krisztián Kemenes on 14.02.2025.
//

import Foundation
import SecureStore

enum Test:String {
    case a = ""
}

enum TrelloEndpoint {
    private static let apiBase = "https://api.trello.com/1"
    
    /// List all boards of the user
    case boards
    /// List all cards of a board
    case cards(boardId: String)
    /// List all events (like comments) on a card
    case actions(cardId: String)
    /// List all lists (columns) of  a board
    case lists(boardId: String)
    /// Get data of user. Use `me` to get the curren't users data
    case member(userId: String = "me")
    
    var url: URL {
        URL(string: Self.apiBase)!.appending(path: self.toString)
    }
    
    private var toString: String {
        switch self {
        case .boards: "/members/me/boards"
        case .cards(let boardId): "/boards/\(boardId)/cards"
        case .lists(let boardId): "/boards/\(boardId)/lists"
        case .actions(let cardId): "/cards/\(cardId)/actions"
        case .member(let userId): "/members/\(userId)"
        }
    }
}
