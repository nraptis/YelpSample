//
//  ImageDownloaderTask.swift
//  YelpSample
//
//  Created by Nicky Taylor on 1/26/23.
//

import UIKit

class ImageDownloaderTask: NSObject, URLSessionDelegate {
    
    let downloader: ImageDownloader
    let hashable: AnyHashable
    let url: URL
    
    private var dataTask: URLSessionDataTask?
    init(downloader: ImageDownloader,
         hashable: AnyHashable,
         url: URL) {
        self.downloader = downloader
        self.hashable = hashable
        self.url = url
    }
    
    func start() {
        cancel()
        let session = URLSession(configuration: URLSessionConfiguration.default,
                                 delegate: self,
                                 delegateQueue: downloader.downloadOperationQueue)
        var request = URLRequest(url: url)
        request.timeoutInterval = 20.0
        dataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                self.downloader.downloadTaskDidFail(task: self, hashable: self.hashable)
                return
            }
            guard let data = data else {
                self.downloader.downloadTaskDidFail(task: self, hashable: self.hashable)
                return
            }
            
            guard let image = UIImage(data: data) else {
                self.downloader.downloadTaskDidFail(task: self, hashable: self.hashable)
                return
            }
            
            self.downloader.downloadTaskDidComplete(task: self, hashable: self.hashable, image: image)
        }
        dataTask?.resume()
    }
    
    func cancel() {
        if let dataTask = dataTask {
            dataTask.cancel()
            self.dataTask = nil
        }
    }
}
