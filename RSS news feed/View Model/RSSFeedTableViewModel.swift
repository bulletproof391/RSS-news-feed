//
//  RSSFeedTableViewModel.swift
//  RSS news feed
//
//  Created by Дмитрий Вашлаев on 30.06.18.
//  Copyright © 2018 Дмитрий Вашлаев. All rights reserved.
//

import Foundation
import ReactiveSwift

class RSSFeedTableViewModel {
    // MARK: - Private Properties
    private var model: RSSModel
    private var cellViewModels = [RSSFeedCellViewModel]()
    
    // MARK: - Public Properties
    private(set) var hasUpdated = MutableProperty(false)
    
    // MARK: - Initializers
    init(with model: RSSModel) {
        self.model = model
        self.model.getData { [weak self] (receivedFeed) in
            if receivedFeed.count > 0 {
                guard let weakSelf = self else { return }
                weakSelf.initializeCellViewModel(feed: receivedFeed)
                weakSelf.hasUpdated.value = true
                
                print("Feed received")
            }
        }
    }
    
    // MARK: - Private Methods
    private func initializeCellViewModel(feed: [RSSData]) {
        for item in feed {
            cellViewModels.append(RSSFeedCellViewModel(with: item))
        }
    }
    
    // MARK: - Public Methods
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        return cellViewModels.count
    }
    
    func cellForRow(at indexPath: IndexPath) -> RSSFeedCellViewModel {
        return cellViewModels[indexPath.row + indexPath.section]
    }
}
