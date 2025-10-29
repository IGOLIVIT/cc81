//
//  WeatherFact.swift
//  cc81
//
//  Created by SkyLearner
//

import Foundation

struct WeatherFact: Identifiable, Codable {
    let id: UUID
    let title: String
    let description: String
    let category: WeatherCategory
    let difficulty: DifficultyLevel
    let funFact: String
    
    init(id: UUID = UUID(), title: String, description: String, category: WeatherCategory, difficulty: DifficultyLevel, funFact: String) {
        self.id = id
        self.title = title
        self.description = description
        self.category = category
        self.difficulty = difficulty
        self.funFact = funFact
    }
}

enum WeatherCategory: String, Codable, CaseIterable {
    case clouds = "Clouds"
    case precipitation = "Precipitation"
    case temperature = "Temperature"
    case wind = "Wind"
    case atmosphere = "Atmosphere"
    case storms = "Storms"
    
    var icon: String {
        switch self {
        case .clouds: return "cloud.fill"
        case .precipitation: return "cloud.rain.fill"
        case .temperature: return "thermometer"
        case .wind: return "wind"
        case .atmosphere: return "globe.americas.fill"
        case .storms: return "cloud.bolt.fill"
        }
    }
}

enum DifficultyLevel: String, Codable, CaseIterable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"
    case expert = "Expert"
}

