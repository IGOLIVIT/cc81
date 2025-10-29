//
//  GameProgressTracker.swift
//  cc81
//
//  Created by SkyLearner
//

import Foundation
import SwiftUI
import Combine

class GameProgressTracker: ObservableObject {
    @AppStorage("totalScore") var totalScore: Int = 0
    @AppStorage("currentLevel") var currentLevel: Int = 1
    @AppStorage("puzzlesSolved") var puzzlesSolved: Int = 0
    @AppStorage("perfectAnswers") var perfectAnswers: Int = 0
    @AppStorage("gameLevelsData") private var gameLevelsDataString: String = ""
    
    @Published var levels: [GameLevel] = []
    
    init() {
        loadLevels()
    }
    
    func updateLevels(_ newLevels: [GameLevel]) {
        levels = newLevels
        saveLevels()
    }
    
    private func saveLevels() {
        if let encoded = try? JSONEncoder().encode(levels) {
            gameLevelsDataString = String(data: encoded, encoding: .utf8) ?? ""
        }
    }
    
    private func loadLevels() {
        if let data = gameLevelsDataString.data(using: .utf8),
           let decoded = try? JSONDecoder().decode([GameLevel].self, from: data) {
            levels = decoded
        }
    }
    
    func addScore(_ points: Int) {
        totalScore += points
    }
    
    func incrementPuzzlesSolved() {
        puzzlesSolved += 1
    }
    
    func incrementPerfectAnswers() {
        perfectAnswers += 1
    }
    
    func completeLevel(_ levelNumber: Int, score: Int) {
        guard let index = levels.firstIndex(where: { $0.levelNumber == levelNumber }) else { return }
        
        levels[index].isCompleted = true
        levels[index].playerScore = max(levels[index].playerScore, score)
        
        // Unlock next level
        if levelNumber < levels.count {
            let nextIndex = index + 1
            levels[nextIndex].isUnlocked = true
        }
        
        if levelNumber > currentLevel {
            currentLevel = levelNumber
        }
        
        saveLevels()
    }
    
    func getLevelProgress(_ levelNumber: Int) -> GameLevel? {
        return levels.first { $0.levelNumber == levelNumber }
    }
    
    func resetProgress() {
        totalScore = 0
        currentLevel = 1
        puzzlesSolved = 0
        perfectAnswers = 0
        gameLevelsDataString = ""
        levels.removeAll()
    }
    
    func getAchievementProgress() -> [Achievement] {
        return [
            Achievement(
                title: "First Steps",
                description: "Solve your first puzzle",
                isUnlocked: puzzlesSolved >= 1,
                icon: "star.fill"
            ),
            Achievement(
                title: "Weather Novice",
                description: "Solve 10 puzzles",
                isUnlocked: puzzlesSolved >= 10,
                icon: "cloud.fill"
            ),
            Achievement(
                title: "Perfect Score",
                description: "Answer 5 puzzles perfectly",
                isUnlocked: perfectAnswers >= 5,
                icon: "sparkles"
            ),
            Achievement(
                title: "Point Collector",
                description: "Earn 100 total points",
                isUnlocked: totalScore >= 100,
                icon: "flame.fill"
            ),
            Achievement(
                title: "Sky Master",
                description: "Complete all levels",
                isUnlocked: currentLevel >= 4 && levels.filter({ $0.isCompleted }).count >= 4,
                icon: "crown.fill"
            )
        ]
    }
}

struct Achievement: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let isUnlocked: Bool
    let icon: String
}

