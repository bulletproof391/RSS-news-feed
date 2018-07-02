//
//  RSSParser.swift
//  RSS news feed
//
//  Created by Дмитрий Вашлаев on 30.06.18.
//  Copyright © 2018 Дмитрий Вашлаев. All rights reserved.
//

import Foundation

class RSSParser: NSObject, XMLParserDelegate {
    // MARK: - Private Properties
    private let rssURL: URL?
    private let sourceName: String?
    private var isInItem = false
    private var currentElement = ""
    private var currentImageURL = ""
    private var currentTitle = "" {
        didSet {
            currentTitle = currentTitle.trimmingCharacters(in: .newlines)
            currentTitle = currentTitle.replacingOccurrences(of: "[\r\n]+( )*", with: "", options: .regularExpression, range: nil)
        }
    }
    private var currentDescription = "" {
        didSet {
            currentDescription = currentDescription.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    private var parserCompletionHandler: (([RSSData]) -> Void)?
    private var rssFeed = [RSSData]()
    
    // MARK: - Public Properties
    private(set) var currentPublicationDate = "" {
        didSet {
            currentPublicationDate = currentPublicationDate.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    
    // MARK: - Initializers
    init(source: RSSSource) {
        self.rssURL = source.url
        self.sourceName = source.sourceName
    }
    
    
    // MARK: - Public Methods
    func parseFeed(completionHandler: @escaping(([RSSData]) -> Void)) {
        parserCompletionHandler = completionHandler
        
        let urlSession = URLSession.shared
        guard let url = rssURL else {
            // return empty array
            completionHandler([RSSData]())
            return
        }

        let urlRequest = URLRequest(url: url)
        urlSession.dataTask(with: urlRequest) { (data, response, error) in
            guard let receivedData = data else {
                if let _ = error {
                    print("Error when receiving data: ", error!.localizedDescription)
                }
                completionHandler([RSSData]())
                return
            }
            
            // tell XMLParser we are the delegate
            // then implement delegate methods
            let parser = XMLParser(data: receivedData)
            parser.delegate = self
            parser.parse()
        }.resume()
    }
    
    // MARK: - XML Parser Delegate
    // when we find new entry
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        if currentElement == "item" {
            currentTitle = ""
            currentDescription = ""
            currentPublicationDate = ""
            currentImageURL = ""
            isInItem = true
        }
        
        if isInItem == true {
            switch elementName {
            case "itunes:image":
                guard let urlString = attributeDict["href"] else { return }
                currentImageURL = urlString
                break
            case "enclosure":
                guard let urlString = attributeDict["url"] else { return }
                currentImageURL = urlString
                break
            default:
                break
            }
        }
        
        
    }
    
    // parsing data
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "title":
            currentTitle += string
            break
        case "description":
            currentDescription += string
            break
        case "pubDate":
            currentPublicationDate += string
            break
        default:
            break
        }
    }
    
    
    // when element is read adding to array
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let dateFormatter = ISO8601DateFormatter()
            let date = dateFormatter.date(from:formattedDate)
            
            let rssItem = RSSData(imageURL: URL(string: currentImageURL), image: nil, title: currentTitle, description: currentDescription, sourceName: sourceName, publicationDate: date)
            rssFeed.append(rssItem)
            
            isInItem = false
        }
    }
    
    
    // when parsing is done
    func parserDidEndDocument(_ parser: XMLParser) {
        parserCompletionHandler?(rssFeed)
    }
    
    // when error triggers
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError.localizedDescription)
    }
}













