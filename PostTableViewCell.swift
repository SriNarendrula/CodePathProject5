//
//  PostTableViewCell.swift
//  ios101-project5-tumblr
//
//  Created by Sri Narendrula on 4/2/25.
//

import UIKit
import Nuke

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var summaryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Configure the image view
        postImageView.contentMode = .scaleAspectFill
        postImageView.clipsToBounds = true
        
        // Configure the label
        summaryLabel.numberOfLines = 0
        summaryLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configure(with post: Post) {
        // Set the summary text
        summaryLabel.text = post.summary
        
        // Load the image if available
        if let photo = post.photos.first {
            let url = photo.originalSize.url
            Nuke.loadImage(with: url, into: postImageView)
        } else {
            // Set a placeholder image if no photo is available
            postImageView.image = UIImage(systemName: "photo")
        }
    }
}
