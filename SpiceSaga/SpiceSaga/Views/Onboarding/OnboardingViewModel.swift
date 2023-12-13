//
//  OnboardingViewModel.swift
//  SpiceSaga
//
//  Created by Grishma Dave on 18/10/23.
//

import UIKit

struct OnboardingScreens {
    var headline: String
    var subTitle: String
    var isFinished: Bool = false
    var image: UIImage = UIImage(named: "findRecipe")!
}

class OnboardingViewModel {
    
    var arrayOnboardingData: [OnboardingScreens] = [OnboardingScreens]()
    
    init() {
        arrayOnboardingData.append(OnboardingScreens(headline: "Let's\nCooking", subTitle: "EAT, COOK AND ENJOY"))
        arrayOnboardingData.append(OnboardingScreens(headline: "Discover delicious recipie everyday", subTitle: ""))
        arrayOnboardingData.append(OnboardingScreens(headline: "Order Ingreediants", subTitle: "",image: UIImage(named: "Onboarding2")!))
        arrayOnboardingData.append(OnboardingScreens(headline: "Easily save your favorite recipies", subTitle: "",isFinished: true))
    }
}
