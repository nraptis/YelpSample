//
//  ImageDownloader.swift
//  YelpSample
//
//  Created by Nicky Taylor on 1/26/23.
//

import UIKit

protocol ImageDownloaderDelegate: AnyObject {
    func imageDownloadDidStart(for hashable: AnyHashable)
    func imageDownloadDidComplete(for hashable: AnyHashable, image: UIImage)
    func imageDownloadDidFail(for hashable: AnyHashable)
    func imageDownloadDidCancel(for hashable: AnyHashable)
}

class ImageDownloader {
    
    lazy var downloadOperationQueue: OperationQueue = {
        let result = OperationQueue()
        result.maxConcurrentOperationCount = 2
        return result
    }()
    
    private var internalSerialQueue = DispatchQueue(label: "serial", qos: .default)
    
    init() {
        
    }
    
    private var taskDict = [AnyHashable: ImageDownloaderTask]()
    private var failSet = Set<AnyHashable>()
    private var imageDict = [AnyHashable: UIImage]()
    
    weak var delegate: ImageDownloaderDelegate?
    
    func image(for hashable: AnyHashable) -> UIImage? {
        var result: UIImage?
        internalSerialQueue.sync {
            result = imageDict[hashable]
        }
        return result
    }
    
    func imageDidFail(for hashable: AnyHashable) -> Bool {
        var result = false
        internalSerialQueue.sync {
            if failSet.contains(hashable) {
                result = true
            }
        }
        return result
    }
    
    func addDownloadTask(for hashable: AnyHashable, url: URL?) {
        
        guard let url = url else {
            internalSerialQueue.sync {
                failSet.insert(hashable)
                DispatchQueue.main.async {
                    self.delegate?.imageDownloadDidFail(for: hashable)
                }
                
            }
            return
        }
        
        var shouldProceed = true
        internalSerialQueue.sync {
            if imageDict[hashable] != nil { shouldProceed = false }
            if failSet.contains(hashable) { shouldProceed = false }
            if taskDict[hashable] != nil { shouldProceed = false }
        }
        
        if !shouldProceed { return }
        
        let task = ImageDownloaderTask(downloader: self,
                                       hashable: hashable,
                                       url: url)
        
        internalSerialQueue.sync {
            taskDict[hashable] = task
        }
        
        task.start()
        
        DispatchQueue.main.async {
            self.delegate?.imageDownloadDidStart(for: hashable)
        }
    }
    
    func downloadTaskDidFail(task: ImageDownloaderTask, hashable: AnyHashable) {
        internalSerialQueue.sync {
            taskDict.removeValue(forKey: hashable)
            failSet.insert(hashable)
        }
        DispatchQueue.main.async {
            self.delegate?.imageDownloadDidFail(for: hashable)
        }
    }
    
    func downloadTaskDidComplete(task: ImageDownloaderTask, hashable: AnyHashable, image: UIImage) {
        internalSerialQueue.sync {
            taskDict.removeValue(forKey: hashable)
            failSet.remove(hashable)
            imageDict[hashable] = image
        }
        
        DispatchQueue.main.async {
            self.delegate?.imageDownloadDidComplete(for: hashable,
                                                    image: image)
        }
    }
    
}
