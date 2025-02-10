//
//  ContentView.swift
//  CombineCustomPublishers
//
//  Created by Batuhan GÜNDOĞDU on 10.02.2025.
//

import SwiftUI
import Combine

struct ContentView: View {
    @State private var cancellables = Set<AnyCancellable>()
    @State private var downloadedURLs: [URL] = []
    
    // Some sample image URLs
    let urls: [URL] = [
        URL(string: "https://picsum.photos/id/237/200/300")!,
        URL(string: "https://picsum.photos/id/238/200/300")!,
        URL(string: "https://picsum.photos/id/239/200/300")!
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                List(downloadedURLs, id: \.self) { fileURL in
                    // Display image if it exists on disk
                    if let imageData = try? Data(contentsOf: fileURL),
                       let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 150)
                    } else {
                        Text("No image available.")
                    }
                }
                
                Button("Download Images") {
                    startDownload()
                }
                .padding()
            }
            .navigationTitle("Combine Image Downloader")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func startDownload() {
        // Clear any previous downloads
        downloadedURLs.removeAll()
        
        ImageDownloadPublisher(urls: urls)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        print("All downloads finished.")
                    case .failure(let error):
                        print("Download failed: \(error)")
                    }
                },
                receiveValue: { fileURL in
                    // Append the local file URLs as they arrive
                    downloadedURLs.append(fileURL)
                }
            )
            .store(in: &cancellables)
    }
}

#Preview {
    ContentView()
}
