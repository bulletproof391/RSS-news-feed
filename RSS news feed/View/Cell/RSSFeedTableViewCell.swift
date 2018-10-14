//
//  RSSFeedTableViewCell.swift
//  RSS news feed
//
//  Created by Дмитрий Вашлаев on 30.06.18.
//  Copyright © 2018 Дмитрий Вашлаев. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import Result

class RSSFeedTableViewCell: UITableViewCell {

    // MARK: - UI Properties
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsSource: UILabel!
    @IBOutlet weak var newsDescription: UILabel!
    
    // MARK: - Public Properties
    let viewModel: MutableProperty<RSSFeedCellViewModel> = MutableProperty(RSSFeedCellViewModel())
    
    // MARK: - Super Class Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initializeView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Private Methods
    private func initializeView() {
        newsTitle.reactive.text <~ viewModel.map { $0.title }
        newsSource.reactive.text <~ viewModel.map { $0.source }
        newsDescription.reactive.text <~ viewModel.map { $0.description }
        newsDescription.reactive.isHidden <~ viewModel.map{ $0.isHidden }
        
        newsImage.reactive.image <~ viewModel.producer.flatMap(.latest) { cellViewModel in
            cellViewModel.getImage().map(Optional.some).prefix(value: nil)
        }
    }
    
    // MARK: - Public Methods
    func showDescription() {
        newsDescription.isHidden = (newsDescription.isHidden) ? false : true
        viewModel.value.isHidden = newsDescription.isHidden
    }
}
