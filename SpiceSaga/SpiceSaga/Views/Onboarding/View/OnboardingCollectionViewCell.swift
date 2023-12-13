//
//  OnboardingCollectionViewCell.swift
//  SpiceSaga
//
//  Created by Grishma Dave on 18/10/23.
//

import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var lableHeadline: UILabel?
    @IBOutlet private weak var lableSubtitle: UILabel?
    @IBOutlet private weak var buttonNextFinshed: UIButton?
    @IBOutlet private weak var imageViewOnboarding: UIImageView?
    var didSelectedNextFinish:(() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var onboarding: OnboardingScreens?{
        didSet {
            lableHeadline?.text = onboarding?.headline
            lableSubtitle?.text = onboarding?.subTitle
            if onboarding?.isFinished ?? false {
                buttonNextFinshed?.setTitle("Finish", for: .normal)
            }
            imageViewOnboarding?.image = onboarding?.image
        }
    }
    
    @IBAction private func didTapOnNextFinsh() {
        didSelectedNextFinish?()
    }
}
