//
//  CommentCell.swift
//  CacheTestingIOS
//
//  Created by Егор Шкарин on 26.04.2022.
//

import UIKit

class CommentCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentBodyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        containerView.layer.borderColor = UIColor.black.cgColor
        containerView.layer.borderWidth = 1.0
        containerView.layer.cornerRadius = 20
        selectionStyle = .none
    }
    
    func configure(withViewModel viewModel: CommentViewModel) {
        nameLabel.text = viewModel.name
        commentBodyLabel.text = viewModel.body
    }
    
}
