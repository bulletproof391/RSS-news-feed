//
//  RSSFeedTableViewCell.swift
//  RSS news feed
//
//  Created by Дмитрий Вашлаев on 30.06.18.
//  Copyright © 2018 Дмитрий Вашлаев. All rights reserved.
//

import UIKit

class RSSFeedTableViewCell: UITableViewCell {

    // MARK: - UI Properties
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsTitle: UILabel! {
        didSet {
            newsTitle.numberOfLines = 2
        }
    }
    @IBOutlet weak var newsSource: UILabel!
    @IBOutlet weak var newsDescription: UILabel! {
        didSet {
            newsDescription.numberOfLines = 3
        }
    }
    
    // MARK: - Public Properties
    var viewModel: RSSFeedCellViewModel?{
        didSet {
            initializeView()
        }
    }
    
    // MARK: - Super Class Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Private Methods
    private func initializeView() {
        newsTitle.text = viewModel?.title
        newsSource.text = viewModel?.source
        newsDescription.text = viewModel?.description
        
        viewModel?.imageReactive.producer.startWithResult{ [weak self] (receivedImage) in
            guard let weakSelf = self else { return }
            DispatchQueue.main.async {
                if let _ = receivedImage.value {
                    weakSelf.newsImage.image = receivedImage.value!
                }
            }
        }
    }
}
