//
//  CharacterCell.swift
//  MarvelApp
//
//  Created by Evgeniy on 19.08.2018.
//  Copyright © 2018 Evgeniy. All rights reserved.
//

import UIKit

class RegionCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    private let cache =              NSCache<NSString, UIImage>()
    private var isPressed =  false
    var initialFrame:        CGRect? = nil
    var initialCornerRadius: CGFloat? = nil
    
    static let cellID = "RegionCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCell()
    }
    
    override var isHighlighted: Bool {
        didSet { bounceonHighlit(isHighlighted) }
    }
    
    var bounceCompletion: (()->())? = nil
    
    
    private func bounceonHighlit(_ bounce: Bool) {
        UIView.animate(
            withDuration: 0.8,
            delay: 0,
            usingSpringWithDamping: 0.4,
            initialSpringVelocity: 0.8,
            options: [.allowUserInteraction, .beginFromCurrentState],
            animations: { self.transform = bounce ? CGAffineTransform(scaleX: 0.9, y: 0.9) : .identity },
            completion: nil)
    }
    
    func bounceOnSelection() {
        let defaultTransform = transform
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 5, initialSpringVelocity: 1, animations: {[weak self] in
            self?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { (isCompleted) in
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 5, initialSpringVelocity: 1, animations: {[weak self] in
                 self?.transform = defaultTransform
            }, completion: {[weak self] (isCompleted) in
                self?.bounceCompletion?()
            })
        }
    }
    
    private func configureCell() {
        imageView.alpha = 0
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = contentView.layer.cornerRadius
    }
    
    class func create(owner: UIViewController) -> RegionCell {
        return Bundle.main.loadNibNamed(self.cellID, owner: owner, options: nil)?.first as! RegionCell
    }
    
    func fill(with region: Region) {
        nameLabel.text = region.title
        imageView.image = UIImage(named: region.imageTitle)
        UIView.animate(withDuration: 0.2) {[weak self] in
            self?.imageView.alpha = 1
        }
    }
    
    override func prepareForReuse() {
        imageView.image = nil
    }
}

//MARK: Expanded logic

extension RegionCell {
    func expand(in collectionView: UICollectionView) {
        UIView.animate(withDuration: 0.3, animations: {[weak self] in
            self?.initialFrame =  self?.frame
             self?.initialCornerRadius =  self?.contentView.layer.cornerRadius
             self?.contentView.layer.cornerRadius = 0
             self?.frame = CGRect(x: 0, y: collectionView.contentOffset.y, width: collectionView.frame.width, height: collectionView.frame.height)
        }) { (isFinished) in
             self.layoutIfNeeded()
        }
    }
    
    func collapse() {
        contentView.layer.cornerRadius = initialCornerRadius ?? contentView.layer.cornerRadius
        frame = initialFrame ?? frame
        initialFrame = nil
        initialCornerRadius = nil
        layoutIfNeeded()
    }
}


