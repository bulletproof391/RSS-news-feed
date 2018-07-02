//
//  Model.swift
//  RSS news feed
//
//  Created by Дмитрий Вашлаев on 30.06.18.
//  Copyright © 2018 Дмитрий Вашлаев. All rights reserved.
//

import Foundation

private let sourcesFileName = "RSS sources"

enum SourceAttributes: String {
    case name = "Source name"
    case url = "URL"
}

struct RSSSource {
    var sourceName: String?
    var url: URL?
}

class RSSModel {
    // MARK: - Private Properties
    private let sources: [RSSSource] = {
        var mySourcesArray = [RSSSource]()
        
        if let url = Bundle.main.url(forResource: sourcesFileName, withExtension: "plist") {
            do {
                let data = try Data(contentsOf: url)
                let myPlist = try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as! [[String:String]]
                for item in myPlist {
                    if let urlString = item[SourceAttributes.url.rawValue] {
                        let newSource = RSSSource(sourceName: item[SourceAttributes.name.rawValue] , url: URL(string: urlString))
                        mySourcesArray.append(newSource)
                    }
                }
                
            } catch let serializationError {
                print("Plist serialization error: ", serializationError)
            }
        }
        
        return mySourcesArray
    }()
    
    private var threadsCount = 0
    private var rssFeed = [RSSData]()
    
    // MARK: - Public Methods
//    func getData(completionHandler: @escaping() -> Void) {
    func getData() {
        threadsCount = sources.count
        
        for item in sources {
            DispatchQueue.global(qos: .utility).async {
                let parser = RSSParser(source: item)
                parser.parseFeed { (feed) in
                    if !feed.isEmpty {
                        self.rssFeed.append(contentsOf: feed)
                        self.threadsCount -= 1

                        if self.threadsCount == 0 {
                            print("All threads are finished")
                            print(self.rssFeed.count)
                        }
                    }
                }
            }
        }
    }
}
