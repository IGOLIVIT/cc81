//
//  SettingsViewModel.swift
//  cc81
//
//  Created by SkyLearner
//

import Foundation
import SwiftUI
import Combine

class SettingsViewModel: ObservableObject {
    @Published var progressTracker: GameProgressTracker
    @Published var showingDeleteConfirmation = false
    @Published var showingResetSuccess = false
    
    @AppStorage("soundEnabled") var soundEnabled: Bool = true
    @AppStorage("notificationsEnabled") var notificationsEnabled: Bool = false
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false
    @AppStorage("playerName") var playerName: String = "Weather Explorer"
    
    init(progressTracker: GameProgressTracker) {
        self.progressTracker = progressTracker
    }
    
    func deleteAccount() {
        // Reset all progress
        progressTracker.resetProgress()
        
        // Reset settings
        soundEnabled = true
        notificationsEnabled = false
        hasCompletedOnboarding = false
        playerName = "Weather Explorer"
        
        showingResetSuccess = true
    }
    
    func toggleSound() {
        soundEnabled.toggle()
    }
    
    func toggleNotifications() {
        notificationsEnabled.toggle()
    }
    
    func updatePlayerName(_ name: String) {
        playerName = name.isEmpty ? "Weather Explorer" : name
    }
    
    var statsInfo: [(String, String)] {
        return [
            ("Total Score", "\(progressTracker.totalScore)"),
            ("Puzzles Solved", "\(progressTracker.puzzlesSolved)"),
            ("Perfect Answers", "\(progressTracker.perfectAnswers)"),
            ("Current Level", "Level \(progressTracker.currentLevel)")
        ]
    }
}

