//
//  RSSFeedCellViewModel.swift
//  RSS news feed
//
//  Created by Дмитрий Вашлаев on 30.06.18.
//  Copyright © 2018 Дмитрий Вашлаев. All rights reserved.
//

import UIKit
import ReactiveSwift
import Result

class RSSFeedCellViewModel {
    // MARK: - Private Properties
    private var image: UIImage?
    private var imageURL: URL?
    
    // MARK: - Public Properties
    private(set) var title: String?
    private(set) var description: String?
    private(set) var publicationDate: Date?
    private(set) var source: String?
    var isHidden: Bool
    
    
    // MARK: - Initializers
    init() {
        self.title = nil
        self.description = nil
        self.publicationDate = nil
        self.source = nil
        self.isHidden = false
        self.imageURL = nil
    }
    
    required init(with rssItem: RSSData) {
        self.title = rssItem.title
        self.description = rssItem.description
        self.publicationDate = rssItem.publicationDate
        self.source = rssItem.sourceName
        self.isHidden = false
        self.imageURL = rssItem.imageURL
    }
    
    // MARK: - Private Methods
    func getImage() -> SignalProducer<UIImage, NoError> {
        return SignalProducer<UIImage, NoError> { [weak self] observer, _ in
            if let _ = self!.image {
                observer.send(value: self!.image!)
            } else {
                if let newUrl = self!.imageURL {
                    URLSession.shared.dataTask(with: newUrl) { [weak self] (data, urlRsponse, err) in
                        if let receivedData = data, let weakSelf = self, let receivedImage = UIImage(data: receivedData) {
                            observer.send(value: receivedImage)
                            weakSelf.image = receivedImage
                        }
                        }.resume()
                }
            }
        }
    }
    
}

