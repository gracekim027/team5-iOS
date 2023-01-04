//
//  File.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2022/12/29.
//

import Foundation
import UIKit
import Kingfisher

final class StyleCollectionViewCell: UICollectionViewCell {
    static let identifier = "StyleCollectionViewCell"
    private let idLabel = UILabel()
    private let contentLabel = UILabel()
    private let numLikesLabel = UILabel()
    private var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.setupCornerRadius(20)
        return imageView
    }()
    private var thumbnailImageSource: String?
    
    let h1FontSize: CGFloat = 14 // contentLabel
    let h2FontSize: CGFloat = 13 // // idLabel, numLikesLabel
    let mainFontColor: UIColor = .black
    let subFontColor: UIColor = .darkGray

    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpLayout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setUpLayout()
    }
    
    
    func configure(with styleCellModel: StyleCellModel) {
        self.idLabel.text = styleCellModel.userId
        self.contentLabel.text = styleCellModel.content
        self.numLikesLabel.text = "😊 \(styleCellModel.numLikes)"
        self.thumbnailImageView.image = styleCellModel.thumbnailImage
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.image = nil
    }
    
    private func setUpLayout() {
        setUpThumbnailImageView()
        setUpIdLabel()
        setUpNumLikesLabel()
        setUpContentLabel()
    }
    
    private func setUpThumbnailImageView() {
        contentView.addSubview(thumbnailImageView)
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            self.thumbnailImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            self.thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            self.thumbnailImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -44),
        ])
    }
    
    private func setUpIdLabel() {
        self.idLabel.font = UIFont.boldSystemFont(ofSize: self.h2FontSize)
        self.idLabel.textColor = self.subFontColor
        self.idLabel.lineBreakMode = .byTruncatingTail
        self.idLabel.numberOfLines = 1
        self.idLabel.textAlignment = .left
        self.idLabel.adjustsFontSizeToFitWidth = false
        
        contentView.addSubview(idLabel)
        idLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.idLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 3),
            self.idLabel.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.5),
            self.idLabel.topAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor, constant: 2),
            self.idLabel.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
    
    private func setUpNumLikesLabel() {
        self.numLikesLabel.font = UIFont.systemFont(ofSize: self.h2FontSize)
        self.numLikesLabel.textColor = self.subFontColor
        self.numLikesLabel.lineBreakMode = .byTruncatingTail
        self.numLikesLabel.numberOfLines = 1
        self.numLikesLabel.textAlignment = .right
        self.numLikesLabel.adjustsFontSizeToFitWidth = true
        
        contentView.addSubview(numLikesLabel)
        numLikesLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.numLikesLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -3),
            self.numLikesLabel.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.5, constant: -5.0),
            self.numLikesLabel.topAnchor.constraint(equalTo: idLabel.topAnchor, constant: 0),
            self.numLikesLabel.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
    
    private func setUpContentLabel() {
        self.contentLabel.font = UIFont.systemFont(ofSize: self.h1FontSize)
        self.contentLabel.textColor = self.mainFontColor
        self.contentLabel.lineBreakMode = .byTruncatingTail
        self.contentLabel.numberOfLines = 1
        self.contentLabel.textAlignment = .left
        self.contentLabel.adjustsFontSizeToFitWidth = false
        
        contentView.addSubview(contentLabel)
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.contentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 3),
            self.contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -3),
            self.contentLabel.topAnchor.constraint(equalTo: idLabel.bottomAnchor, constant: 2),
            self.contentLabel.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
}
