//
//  MemberResource.swift
//  TrelloClient
//
//  Created by Krisztián Kemenes on 16.02.2025.
//

import Foundation

class MemberResource: TrelloResource {
    /// Load member data
    /// - Parameter id: Member id. Provide `me` for the authenticated user data. Default is `me`
    /// - Returns: The member data
    func get(id: String = "me") async throws -> Member {
        return try await self.makeRequest(to: .member(userId: id))
    }
}
