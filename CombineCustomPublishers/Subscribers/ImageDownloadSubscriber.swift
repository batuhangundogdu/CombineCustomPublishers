//
//  ImageDownloadSubscriber.swift
//  CombineCustomPublishers
//
//  Created by Batuhan GÜNDOĞDU on 10.02.2025.
//

import Combine
import Foundation

/// A custom Subscriber that parallel-downloads URLs using Swift concurrency,
/// then sends each downloaded URL to its downstream subscriber.
class ImageDownloadSubscriber<S: Subscriber>: Subscriber
where S.Input == URL?, S.Failure == Never {
    
    let urls: [URL]
    var subscriber: S?
    
    init(urls: [URL], subscriber: S) {
        self.urls = urls
        self.subscriber = subscriber
        
        // Kick off the downloads in parallel
        Task {
            await startDownload()
        }
    }
    
    private func startDownload() async {
        await withTaskGroup(of: URL?.self) { group in
            for url in urls {
                group.addTask {
                    // Perform download
                    let response = try? await URLSession.shared.data(from: url)
                    if let (data, _) = response {
                        let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                        let fileURL = docDir.appendingPathComponent(url.lastPathComponent)
                        try? data.write(to: fileURL)
                        return fileURL
                    } else {
                        return nil
                    }
                }
            }
            
            // Emit each URL (or nil if failed)
            for await downloadedURL in group {
                _ = subscriber?.receive(downloadedURL)
            }
            
            // Completion
            subscriber?.receive(completion: .finished)
        }
    }
    
    func receive(subscription: Subscription) {
        // Typically not used in a custom subscriber of this style.
    }
    
    func receive(_ input: URL?) -> Subscribers.Demand {
        // The next stage in the pipeline receives the downloaded file URL or nil
        .unlimited
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        // Forward completion
        subscriber?.receive(completion: completion)
    }
    
    func request(_ demand: Subscribers.Demand) {
        // Handle backpressure if necessary
    }
    
    func cancel() {
        // Cancel downloads or discard references if needed
        subscriber = nil
    }
}
