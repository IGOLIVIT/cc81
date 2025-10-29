//
//  MainGameViewModel.swift
//  cc81
//
//  Created by SkyLearner
//

import Foundation
import SwiftUI
import Combine

class MainGameViewModel: ObservableObject {
    @Published var weatherDataProvider: WeatherDataProvider
    @Published var progressTracker: GameProgressTracker
    @Published var currentLevel: GameLevel?
    @Published var selectedLevel: GameLevel?
    @Published var showingLevelSelection = false
    
    init() {
        self.weatherDataProvider = WeatherDataProvider()
        self.progressTracker = GameProgressTracker()
        
        // Initialize levels if needed
        if progressTracker.levels.isEmpty {
            progressTracker.updateLevels(weatherDataProvider.gameLevels)
        }
        
        // Load current level
        if let level = progressTracker.levels.first(where: { $0.isUnlocked && !$0.isCompleted }) {
            self.currentLevel = level
        } else if let firstLevel = progressTracker.levels.first {
            self.currentLevel = firstLevel
        }
    }
    
    func selectLevel(_ level: GameLevel) {
        selectedLevel = level
    }
    
    func refreshLevels() {
        let updatedLevels = weatherDataProvider.gameLevels
        
        // Merge progress from saved levels
        var mergedLevels: [GameLevel] = []
        for updatedLevel in updatedLevels {
            if let savedLevel = progressTracker.levels.first(where: { $0.levelNumber == updatedLevel.levelNumber }) {
                var level = updatedLevel
                level.isUnlocked = savedLevel.isUnlocked
                level.isCompleted = savedLevel.isCompleted
                level.playerScore = savedLevel.playerScore
                mergedLevels.append(level)
            } else {
                mergedLevels.append(updatedLevel)
            }
        }
        
        progressTracker.updateLevels(mergedLevels)
    }
    
    func getUnlockedLevels() -> [GameLevel] {
        return progressTracker.levels.filter { $0.isUnlocked }
    }
    
    func getCompletedLevelsCount() -> Int {
        return progressTracker.levels.filter { $0.isCompleted }.count
    }
    
    func getTotalLevelsCount() -> Int {
        return progressTracker.levels.count
    }
}

