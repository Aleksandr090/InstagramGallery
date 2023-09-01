//
//  GalleryCollectionCell.swift
//  Gallery
//
//  Created by Cai on 7/21/23.
//

import UIKit

class GalleryCollectionCell: UICollectionViewCell {
    
    static let reuseIdentifier = String(describing: GalleryCollectionCell.self)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .green
    }
}
