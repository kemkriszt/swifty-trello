//
//  File.swift
//  TrelloClient
//
//  Created by Krisztián Kemenes on 14.02.2025.
//

/// A card is like a ticket in trello representing a unit of work
public struct Card: Codable, Sendable {
    public let id: String
    public let name: String
    public let desc: String
    public let idBoard: String
    public let idList: String
}
