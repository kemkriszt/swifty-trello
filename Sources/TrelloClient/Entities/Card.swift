//
//  File.swift
//  TrelloClient
//
//  Created by Krisztián Kemenes on 14.02.2025.
//

/// A card is like a ticket in trello representing a unit of work
public struct Card: Codable {
    let id: String
    let name: String
    let desc: String
    let idBoard: String
}
