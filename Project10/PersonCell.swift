//
//  PersonCellCollectionViewCell.swift
//  Project10
//
//  Created by Lucas Macêdo on 14/03/26.
//

import UIKit

class PersonCell: UICollectionViewCell {
    
    let liquidGlassView: UIVisualEffectView = {
//        let liquidGlass = UIGlassEffect(style: .clear)
        let liquidGlass = UIBlurEffect(style: .systemThickMaterial)
        let liquidGlassEffect = UIVisualEffectView(effect: liquidGlass)
        
        return liquidGlassEffect
    }()
    
    let personImageView: UIImageView = {
        let image = UIImageView(frame: CGRect(x: 10, y: 10, width: 100, height: 120))
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.borderColor = UIColor.secondaryLabel.cgColor
        image.layer.borderWidth = 2
        image.layer.cornerRadius = 6
        
        return image
    }()
    
    let personNameView: UILabel = {
        let label = UILabel(frame: CGRect(x: 10, y: 132, width: 100, height: 40))
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = UIFont(name: "MarkerFelt-Thin", size: 16)
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        liquidGlassView.frame = contentView.bounds
        liquidGlassView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        contentView.addSubview(liquidGlassView)
        contentView.addSubview(personImageView)
        contentView.addSubview(personNameView)
        
        contentView.layer.cornerRadius = 16
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
