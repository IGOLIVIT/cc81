//
//  PuzzleView.swift
//  cc81
//
//  Created by SkyLearner
//

import SwiftUI

struct PuzzleView: View {
    let level: GameLevel
    @ObservedObject var progressTracker: GameProgressTracker
    @Binding var isPresented: Bool
    
    @State private var currentPuzzleIndex = 0
    @State private var selectedAnswer: String?
    @State private var showingExplanation = false
    @State private var isCorrect = false
    @State private var levelScore = 0
    @State private var answeredPuzzles: Set<UUID> = []
    @State private var showingCompletion = false
    @State private var shuffledAnswers: [String] = []
    
    var currentPuzzle: Puzzle? {
        guard currentPuzzleIndex < level.puzzles.count else { return nil }
        return level.puzzles[currentPuzzleIndex]
    }
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Navigation bar
                HStack {
                    Button(action: {
                        isPresented = false
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .font(.system(size: 17))
                        .foregroundColor(AppColors.accent)
                    }
                    
                    Spacer()
                    
                    Text(level.title)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    HStack(spacing: 6) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.system(size: 14))
                        Text("\(levelScore)")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(AppColors.secondaryBackground)
                
                if let puzzle = currentPuzzle {
                    ScrollView {
                        VStack(spacing: 24) {
                            // Progress indicator
                            VStack(spacing: 8) {
                                HStack(spacing: 4) {
                                    ForEach(0..<level.puzzles.count, id: \.self) { index in
                                        Rectangle()
                                            .fill(index < currentPuzzleIndex ? Color.green : (index == currentPuzzleIndex ? AppColors.accent : Color.white.opacity(0.3)))
                                            .frame(height: 4)
                                    }
                                }
                                
                                Text("Puzzle \(currentPuzzleIndex + 1) of \(level.puzzles.count)")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white.opacity(0.6))
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                            
                            // Category badge
                            HStack(spacing: 8) {
                                Image(systemName: puzzle.weatherCategory.icon)
                                    .font(.system(size: 14))
                                Text(puzzle.weatherCategory.rawValue)
                                    .font(.system(size: 14, weight: .medium))
                            }
                            .foregroundColor(AppColors.accent)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(AppColors.accent.opacity(0.2))
                            .cornerRadius(20)
                            
                            // Question
                            VStack(alignment: .leading, spacing: 12) {
                                Text(puzzle.title)
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.white)
                                
                                Text(puzzle.question)
                                    .font(.system(size: 17))
                                    .foregroundColor(.white.opacity(0.9))
                                    .lineSpacing(4)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(20)
                            .background(AppColors.secondaryBackground)
                            .cornerRadius(16)
                            .padding(.horizontal, 20)
                            
                            // Answer options
                            VStack(spacing: 12) {
                                ForEach(shuffledAnswers, id: \.self) { answer in
                                    AnswerButton(
                                        answer: answer,
                                        isSelected: selectedAnswer == answer,
                                        isCorrect: showingExplanation ? answer == puzzle.correctAnswer : nil,
                                        action: {
                                            if !showingExplanation {
                                                selectedAnswer = answer
                                            }
                                        }
                                    )
                                }
                            }
                            .padding(.horizontal, 20)
                            
                            // Submit/Next button
                            if !showingExplanation {
                                Button(action: submitAnswer) {
                                    Text(LocalizedStrings.submit)
                                        .font(.system(size: 17, weight: .semibold))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 16)
                                        .background(selectedAnswer != nil ? AppColors.accent : AppColors.accent.opacity(0.5))
                                        .cornerRadius(12)
                                }
                                .disabled(selectedAnswer == nil)
                                .padding(.horizontal, 20)
                            }
                            
                            // Explanation
                            if showingExplanation {
                                VStack(alignment: .leading, spacing: 16) {
                                    HStack(spacing: 12) {
                                        Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                                            .font(.system(size: 32))
                                            .foregroundColor(isCorrect ? .green : .red)
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(isCorrect ? "Correct!" : "Not quite right")
                                                .font(.system(size: 20, weight: .bold))
                                                .foregroundColor(.white)
                                            
                                            Text(isCorrect ? "+\(puzzle.points) points" : "Keep learning!")
                                                .font(.system(size: 14))
                                                .foregroundColor(.white.opacity(0.7))
                                        }
                                    }
                                    
                                    Divider()
                                        .background(Color.white.opacity(0.2))
                                    
                                    Text("Explanation")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.white)
                                    
                                    Text(puzzle.explanation)
                                        .font(.system(size: 15))
                                        .foregroundColor(.white.opacity(0.8))
                                        .lineSpacing(4)
                                }
                                .padding(20)
                                .background(AppColors.secondaryBackground)
                                .cornerRadius(16)
                                .padding(.horizontal, 20)
                                
                                Button(action: nextPuzzle) {
                                    Text(currentPuzzleIndex < level.puzzles.count - 1 ? LocalizedStrings.nextPuzzle : LocalizedStrings.completeLevel)
                                        .font(.system(size: 17, weight: .semibold))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 16)
                                        .background(AppColors.accent)
                                        .cornerRadius(12)
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                        .padding(.bottom, 30)
                    }
                } else {
                    Spacer()
                    Text("No puzzles available")
                        .foregroundColor(.white.opacity(0.6))
                    Spacer()
                }
            }
            
            if showingCompletion {
                LevelCompletionView(
                    level: level,
                    score: levelScore,
                    totalPossibleScore: level.puzzles.reduce(0) { $0 + $1.points },
                    onDismiss: {
                        showingCompletion = false
                        isPresented = false
                    }
                )
            }
        }
        .onAppear {
            if let puzzle = currentPuzzle {
                shuffledAnswers = ([puzzle.correctAnswer] + puzzle.wrongAnswers).shuffled()
            }
        }
    }
    
    private func submitAnswer() {
        guard let puzzle = currentPuzzle, let answer = selectedAnswer else { return }
        
        isCorrect = answer == puzzle.correctAnswer
        
        if isCorrect {
            levelScore += puzzle.points
            progressTracker.addScore(puzzle.points)
            progressTracker.incrementPerfectAnswers()
        }
        
        progressTracker.incrementPuzzlesSolved()
        answeredPuzzles.insert(puzzle.id)
        
        withAnimation {
            showingExplanation = true
        }
    }
    
    private func nextPuzzle() {
        if currentPuzzleIndex < level.puzzles.count - 1 {
            currentPuzzleIndex += 1
            selectedAnswer = nil
            showingExplanation = false
            isCorrect = false
            
            if let puzzle = currentPuzzle {
                shuffledAnswers = ([puzzle.correctAnswer] + puzzle.wrongAnswers).shuffled()
            }
        } else {
            // Level complete
            progressTracker.completeLevel(level.levelNumber, score: levelScore)
            showingCompletion = true
        }
    }
}

struct AnswerButton: View {
    let answer: String
    let isSelected: Bool
    let isCorrect: Bool?
    let action: () -> Void
    
    var backgroundColor: Color {
        if let isCorrect = isCorrect {
            return isCorrect ? Color.green.opacity(0.2) : (isSelected ? Color.red.opacity(0.2) : AppColors.secondaryBackground)
        }
        return isSelected ? AppColors.accent.opacity(0.3) : AppColors.secondaryBackground
    }
    
    var borderColor: Color {
        if let isCorrect = isCorrect {
            return isCorrect ? Color.green : (isSelected ? Color.red : Color.clear)
        }
        return isSelected ? AppColors.accent : Color.clear
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(answer)
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                if let isCorrect = isCorrect {
                    Image(systemName: isCorrect ? "checkmark.circle.fill" : (isSelected ? "xmark.circle.fill" : "circle"))
                        .foregroundColor(isCorrect ? .green : (isSelected ? .red : .white.opacity(0.3)))
                } else if isSelected {
                    Image(systemName: "circle.fill")
                        .foregroundColor(AppColors.accent)
                        .font(.system(size: 12))
                } else {
                    Image(systemName: "circle")
                        .foregroundColor(.white.opacity(0.3))
                }
            }
            .padding(16)
            .background(backgroundColor)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(borderColor, lineWidth: 2)
            )
        }
    }
}

struct LevelCompletionView: View {
    let level: GameLevel
    let score: Int
    let totalPossibleScore: Int
    let onDismiss: () -> Void
    
    var scorePercentage: Double {
        return Double(score) / Double(totalPossibleScore)
    }
    
    var performanceMessage: String {
        if scorePercentage >= 0.9 {
            return "Outstanding! You're a weather expert!"
        } else if scorePercentage >= 0.7 {
            return "Great job! You know your weather!"
        } else if scorePercentage >= 0.5 {
            return "Good effort! Keep learning!"
        } else {
            return "Nice try! Review the facts and try again!"
        }
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                // Icon
                ZStack {
                    Circle()
                        .fill(AppColors.accent.opacity(0.2))
                        .frame(width: 120, height: 120)
                    
                    Image(systemName: "trophy.fill")
                        .font(.system(size: 60))
                        .foregroundColor(AppColors.accent)
                }
                
                // Text
                VStack(spacing: 12) {
                    Text(LocalizedStrings.levelComplete)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text(level.title)
                        .font(.system(size: 18))
                        .foregroundColor(.white.opacity(0.8))
                    
                    Text(performanceMessage)
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                
                // Score
                VStack(spacing: 8) {
                    HStack(spacing: 8) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.system(size: 24))
                        Text("\(score)")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                    }
                    
                    Text("out of \(totalPossibleScore) points")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.6))
                }
                .padding(20)
                .background(AppColors.secondaryBackground)
                .cornerRadius(16)
                
                // Continue button
                Button(action: onDismiss) {
                    Text("Continue")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(AppColors.accent)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 40)
            }
            .padding(30)
            .background(AppColors.background)
            .cornerRadius(24)
            .padding(.horizontal, 40)
        }
    }
}

