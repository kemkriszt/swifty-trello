//
//  List.swift
//  TrelloClient
//
//  Created by Krisztián Kemenes on 14.02.2025.
//

/// A list or column of a board in trello
struct List: Codable {
    let id: String
    let name: String
    /// Position of the list in the board
    let pos: Int
}
