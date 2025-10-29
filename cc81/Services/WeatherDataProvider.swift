//
//  WeatherDataProvider.swift
//  cc81
//
//  Created by SkyLearner
//

import Foundation
import Combine

class WeatherDataProvider: ObservableObject {
    @Published var weatherFacts: [WeatherFact] = []
    @Published var allPuzzles: [Puzzle] = []
    @Published var gameLevels: [GameLevel] = []
    
    init() {
        loadWeatherFacts()
        loadPuzzles()
        createGameLevels()
    }
    
    private func loadWeatherFacts() {
        weatherFacts = [
            WeatherFact(
                title: "Clouds are Made of Tiny Droplets",
                description: "Clouds appear solid, but they're actually made up of millions of tiny water droplets or ice crystals suspended in the atmosphere. These droplets are so small and light that they float in the air.",
                category: .clouds,
                difficulty: .beginner,
                funFact: "A single cumulus cloud can weigh as much as 500,000 kg (1.1 million pounds) - the weight of about 100 elephants!"
            ),
            WeatherFact(
                title: "Lightning is Incredibly Hot",
                description: "A lightning bolt can heat the air around it to temperatures five times hotter than the surface of the sun - around 30,000 Kelvin (53,540°F or 29,726°C).",
                category: .storms,
                difficulty: .intermediate,
                funFact: "Thunder is caused by the rapid expansion of air heated by lightning. Light travels faster than sound, which is why you see lightning before you hear thunder."
            ),
            WeatherFact(
                title: "The Water Cycle Never Stops",
                description: "The water in your glass could have been part of a dinosaur's drink millions of years ago. The water cycle continuously moves water between the atmosphere, land, and oceans through evaporation, condensation, and precipitation.",
                category: .precipitation,
                difficulty: .beginner,
                funFact: "Earth has the same amount of water now as it had billions of years ago - it just keeps recycling!"
            ),
            WeatherFact(
                title: "Snowflakes Have Six Sides",
                description: "Every snowflake forms with six-fold symmetry due to the molecular structure of water. While no two snowflakes are exactly alike, they all share this hexagonal pattern.",
                category: .precipitation,
                difficulty: .intermediate,
                funFact: "The largest snowflake ever recorded was 15 inches wide and 8 inches thick, reported in Montana in 1887!"
            ),
            WeatherFact(
                title: "Wind is Air in Motion",
                description: "Wind is created by differences in atmospheric pressure. Air naturally moves from areas of high pressure to areas of low pressure, creating the winds we feel.",
                category: .wind,
                difficulty: .beginner,
                funFact: "The fastest wind speed ever recorded on Earth was 253 mph (408 km/h) during Tropical Cyclone Olivia in 1996."
            ),
            WeatherFact(
                title: "The Atmosphere Has Layers",
                description: "Earth's atmosphere is divided into five main layers: troposphere, stratosphere, mesosphere, thermosphere, and exosphere. Most weather occurs in the troposphere, the lowest layer.",
                category: .atmosphere,
                difficulty: .advanced,
                funFact: "If Earth were the size of an apple, the atmosphere would be thinner than its skin!"
            ),
            WeatherFact(
                title: "Rainbows Require Specific Conditions",
                description: "Rainbows form when sunlight is refracted, reflected, and dispersed in water droplets. You need the sun behind you and rain in front of you to see one.",
                category: .precipitation,
                difficulty: .intermediate,
                funFact: "You can never actually reach the end of a rainbow - it moves as you move!"
            ),
            WeatherFact(
                title: "Humidity Affects How We Feel Temperature",
                description: "High humidity makes hot weather feel even hotter because it slows down the evaporation of sweat from our skin, which is our body's natural cooling mechanism.",
                category: .temperature,
                difficulty: .intermediate,
                funFact: "A temperature of 85°F (29°C) with 90% humidity can feel like 108°F (42°C)!"
            ),
            WeatherFact(
                title: "Tornadoes Rotate Counterclockwise",
                description: "In the Northern Hemisphere, tornadoes typically rotate counterclockwise due to the Coriolis effect. In the Southern Hemisphere, they usually rotate clockwise.",
                category: .storms,
                difficulty: .advanced,
                funFact: "The Enhanced Fujita Scale rates tornadoes from EF0 (weakest) to EF5 (strongest), with EF5 tornadoes having winds over 200 mph!"
            ),
            WeatherFact(
                title: "Fog is a Cloud on the Ground",
                description: "Fog forms when air near the ground cools enough for water vapor to condense into tiny droplets. It's essentially a cloud that forms at ground level.",
                category: .clouds,
                difficulty: .beginner,
                funFact: "The foggiest place on Earth is Grand Banks off Newfoundland, Canada, with fog present about 206 days per year!"
            ),
            WeatherFact(
                title: "Hail Forms in Thunderstorms",
                description: "Hailstones form when raindrops are carried upward by strong thunderstorm updrafts into extremely cold areas of the atmosphere where they freeze. They grow larger with each trip up and down.",
                category: .precipitation,
                difficulty: .advanced,
                funFact: "The largest hailstone ever recorded in the US was 8 inches in diameter and weighed almost 2 pounds!"
            ),
            WeatherFact(
                title: "The Jet Stream Affects Weather",
                description: "The jet stream is a narrow band of strong winds high in the atmosphere that flows from west to east. It plays a crucial role in determining weather patterns and can steer storms.",
                category: .wind,
                difficulty: .expert,
                funFact: "Pilots use the jet stream to save fuel and time - flying with it can cut hours off transcontinental flights!"
            )
        ]
    }
    
    private func loadPuzzles() {
        allPuzzles = [
            // Beginner Level Puzzles
            Puzzle(
                title: "Cloud Identification",
                question: "What type of cloud is fluffy and looks like cotton balls in the sky?",
                correctAnswer: "Cumulus",
                wrongAnswers: ["Stratus", "Cirrus", "Nimbus"],
                weatherCategory: .clouds,
                difficulty: .beginner,
                explanation: "Cumulus clouds are the puffy, cotton-like clouds we often see on fair weather days. They form when warm air rises and condenses.",
                points: 10
            ),
            Puzzle(
                title: "Rain Formation",
                question: "What is the process called when water vapor in the air turns into liquid water?",
                correctAnswer: "Condensation",
                wrongAnswers: ["Evaporation", "Precipitation", "Sublimation"],
                weatherCategory: .precipitation,
                difficulty: .beginner,
                explanation: "Condensation occurs when water vapor cools and changes into liquid water, forming clouds and eventually rain.",
                points: 10
            ),
            Puzzle(
                title: "Temperature Basics",
                question: "At what temperature does water freeze?",
                correctAnswer: "0°C (32°F)",
                wrongAnswers: ["10°C (50°F)", "-10°C (14°F)", "5°C (41°F)"],
                weatherCategory: .temperature,
                difficulty: .beginner,
                explanation: "Water freezes at 0 degrees Celsius or 32 degrees Fahrenheit, turning from liquid to solid ice.",
                points: 10
            ),
            
            // Intermediate Level Puzzles
            Puzzle(
                title: "Thunderstorm Science",
                question: "What causes thunder?",
                correctAnswer: "Rapid expansion of heated air",
                wrongAnswers: ["Clouds colliding", "Rain falling fast", "Wind moving quickly"],
                weatherCategory: .storms,
                difficulty: .intermediate,
                explanation: "Thunder is the sound caused by lightning rapidly heating the air around it, causing it to expand faster than the speed of sound.",
                points: 20
            ),
            Puzzle(
                title: "Wind Patterns",
                question: "What causes wind?",
                correctAnswer: "Differences in air pressure",
                wrongAnswers: ["Earth's rotation", "Ocean currents", "Mountain ranges"],
                weatherCategory: .wind,
                difficulty: .intermediate,
                explanation: "Wind is caused by air moving from areas of high pressure to areas of low pressure, trying to equalize the pressure difference.",
                points: 20
            ),
            Puzzle(
                title: "Atmospheric Layers",
                question: "In which atmospheric layer does most weather occur?",
                correctAnswer: "Troposphere",
                wrongAnswers: ["Stratosphere", "Mesosphere", "Thermosphere"],
                weatherCategory: .atmosphere,
                difficulty: .intermediate,
                explanation: "The troposphere is the lowest layer of Earth's atmosphere where all weather phenomena occur.",
                points: 20
            ),
            
            // Advanced Level Puzzles
            Puzzle(
                title: "Hurricane Formation",
                question: "What is the minimum ocean temperature needed for hurricane formation?",
                correctAnswer: "26.5°C (80°F)",
                wrongAnswers: ["20°C (68°F)", "30°C (86°F)", "15°C (59°F)"],
                weatherCategory: .storms,
                difficulty: .advanced,
                explanation: "Hurricanes require warm ocean water of at least 26.5°C (80°F) to provide the energy needed for formation and intensification.",
                points: 30
            ),
            Puzzle(
                title: "Coriolis Effect",
                question: "The Coriolis effect is caused by what?",
                correctAnswer: "Earth's rotation",
                wrongAnswers: ["Ocean currents", "Solar radiation", "Moon's gravity"],
                weatherCategory: .atmosphere,
                difficulty: .advanced,
                explanation: "The Coriolis effect is the deflection of moving objects caused by Earth's rotation, affecting wind patterns and storm rotation.",
                points: 30
            ),
            Puzzle(
                title: "Cloud Heights",
                question: "Which clouds form at the highest altitude?",
                correctAnswer: "Cirrus",
                wrongAnswers: ["Cumulus", "Stratus", "Nimbostratus"],
                weatherCategory: .clouds,
                difficulty: .advanced,
                explanation: "Cirrus clouds form at high altitudes (above 20,000 feet) and are composed of ice crystals, appearing thin and wispy.",
                points: 30
            ),
            
            // Expert Level Puzzles
            Puzzle(
                title: "Jet Stream Dynamics",
                question: "What primarily drives the jet stream?",
                correctAnswer: "Temperature differences between air masses",
                wrongAnswers: ["Ocean currents", "Mountain ranges", "Earth's magnetic field"],
                weatherCategory: .wind,
                difficulty: .expert,
                explanation: "The jet stream is driven by temperature differences between polar and tropical air masses, combined with Earth's rotation.",
                points: 40
            ),
            Puzzle(
                title: "Dew Point Science",
                question: "What does the dew point temperature indicate?",
                correctAnswer: "Temperature at which air becomes saturated",
                wrongAnswers: ["Highest temperature of the day", "Average daily temperature", "Freezing point of rain"],
                weatherCategory: .temperature,
                difficulty: .expert,
                explanation: "Dew point is the temperature to which air must cool for water vapor to condense into dew. Higher dew points indicate more moisture.",
                points: 40
            ),
            Puzzle(
                title: "Atmospheric Pressure",
                question: "What is standard atmospheric pressure at sea level?",
                correctAnswer: "1013.25 millibars",
                wrongAnswers: ["1000 millibars", "1050 millibars", "980 millibars"],
                weatherCategory: .atmosphere,
                difficulty: .expert,
                explanation: "Standard atmospheric pressure at sea level is 1013.25 millibars (or 29.92 inches of mercury), used as a reference for weather measurements.",
                points: 40
            )
        ]
    }
    
    private func createGameLevels() {
        let beginnerPuzzles = allPuzzles.filter { $0.difficulty == .beginner }
        let intermediatePuzzles = allPuzzles.filter { $0.difficulty == .intermediate }
        let advancedPuzzles = allPuzzles.filter { $0.difficulty == .advanced }
        let expertPuzzles = allPuzzles.filter { $0.difficulty == .expert }
        
        gameLevels = [
            GameLevel(
                levelNumber: 1,
                title: "Troposphere Explorer",
                puzzles: beginnerPuzzles,
                requiredScore: 20,
                isUnlocked: true
            ),
            GameLevel(
                levelNumber: 2,
                title: "Stratosphere Challenger",
                puzzles: intermediatePuzzles,
                requiredScore: 40
            ),
            GameLevel(
                levelNumber: 3,
                title: "Mesosphere Master",
                puzzles: advancedPuzzles,
                requiredScore: 60
            ),
            GameLevel(
                levelNumber: 4,
                title: "Thermosphere Expert",
                puzzles: expertPuzzles,
                requiredScore: 80
            )
        ]
    }
    
    func getWeatherFactsByCategory(_ category: WeatherCategory) -> [WeatherFact] {
        return weatherFacts.filter { $0.category == category }
    }
    
    func getRandomWeatherFact() -> WeatherFact? {
        return weatherFacts.randomElement()
    }
}

