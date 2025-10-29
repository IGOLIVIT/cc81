//
//  OnboardingViewModel.swift
//  cc81
//
//  Created by SkyLearner
//

import Foundation
import SwiftUI
import Combine

class OnboardingViewModel: ObservableObject {
    @Published var currentPage = 0
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false
    
    let pages: [OnboardingPage] = [
        OnboardingPage(
            title: "Welcome to SkyLearner",
            description: "Embark on an epic journey through Earth's atmosphere while learning amazing weather facts!",
            icon: "cloud.sun.fill",
            color: Color(hex: "01A2FF")
        ),
        OnboardingPage(
            title: "Solve Weather Puzzles",
            description: "Challenge yourself with engaging puzzles across different atmospheric layers. Each correct answer brings you closer to mastery!",
            icon: "puzzlepiece.fill",
            color: Color(hex: "01A2FF")
        ),
        OnboardingPage(
            title: "Learn Real Science",
            description: "Discover fascinating weather facts, from lightning to clouds, hurricanes to snowflakes. Real education meets fun gameplay!",
            icon: "book.fill",
            color: Color(hex: "01A2FF")
        ),
        OnboardingPage(
            title: "Track Your Progress",
            description: "Unlock achievements, climb through atmospheric levels, and become a true weather expert!",
            icon: "chart.line.uptrend.xyaxis",
            color: Color(hex: "01A2FF")
        )
    ]
    
    func completeOnboarding() {
        hasCompletedOnboarding = true
    }
    
    func nextPage() {
        if currentPage < pages.count - 1 {
            withAnimation {
                currentPage += 1
            }
        }
    }
    
    func previousPage() {
        if currentPage > 0 {
            withAnimation {
                currentPage -= 1
            }
        }
    }
}

struct OnboardingPage: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let icon: String
    let color: Color
}

