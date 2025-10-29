//
//  Puzzle.swift
//  cc81
//
//  Created by SkyLearner
//

import Foundation

struct Puzzle: Identifiable, Codable {
    let id: UUID
    let title: String
    let question: String
    let correctAnswer: String
    let wrongAnswers: [String]
    let weatherCategory: WeatherCategory
    let difficulty: DifficultyLevel
    let explanation: String
    let points: Int
    
    var allAnswers: [String] {
        ([correctAnswer] + wrongAnswers).shuffled()
    }
    
    init(id: UUID = UUID(), title: String, question: String, correctAnswer: String, wrongAnswers: [String], weatherCategory: WeatherCategory, difficulty: DifficultyLevel, explanation: String, points: Int) {
        self.id = id
        self.title = title
        self.question = question
        self.correctAnswer = correctAnswer
        self.wrongAnswers = wrongAnswers
        self.weatherCategory = weatherCategory
        self.difficulty = difficulty
        self.explanation = explanation
        self.points = points
    }
}

struct GameLevel: Identifiable, Codable {
    let id: UUID
    let levelNumber: Int
    let title: String
    let puzzles: [Puzzle]
    let requiredScore: Int
    var isUnlocked: Bool
    var isCompleted: Bool
    var playerScore: Int
    
    init(id: UUID = UUID(), levelNumber: Int, title: String, puzzles: [Puzzle], requiredScore: Int, isUnlocked: Bool = false, isCompleted: Bool = false, playerScore: Int = 0) {
        self.id = id
        self.levelNumber = levelNumber
        self.title = title
        self.puzzles = puzzles
        self.requiredScore = requiredScore
        self.isUnlocked = isUnlocked
        self.isCompleted = isCompleted
        self.playerScore = playerScore
    }
}

