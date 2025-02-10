//
//  ImageDownloadPublisher.swift
//  CombineCustomPublishers
//
//  Created by Batuhan GÜNDOĞDU on 10.02.2025.
//

import Combine
import Foundation

/// A custom Publisher that emits URLs for each successfully downloaded image.
struct ImageDownloadPublisher: Publisher {
    typealias Output = URL
    typealias Failure = Never
    
    let urls: [URL]
    
    func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
        let subscription = ImageDownloadSubscription(urls: urls, subscriber: subscriber)
        subscriber.receive(subscription: subscription)
    }
}

/// This Subscription ties the publisher to the subscriber,
/// storing references to ensure the lifecycle is maintained
final class ImageDownloadSubscription<S: Subscriber>: Subscription
where S.Input == URL, S.Failure == Never {
    
    private var subscriber: S?
    private let urls: [URL]
    
    init(urls: [URL], subscriber: S) {
        self.urls = urls
        self.subscriber = subscriber
    }
    
    func request(_ demand: Subscribers.Demand) {
        // We could track demand here, but let's simply download all images.
        startDownload()
    }
    
    func cancel() {
        subscriber = nil
    }
    
    private func startDownload() {
        Task {
            for url in urls {
                do {
                    let (data, _) = try await URLSession.shared.data(from: url)
                    
                    // Save file with a unique name
                    let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                    let fileName = "picsum-\(UUID().uuidString).jpg"
                    let fileURL = docDir.appendingPathComponent(fileName)
                    
                    try data.write(to: fileURL)
                    
                    // Emit each downloaded file URL
                    _ = subscriber?.receive(fileURL)
                } catch {
                    // If we had an error type, we might emit .failure
                    // For 'Never' failure, ignore errors in this example
                }
            }
            
            // Completion once all downloads are done
            subscriber?.receive(completion: .finished)
        }
    }
}
