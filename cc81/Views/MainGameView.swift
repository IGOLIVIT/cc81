//
//  MainGameView.swift
//  cc81
//
//  Created by SkyLearner
//

import SwiftUI

struct MainGameView: View {
    @StateObject private var viewModel = MainGameViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Custom Navigation Bar
                    HStack {
                        Text(LocalizedStrings.appTitle)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        // Score indicator
                        HStack(spacing: 6) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                                .font(.system(size: 16))
                            Text("\(viewModel.progressTracker.totalScore)")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(AppColors.secondaryBackground)
                        .cornerRadius(20)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .background(AppColors.background)
                    
                    // Tab Content
                    TabView(selection: $selectedTab) {
                        LevelSelectionView(viewModel: viewModel)
                            .tag(0)
                        
                        WeatherFactsView(weatherDataProvider: viewModel.weatherDataProvider)
                            .tag(1)
                        
                        SettingsView(progressTracker: viewModel.progressTracker)
                            .tag(2)
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    
                    // Custom Tab Bar
                    HStack(spacing: 0) {
                        TabBarButton(icon: "gamecontroller.fill", title: "Play", isSelected: selectedTab == 0) {
                            selectedTab = 0
                        }
                        
                        TabBarButton(icon: "book.fill", title: "Learn", isSelected: selectedTab == 1) {
                            selectedTab = 1
                        }
                        
                        TabBarButton(icon: "gearshape.fill", title: "Settings", isSelected: selectedTab == 2) {
                            selectedTab = 2
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    .padding(.bottom, 20)
                    .background(AppColors.secondaryBackground)
                }
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct TabBarButton: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                Text(title)
                    .font(.system(size: 12, weight: .medium))
            }
            .foregroundColor(isSelected ? AppColors.accent : .white.opacity(0.5))
            .frame(maxWidth: .infinity)
        }
    }
}

struct LevelSelectionView: View {
    @ObservedObject var viewModel: MainGameViewModel
    @State private var selectedLevel: GameLevel?
    @State private var showingPuzzle = false
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Progress overview
                    VStack(spacing: 12) {
                        Text("Your Journey Through the Atmosphere")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                        
                        HStack(spacing: 20) {
                            StatBadge(
                                icon: "checkmark.circle.fill",
                                value: "\(viewModel.getCompletedLevelsCount())/\(viewModel.getTotalLevelsCount())",
                                label: "Levels"
                            )
                            
                            StatBadge(
                                icon: "puzzlepiece.fill",
                                value: "\(viewModel.progressTracker.puzzlesSolved)",
                                label: "Puzzles"
                            )
                            
                            StatBadge(
                                icon: "flame.fill",
                                value: "\(viewModel.progressTracker.totalScore)",
                                label: "Points"
                            )
                        }
                    }
                    .padding(20)
                    .background(AppColors.secondaryBackground)
                    .cornerRadius(16)
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    // Level cards
                    VStack(spacing: 16) {
                        ForEach(viewModel.progressTracker.levels) { level in
                            LevelCard(level: level) {
                                if level.isUnlocked {
                                    selectedLevel = level
                                    showingPuzzle = true
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
            
            if showingPuzzle, let level = selectedLevel {
                PuzzleView(
                    level: level,
                    progressTracker: viewModel.progressTracker,
                    isPresented: $showingPuzzle
                )
                .transition(.move(edge: .trailing))
            }
        }
        .onAppear {
            viewModel.refreshLevels()
        }
    }
}

struct StatBadge: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(AppColors.accent)
            
            Text(value)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
            
            Text(label)
                .font(.system(size: 12))
                .foregroundColor(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
    }
}

struct LevelCard: View {
    let level: GameLevel
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Level icon
                ZStack {
                    Circle()
                        .fill(level.isUnlocked ? AppColors.accent.opacity(0.2) : Color.white.opacity(0.1))
                        .frame(width: 60, height: 60)
                    
                    if level.isCompleted {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.green)
                    } else if level.isUnlocked {
                        Text("\(level.levelNumber)")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(AppColors.accent)
                    } else {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.white.opacity(0.3))
                    }
                }
                
                // Level info
                VStack(alignment: .leading, spacing: 6) {
                    Text(level.title)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(level.isUnlocked ? .white : .white.opacity(0.5))
                    
                    Text("\(level.puzzles.count) Puzzles")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.6))
                    
                    if level.isCompleted {
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                                .font(.system(size: 12))
                            Text("Score: \(level.playerScore)")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.yellow)
                        }
                    }
                }
                
                Spacer()
                
                // Arrow
                if level.isUnlocked {
                    Image(systemName: "chevron.right")
                        .foregroundColor(AppColors.accent)
                        .font(.system(size: 16, weight: .semibold))
                }
            }
            .padding(16)
            .background(level.isUnlocked ? AppColors.secondaryBackground : AppColors.background)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(level.isUnlocked ? AppColors.accent.opacity(0.3) : Color.clear, lineWidth: 1)
            )
        }
        .disabled(!level.isUnlocked)
    }
}

