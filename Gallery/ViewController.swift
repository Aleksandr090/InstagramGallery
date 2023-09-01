//
//  ViewController.swift
//  Gallery
//
//  Created by Cai on 7/21/23.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func didTapPresent(_ sender: Any) {
        let gallery = GalleryViewController()
        let navigationController = UINavigationController(rootViewController: gallery)
        navigationController.modalPresentationStyle = .overFullScreen

        self.present(navigationController, animated: true)
    }
    
}

