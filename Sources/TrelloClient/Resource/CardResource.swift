//
//  CardResource.swift
//  TrelloClient
//
//  Created by Krisztián Kemenes on 16.02.2025.
//

class CardResource: TrelloResource {
    /// Load the cards of a board
    /// - Parameters:
    ///   - board: Board ID to load cards for
    ///   - list: If provided, cards will be filtered for only the ones in the given lists
    /// - Returns: List of cards
    func get(for boardId: String, in lists: [String]? = nil) async throws -> [Card] {
        // TODO: Filter by list
        try await self.makeRequest(to: .cards(boardId: boardId))
    }
    
    /// Get actions of a card. A card action can be a comment or any sort of change performed by a user
    func actions(of cardId: String) async throws -> [ActionItem] {
        try await self.makeRequest(to: .actions(cardId: cardId))
    }
}
