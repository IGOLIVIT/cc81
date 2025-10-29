//
//  SettingsView.swift
//  cc81
//
//  Created by SkyLearner
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel: SettingsViewModel
    @State private var editingName = false
    @State private var tempPlayerName = ""
    
    init(progressTracker: GameProgressTracker) {
        _viewModel = StateObject(wrappedValue: SettingsViewModel(progressTracker: progressTracker))
    }
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Profile section
                    VStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(AppColors.accent.opacity(0.2))
                                .frame(width: 100, height: 100)
                            
                            Text(String(viewModel.playerName.prefix(2)).uppercased())
                                .font(.system(size: 36, weight: .bold))
                                .foregroundColor(AppColors.accent)
                        }
                        
                        if editingName {
                            HStack {
                                TextField("Player Name", text: $tempPlayerName)
                                    .font(.system(size: 18))
                                    .foregroundColor(.white)
                                    .padding(12)
                                    .background(AppColors.background)
                                    .cornerRadius(8)
                                
                                Button(action: {
                                    viewModel.updatePlayerName(tempPlayerName)
                                    editingName = false
                                }) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 24))
                                        .foregroundColor(.green)
                                }
                            }
                            .padding(.horizontal, 20)
                        } else {
                            HStack {
                                Text(viewModel.playerName)
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundColor(.white)
                                
                                Button(action: {
                                    tempPlayerName = viewModel.playerName
                                    editingName = true
                                }) {
                                    Image(systemName: "pencil.circle.fill")
                                        .font(.system(size: 20))
                                        .foregroundColor(AppColors.accent)
                                }
                            }
                        }
                    }
                    .padding(.top, 30)
                    
                    // Stats section
                    VStack(alignment: .leading, spacing: 16) {
                        Text(LocalizedStrings.stats)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                        
                        VStack(spacing: 12) {
                            ForEach(viewModel.statsInfo, id: \.0) { stat in
                                HStack {
                                    Text(stat.0)
                                        .font(.system(size: 16))
                                        .foregroundColor(.white.opacity(0.8))
                                    
                                    Spacer()
                                    
                                    Text(stat.1)
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(AppColors.accent)
                                }
                                .padding(.vertical, 12)
                                .padding(.horizontal, 20)
                                .background(AppColors.secondaryBackground)
                                .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    // Achievements section
                    VStack(alignment: .leading, spacing: 16) {
                        Text(LocalizedStrings.achievements)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                        
                        VStack(spacing: 12) {
                            ForEach(viewModel.progressTracker.getAchievementProgress()) { achievement in
                                AchievementCard(achievement: achievement)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    // Preferences section
                    VStack(alignment: .leading, spacing: 16) {
                        Text(LocalizedStrings.preferences)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                        
                        VStack(spacing: 0) {
                            SettingsToggle(
                                icon: "speaker.wave.2.fill",
                                title: LocalizedStrings.sound,
                                isOn: $viewModel.soundEnabled
                            )
                            
                            Divider()
                                .background(Color.white.opacity(0.1))
                                .padding(.leading, 60)
                            
                            SettingsToggle(
                                icon: "bell.fill",
                                title: LocalizedStrings.notifications,
                                isOn: $viewModel.notificationsEnabled
                            )
                        }
                        .background(AppColors.secondaryBackground)
                        .cornerRadius(12)
                        .padding(.horizontal, 20)
                    }
                    
                    // Account section
                    VStack(alignment: .leading, spacing: 16) {
                        Text(LocalizedStrings.account)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                        
                        Button(action: {
                            viewModel.showingDeleteConfirmation = true
                        }) {
                            HStack {
                                Image(systemName: "trash.fill")
                                    .font(.system(size: 18))
                                Text(LocalizedStrings.deleteAccount)
                                    .font(.system(size: 16, weight: .medium))
                            }
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(AppColors.secondaryBackground)
                            .cornerRadius(12)
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    // Version info
                    Text("SkyLearner v1.0")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.4))
                        .padding(.top, 20)
                        .padding(.bottom, 30)
                }
            }
        }
        .alert("Delete Account", isPresented: $viewModel.showingDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                viewModel.deleteAccount()
            }
        } message: {
            Text("This will reset all your progress and settings. This action cannot be undone.")
        }
        .alert("Account Reset", isPresented: $viewModel.showingResetSuccess) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Your account has been reset successfully. Your progress has been cleared.")
        }
    }
}

struct SettingsToggle: View {
    let icon: String
    let title: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(AppColors.accent)
                .frame(width: 28)
            
            Text(title)
                .font(.system(size: 16))
                .foregroundColor(.white)
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .toggleStyle(SwitchToggleStyle(tint: AppColors.accent))
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
}

struct AchievementCard: View {
    let achievement: Achievement
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(achievement.isUnlocked ? AppColors.accent.opacity(0.2) : Color.white.opacity(0.1))
                    .frame(width: 50, height: 50)
                
                Image(systemName: achievement.icon)
                    .font(.system(size: 22))
                    .foregroundColor(achievement.isUnlocked ? AppColors.accent : .white.opacity(0.3))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(achievement.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(achievement.isUnlocked ? .white : .white.opacity(0.5))
                
                Text(achievement.description)
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.6))
            }
            
            Spacer()
            
            if achievement.isUnlocked {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 22))
                    .foregroundColor(.green)
            } else {
                Image(systemName: "lock.fill")
                    .font(.system(size: 18))
                    .foregroundColor(.white.opacity(0.3))
            }
        }
        .padding(16)
        .background(AppColors.secondaryBackground)
        .cornerRadius(12)
    }
}

