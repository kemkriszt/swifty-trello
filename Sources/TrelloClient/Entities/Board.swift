//
//  TrelloBoard.swift
//  Briefed
//
//  Created by Krisztián Kemenes on 14.02.2025.
//

/// A board is the main groupping element in trello holding multiple cards in multiple lists (columns)
public struct Board: Codable {
    let id: String
    let name: String
}
