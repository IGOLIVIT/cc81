//
//  OnboardingView.swift
//  cc81
//
//  Created by SkyLearner
//

import SwiftUI

struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Page content
                TabView(selection: $viewModel.currentPage) {
                    ForEach(Array(viewModel.pages.enumerated()), id: \.element.id) { index, page in
                        OnboardingPageView(page: page)
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                // Bottom controls
                VStack(spacing: 20) {
                    // Page indicators
                    HStack(spacing: 8) {
                        ForEach(0..<viewModel.pages.count, id: \.self) { index in
                            Circle()
                                .fill(index == viewModel.currentPage ? AppColors.accent : Color.white.opacity(0.3))
                                .frame(width: 8, height: 8)
                        }
                    }
                    .padding(.top, 20)
                    
                    // Navigation buttons
                    HStack(spacing: 16) {
                        if viewModel.currentPage > 0 {
                            Button(action: {
                                viewModel.previousPage()
                            }) {
                                Text(LocalizedStrings.back)
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundColor(AppColors.accent)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(AppColors.secondaryBackground)
                                    .cornerRadius(12)
                            }
                        }
                        
                        Button(action: {
                            if viewModel.currentPage == viewModel.pages.count - 1 {
                                viewModel.completeOnboarding()
                            } else {
                                viewModel.nextPage()
                            }
                        }) {
                            Text(viewModel.currentPage == viewModel.pages.count - 1 ? LocalizedStrings.getStarted : LocalizedStrings.next)
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(AppColors.accent)
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, 40)
                }
            }
        }
    }
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // Icon
            ZStack {
                Circle()
                    .fill(page.color.opacity(0.2))
                    .frame(width: 160, height: 160)
                
                Image(systemName: page.icon)
                    .font(.system(size: 70, weight: .light))
                    .foregroundColor(page.color)
            }
            
            // Text content
            VStack(spacing: 16) {
                Text(page.title)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text(page.description)
                    .font(.system(size: 17))
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .lineSpacing(4)
            }
            
            Spacer()
            Spacer()
        }
    }
}

