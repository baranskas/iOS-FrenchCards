//
//  Flashcard.swift
//  FrenchCards
//
//  Created by Martynas Baranskas on 30/04/2024.
//

import Foundation

struct Flashcard: Identifiable, Codable {
    var id = UUID()
    var frenchWord: String
    var englishTranslation: String
}
