//
//  OnboardingViewController.swift
//  SpiceSaga
//
//  Created by psagc on 18/10/23.
//

import UIKit

class OnboardingViewController: UIViewController {

    @IBOutlet private weak var collectionViewOnboarding: UICollectionView!
    
    private lazy var viewModel: OnboardingViewModel = OnboardingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareView()
    }
    private func prepareView() {
        
        collectionViewOnboarding.register(UINib(nibName: "OnboardingCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "OnboardingCollectionViewCell")
        if let layout = collectionViewOnboarding.collectionViewLayout as? UICollectionViewFlowLayout{
            layout.itemSize = UIScreen.main.bounds.size
            collectionViewOnboarding.layoutSubviews()
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
            layout.minimumLineSpacing = 0
        }

    }
    
    private func moveToLogin() {
        if let loginVc = SpiceSagaStoryBoards.main.getViewController(LoginViewController.self) {
            navigationController?.pushViewController(loginVc, animated: true)
        }
    }
    
    //MARK: - Action Methods
    @IBAction private func didTapOnSkip() {
        moveToLogin()
    }
    
}
extension OnboardingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.arrayOnboardingData.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.getCell(OnboardingCollectionViewCell.self, indexPath: indexPath) else {
            return UICollectionViewCell()
        }
        let item: OnboardingScreens = viewModel.arrayOnboardingData[indexPath.item]
        cell.onboarding = item
        cell.didSelectedNextFinish = {

            if item.isFinished {
                self.moveToLogin()
            } else {
                let cellSize = CGSizeMake(self.view.frame.width, self.view.frame.height);
                let contentOffset = collectionView.contentOffset;
                collectionView.scrollRectToVisible(CGRectMake(contentOffset.x + cellSize.width, contentOffset.y, cellSize.width, cellSize.height), animated: true);
            }

        }
        return cell
    }
}
