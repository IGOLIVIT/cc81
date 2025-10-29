//
//  WeatherFactsViewModel.swift
//  cc81
//
//  Created by SkyLearner
//

import Foundation
import SwiftUI
import Combine

class WeatherFactsViewModel: ObservableObject {
    @Published var weatherDataProvider: WeatherDataProvider
    @Published var selectedCategory: WeatherCategory?
    @Published var searchText: String = ""
    
    init(weatherDataProvider: WeatherDataProvider) {
        self.weatherDataProvider = weatherDataProvider
    }
    
    var filteredFacts: [WeatherFact] {
        var facts = weatherDataProvider.weatherFacts
        
        // Filter by category if selected
        if let category = selectedCategory {
            facts = facts.filter { $0.category == category }
        }
        
        // Filter by search text
        if !searchText.isEmpty {
            facts = facts.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.description.localizedCaseInsensitiveContains(searchText) ||
                $0.funFact.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return facts
    }
    
    func selectCategory(_ category: WeatherCategory?) {
        selectedCategory = category
    }
    
    func clearSearch() {
        searchText = ""
    }
    
    func getFactsByDifficulty(_ difficulty: DifficultyLevel) -> [WeatherFact] {
        return weatherDataProvider.weatherFacts.filter { $0.difficulty == difficulty }
    }
}

