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
    @IBOutlet private weak var lblRegion: UILabel?
    @IBOutlet private weak var lblDuration: UILabel?
    @IBOutlet private weak var lblCalories: UILabel?
    @IBOutlet private weak var lblDescription: UILabel?
    @IBOutlet private weak var tableVWIngredient: UITableView?
    @IBOutlet private weak var imgThumbnail: UIImageView?
    @IBOutlet weak var videoView: UIView!
    var detailRecieps: Recipe?
    var arrayIngredients: [String: String]!
    var imageURL: UIImage?
    var urlVC: String?
    var player: AVPlayer!
    var avpController = AVPlayerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        // Do any additional setup after loading the view.
    }
    
    private func setUp() {
        lblType?.text = self.detailRecieps?.name
        lblRegion?.text = self.detailRecieps?.region
        lblDuration?.text = self.detailRecieps?.duration
        lblCalories?.text = "\(self.detailRecieps?.calaroies ?? 0)"
        arrayIngredients = self.detailRecieps?.ingredients
        lblDescription?.text = self.detailRecieps?.description
        urlVC = self.detailRecieps?.videoUrl
        if let imgUrl = self.detailRecieps?.thumbUrl {
            let storageRef = Storage.storage().reference().child(imgUrl)
            storageRef.downloadURL { (url, error) in
                self.imgThumbnail?.kf.setImage(with: url)
            }
        }
        tableVWIngredient?.register(UINib(nibName: "IngredientsTableViewCell", bundle: nil), forCellReuseIdentifier: "IngredientsTableViewCell")
        tableVWIngredient?.reloadData()
    }
    
    @IBAction private func didTapOnBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func didTapOnDelete() {
        FirebaseAuthManager.shared.deleteDetail(id: self.detailRecieps?.id ?? "")
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
        return self.detailRecieps?.ingredients.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientsTableViewCell") as? IngredientsTableViewCell
        cell?.lblIngredient?.text = self.detailRecieps?.ingredients["\(indexPath.row)"]
        return cell ?? UITableViewCell()
    }
}
