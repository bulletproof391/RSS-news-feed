//
//  RSSFeedCellViewModel.swift
//  RSS news feed
//
//  Created by Дмитрий Вашлаев on 30.06.18.
//  Copyright © 2018 Дмитрий Вашлаев. All rights reserved.
//

import UIKit
import ReactiveSwift

class RSSFeedCellViewModel {
    // MARK: - Private Properties
    private(set) var image: UIImage?
    private(set) var title: String?
    private(set) var description: String?
    private(set) var publicationDate: Date?
    private(set) var source: String?
    
    // MARK: - Public Properties
    private(set) var imageReactive = MutableProperty(UIImage())
    
    
    // MARK: - Initializers
    init(with rssItem: RSSData) {
        self.title = rssItem.title
        self.description = rssItem.description
        self.publicationDate = rssItem.publicationDate
        self.source = rssItem.sourceName
        downLoadImage(rssItem.imageURL)
        
    }
    
    // MARK: - Private Methods
    private func downLoadImage(_ url: URL?) {
        if let _ = url {
            URLSession.shared.dataTask(with: url!) { [weak self] (data, urlRsponse, err) in
                if let receivedData = data, let weakSelf = self, let receivedImage = UIImage(data: receivedData) {
                    weakSelf.image = receivedImage
                    weakSelf.imageReactive.value = receivedImage
                }
            }.resume()
        }
    }
}
