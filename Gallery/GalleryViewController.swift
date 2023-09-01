//
//  GalleryViewController.swift
//  Gallery
//
//  Created by Cai on 7/21/23.
//

import UIKit

enum GalleryDragDirection {
    case scroll
    case stop
    case up
    case down
}

class GalleryViewController: UIViewController {
    
    internal var v = GalleryView(frame: .zero)
    let panGestureHelper = PanGestureHelper()
    
    override func loadView() {
        view = v
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .yellow
        
        navigationItem.leftBarButtonItem = .init(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancel(_:)))
        navigationController?.isNavigationBarHidden = true
        
        
        v.bannerView.image = UIImage(named: "banner")
//
        v.collectionView.register(GalleryCollectionCell.self, forCellWithReuseIdentifier: GalleryCollectionCell.reuseIdentifier)
        
        v.collectionView.dataSource = self
        v.collectionView.delegate = self
        
        panGestureHelper.registerForPanGesture(on: v)
        registerForTapOnPreview()
    }
    
    func registerForTapOnPreview() {
        let tapImageGesture = UITapGestureRecognizer(target: self, action: #selector(tappedImage))
        v.bannerView.addGestureRecognizer(tapImageGesture)
    }
    
    @objc
    func tappedImage() {
        if !panGestureHelper.isImageShown {
            panGestureHelper.resetToOriginalState()
            // no dragup? needed? dragDirection = .up
//            v.refreshImageCurtainAlpha()
        }
    }
    
    @objc private func didTapCancel(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension GalleryViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCollectionCell.reuseIdentifier, for: indexPath)
        return cell
    }
}

extension GalleryViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let width = (screenWidth - (1 * 3)) / 4.0
        
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}
