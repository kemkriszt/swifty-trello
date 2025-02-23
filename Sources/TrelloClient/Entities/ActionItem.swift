//
//  ActionItem.swift
//  TrelloClient
//
//  Created by Krisztián Kemenes on 14.02.2025.
//

/// An action that was performed on a card, such as a comment
public struct ActionItem: Codable, Sendable {
    public let data: ActionData
    public let type: ActionType?
    public let memberCreator: Member
}

public struct ActionData: Codable, Sendable {
    public let text: String?
}

public enum ActionType: Codable, Sendable {
    case commentCard
}
