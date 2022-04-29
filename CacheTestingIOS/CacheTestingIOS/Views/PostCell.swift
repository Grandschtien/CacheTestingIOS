//
//  PostCell.swift
//  CacheTestingIOS
//
//  Created by Егор Шкарин on 22.04.2022.
//

import UIKit

class PostCell: UICollectionViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var body: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }
    
    private func setupCell() {
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 20
    }
    func configure(_ viewModel: PostViewModel) {
        title.text = viewModel.title
        body.text = viewModel.body
    }
}
