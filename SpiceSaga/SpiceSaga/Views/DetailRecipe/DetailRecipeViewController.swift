//
//  DetailRecipeViewController.swift
//  SpiceSaga
//
//  Created by Grishma Dave on 26/11/23.
//

import UIKit
import AVKit
import AVFoundation
import Kingfisher
import FirebaseStorage

class DetailRecipeViewController: UIViewController {

    @IBOutlet private weak var lblType: UILabel?
    @IBOutlet private weak var lblRecipeName: UILabel?
    @IBOutlet private weak var lblRegion: UILabel?
    @IBOutlet private weak var lblDuration: UILabel?
    @IBOutlet private weak var lblCalories: UILabel?
    @IBOutlet private weak var lblDescription: UILabel?
    @IBOutlet private weak var tableViewRecipeSteps: UITableView?
    @IBOutlet private weak var imgThumbnail: UIImageView?
    @IBOutlet private weak var buttonSave: UIButton!
    
    @IBOutlet private weak var collectionViewIngredients: UICollectionView!
    
    @IBOutlet weak var videoView: UIView!
    var detailRecieps: Recipe?
    var arrayIngredients: [String: String]!
    var imageURL: UIImage?
    var urlVC: String?
    var player: AVPlayer!
    var avpController = AVPlayerViewController()
    
    var recipeSteps:[String] = [String]()
    var ingregientsImages: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        // Do any additional setup after loading the view.
    }
    
    private func setUp() {
        if let details = detailRecieps {
            let isSaved = SpiceSagaDataServices.shared.allSaveRecipes.contains(where: {$0.id == details.id})
            buttonSave.isSelected = isSaved
            lblType?.text = self.detailRecieps?.type
    //        lblRegion?.text = self.detailRecieps?.region
    //        lblDuration?.text = self.detailRecieps?.duration
            lblCalories?.text = "\(self.detailRecieps?.calaroies ?? 0) Calories"
    //        arrayIngredients = self.detailRecieps?.ingredients
    //        lblDescription?.text = self.detailRecieps?.description
    //        urlVC = self.detailRecieps?.videoUrl
            lblRecipeName?.text = detailRecieps?.name
            if let imgUrl = self.detailRecieps?.thumbUrl {
                let storageRef = Storage.storage().reference().child(imgUrl)
                storageRef.downloadURL { (url, error) in
                    self.imgThumbnail?.kf.setImage(with: url)
                }
            }
            for ( _ , value) in  detailRecieps?.steps ?? [:] {
                recipeSteps.append(value)
            }
            collectionViewIngredients.register(UINib(nibName: "IngredientsCell", bundle: .main), forCellWithReuseIdentifier: "IngredientsCell")
            for (_ , value ) in detailRecieps?.ingredients ?? [:]{
                ingregientsImages.append(value)
            }
        }
        
    }
    
    @IBAction private func didTapOnBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func didTapOnSave() {
        if let details = detailRecieps {
            if buttonSave.isSelected {
                buttonSave.isSelected = false
                SpiceSagaDataServices.shared.removeSaved(recipe: details)
            } else {
                buttonSave.isSelected = true
                SpiceSagaDataServices.shared.saveRecipe(recipe: details)
                let alertController = UIAlertController(title: "Saved", message: "Recipe saved successfully.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: .default))
                present(alertController, animated: true)
            }
        }
    }
    
    @IBAction private func didTapOnPlay() {
        playVideo()
    }
    
    func playVideo() {
        if let imgUrl = self.detailRecieps?.videoUrl {
            let storageRef = Storage.storage().reference().child(imgUrl)
            storageRef.downloadURL { (videoUrl, error) in
                self.player = AVPlayer(url: videoUrl!)
                self.avpController.player = self.player
                self.avpController.view.frame.size.height = self.videoView.frame.size.height
                self.avpController.view.frame.size.width = self.videoView.frame.size.width
                self.videoView.addSubview(self.avpController.view)
            }
        }
    }
}

extension DetailRecipeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeSteps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.registerAndGetCell(CookingStepsCell.self)
        cell.stepDetail = "Step \(indexPath.row + 1) : \(recipeSteps[indexPath.row])"
        return cell
    }
}
extension DetailRecipeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.getCell(IngredientsCell.self, indexPath: indexPath) else { return UICollectionViewCell() }
        cell.ingredientImage = ingregientsImages[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ingregientsImages.count
    }
}
