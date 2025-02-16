//
//  BoardResource.swift
//  TrelloClient
//
//  Created by Krisztián Kemenes on 16.02.2025.
//

import Foundation

class BoardResource: TrelloResource {
    /// Get boards of the authenticated member
    func all() async throws -> [Board] {
        return try await self.makeRequest(to: .boards)
    }
    
    /// Lists (columns) of a board
    func lists(of boardId: String) async throws -> [List] {
        try await self.makeRequest(to: .lists(boardId: boardId))
    }
}
