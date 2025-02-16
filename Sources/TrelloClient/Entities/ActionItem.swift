//
//  ActionItem.swift
//  TrelloClient
//
//  Created by Krisztián Kemenes on 14.02.2025.
//

/// An action that was performed on a card, such as a comment
public struct ActionItem: Codable {
    let data: ActionData
    let type: ActionType?
    let memberCreator: Member
}

public struct ActionData: Codable {
    let text: String?
}

public enum ActionType: Codable {
    case commentCard
}
