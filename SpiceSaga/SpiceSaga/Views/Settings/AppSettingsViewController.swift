//
//  AppSettingsViewController.swift
//  SpiceSaga
//
//  Created by Grishma Dave on 12/12/23.
//

import UIKit
import Photos

class AppSettingsViewController: UIViewController {

    @IBOutlet var switchPhotos: UISwitch!
    @IBOutlet var switchCamara: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        prepareView()
    }
    
    private func prepareView() {
        let status = PHPhotoLibrary.authorizationStatus()
        switchPhotos.isOn = status == .authorized
        
        
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            self.switchCamara.isOn = response
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction private func didTapOnBack() {
        navigationController?.popViewController(animated: true)
    }
}
