//
//  ShopFilterCollectionViewFlowLayout.swift
//  KreamWaffleApp
//
//  Created by 이선재 on 2023/01/02.
//

import UIKit

class ShopFilterCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        
        self.sectionInset = .init(top: 5, left: 5, bottom: 5, right: 5)
        self.minimumLineSpacing = 5
        self.minimumInteritemSpacing = 5
        self.scrollDirection = .horizontal
       
        let cellWidth = 30 // Subtract minimumInteritemSpacing and Inset
        self.itemSize = CGSize(width: 80, height: 40)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
