//
//  WeatherFactsView.swift
//  cc81
//
//  Created by SkyLearner
//

import SwiftUI

struct WeatherFactsView: View {
    @StateObject private var viewModel: WeatherFactsViewModel
    
    init(weatherDataProvider: WeatherDataProvider) {
        _viewModel = StateObject(wrappedValue: WeatherFactsViewModel(weatherDataProvider: weatherDataProvider))
    }
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Search bar
                HStack(spacing: 12) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.white.opacity(0.5))
                    
                    TextField(LocalizedStrings.search, text: $viewModel.searchText)
                        .foregroundColor(.white)
                        .font(.system(size: 16))
                    
                    if !viewModel.searchText.isEmpty {
                        Button(action: {
                            viewModel.clearSearch()
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.white.opacity(0.5))
                        }
                    }
                }
                .padding(12)
                .background(AppColors.secondaryBackground)
                .cornerRadius(12)
                .padding(.horizontal, 20)
                .padding(.top, 16)
                
                // Category filters
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        CategoryChip(
                            title: LocalizedStrings.allCategories,
                            icon: "square.grid.2x2.fill",
                            isSelected: viewModel.selectedCategory == nil,
                            action: {
                                viewModel.selectCategory(nil)
                            }
                        )
                        
                        ForEach(WeatherCategory.allCases, id: \.self) { category in
                            CategoryChip(
                                title: category.rawValue,
                                icon: category.icon,
                                isSelected: viewModel.selectedCategory == category,
                                action: {
                                    viewModel.selectCategory(category)
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.vertical, 16)
                
                // Facts list
                if viewModel.filteredFacts.isEmpty {
                    Spacer()
                    VStack(spacing: 12) {
                        Image(systemName: "cloud.drizzle")
                            .font(.system(size: 50))
                            .foregroundColor(.white.opacity(0.3))
                        Text("No facts found")
                            .font(.system(size: 17))
                            .foregroundColor(.white.opacity(0.6))
                    }
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.filteredFacts) { fact in
                                WeatherFactCard(fact: fact)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                    }
                }
            }
        }
    }
}

struct CategoryChip: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 14))
                Text(title)
                    .font(.system(size: 14, weight: .medium))
            }
            .foregroundColor(isSelected ? .white : .white.opacity(0.7))
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(isSelected ? AppColors.accent : AppColors.secondaryBackground)
            .cornerRadius(20)
        }
    }
}

struct WeatherFactCard: View {
    let fact: WeatherFact
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: fact.category.icon)
                        .font(.system(size: 16))
                    Text(fact.category.rawValue)
                        .font(.system(size: 13, weight: .medium))
                }
                .foregroundColor(AppColors.accent)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(AppColors.accent.opacity(0.2))
                .cornerRadius(12)
                
                Spacer()
                
                DifficultyBadge(difficulty: fact.difficulty)
            }
            
            // Title
            Text(fact.title)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            
            // Description
            Text(fact.description)
                .font(.system(size: 15))
                .foregroundColor(.white.opacity(0.8))
                .lineSpacing(4)
            
            // Fun fact section
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 6) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 14))
                    Text(LocalizedStrings.funFact)
                        .font(.system(size: 14, weight: .semibold))
                }
                .foregroundColor(AppColors.accent)
                
                Text(fact.funFact)
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.9))
                    .lineSpacing(4)
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(AppColors.background)
            .cornerRadius(12)
        }
        .padding(16)
        .background(AppColors.secondaryBackground)
        .cornerRadius(16)
    }
}

struct DifficultyBadge: View {
    let difficulty: DifficultyLevel
    
    var color: Color {
        switch difficulty {
        case .beginner:
            return .green
        case .intermediate:
            return .yellow
        case .advanced:
            return .orange
        case .expert:
            return .red
        }
    }
    
    var body: some View {
        Text(difficulty.rawValue)
            .font(.system(size: 12, weight: .medium))
            .foregroundColor(color)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(color.opacity(0.2))
            .cornerRadius(8)
    }
}

