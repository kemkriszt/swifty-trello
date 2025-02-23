//
//  CardResource.swift
//  TrelloClient
//
//  Created by Krisztián Kemenes on 16.02.2025.
//

public class CardResource: TrelloResource {
    /// Load the cards of a board
    /// - Parameters:
    ///   - board: Board ID to load cards for
    ///   - list: If provided, cards will be filtered for only the ones in the given lists
    /// - Returns: List of cards
    public func getForBoard(id boardId: String, inLists lists: [String]? = nil) async throws -> [Card] {
        let cards: [Card] = try await self.makeRequest(to: .cards(boardId: boardId))
        // API Filtering is not supported
        if let lists {
            return cards.filter { lists.contains($0.idList) }
        } else {
            return cards
        }
    }
    
    /// Get actions of a card. A card action can be a comment or any sort of change performed by a user
    public func actions(of cardId: String) async throws -> [ActionItem] {
        try await self.makeRequest(to: .actions(cardId: cardId))
    }
}
