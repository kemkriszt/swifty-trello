//
//  Member.swift
//  TrelloClient
//
//  Created by Krisztián Kemenes on 14.02.2025.
//

public struct Member: Codable, Sendable {
    public let id: String
    public let fullName: String
    public let username: String
}
