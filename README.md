# CombineCustomPublishers

A simple SwiftUI sample project that demonstrates how to create custom Combine publishers and subscribers in Swift. This example focuses on parallel image downloads using Swift’s structured concurrency (Task and withTaskGroup) and storing the resulting files locally. It illustrates key concepts such as backpressure, subscription management, and clean architecture in Combine.

## Overview

CombineCustomPublishers is designed to help iOS developers learn how to:

1. Build **custom publishers** that emit values (in this case, downloaded image URLs).
2. Build **custom subscribers** that handle concurrency and control data flow.
3. Integrate **SwiftUI** views with Combine pipelines to display downloaded images.

The key takeaway is how to **combine** (pun intended) Swift’s modern concurrency with Combine’s reactive model. Developers can use this repository as a reference or starting point to implement more advanced data pipelines.

## Features

- **Custom Publisher (ImageDownloadPublisher):**

  - Emits local file URLs of downloaded images.
  - Demonstrates manual subscription logic.
  - Illustrates how to integrate Swift’s async/await.

- **Custom Subscriber (ImageDownloadSubscriber):**
  - Parallel-downloads images using withTaskGroup.
  - Emits each downloaded URL (or nil) back to the subscriber chain.
  - Showcases how to manage concurrency and completion events.
- **SwiftUI Integration (ContentView):**

  - Subscribes to ImageDownloadPublisher using sink.
  - Dynamically updates the UI to display downloaded images.
  - Illustrates best practices for storing AnyCancellable references.

- **Unique Filenames:**
  - Ensures each downloaded image is stored separately in the app’s document directory.
  - Demonstrates how to avoid overwriting existing files.

## Requirements

- **iOS 15+** (due to Swift concurrency features like async/await)
- **Xcode 13+** (recommended; required for Swift 5.5 concurrency features)
- **Swift 5.5+**

## Installation

1. **Clone the repository:**

```
git clone https://github.com/your-username/CombineCustomPublishers.git
```

2. **Open the project** in Xcode:

```
cd CombineCustomPublishers
open CombineCustomPublishers.xcodeproj
```

3. **Build and run** the project on your simulator or device.

## Usage

1. Launch the **CombineCustomPublishers** app in the iOS Simulator or on a device.
2. You’ll see a list (initially empty) and a **Download Images** button.
3. Tap **Download Images**:
   - The app spawns a custom publisher to download the images from picsum.photos.
   - Each downloaded image is saved to the documents directory with a unique filename.
   - As each image finishes downloading, it’s displayed in the list.

To modify the **image URLs**, open ContentView.swift and change the urls array to point to any other valid image links.

## Project Structure

```
CombineCustomPublishers/
├── CombineCustomPublishers.xcodeproj
├── CombineCustomPublishers
│   ├── App/
│   │   ├── CombineCustomPublishersApp.swift    // SwiftUI App Lifecycle
│   │   └── ContentView.swift                   // Main SwiftUI view
│   ├── Publishers/
│   │   └── ImageDownloadPublisher.swift        // Custom publisher & subscription
│   ├── Subscribers/
│   │   └── ImageDownloadSubscriber.swift       // Custom subscriber (parallel downloads)
│   └── Resources/
│       └── Assets.xcassets                     // Image assets, app icons, etc.
├── README.md                                    // Project documentation
└── LICENSE                                      // License
```

1. **ImageDownloadPublisher.swift**
   - Defines ImageDownloadPublisher (adopts Publisher)
   - Defines ImageDownloadSubscription (adopts Subscription)
2. **ImageDownloadSubscriber.swift**
   - Shows an example of a custom Subscriber.
   - Uses withTaskGroup for parallel downloads.
3. **ContentView.swift**
   - Demonstrates how to subscribe to ImageDownloadPublisher via sink.
   - Displays downloaded images in a List.

## How It Works

1.  **Button Tap** -> startDownload() is called in ContentView.
2.  **Publisher Creation** -> ImageDownloadPublisher(urls:) is instantiated with an array of URLs.
3.  **Subscription** -> We call sink(receiveCompletion:receiveValue:), creating a sink subscriber.
4.  **Publishing Logic** ->
    - ImageDownloadSubscription is created.
    - For each URL, an async download occurs.
    - Each result is written to disk and emitted back to the subscriber.
5.  **UI Update** -> As each file URL is received, SwiftUI updates the List with the newly downloaded image.

## Contributing

Contributions, bug reports, and pull requests are welcome! If you have suggestions for improvements, optimizations, or additional features (like custom error handling), feel free to open an issue or submit a pull request.

Steps to contribute:

1. **Fork** the repository on GitHub.
2. **Create a branch** for your feature or fix.
3. **Commit** your changes with clear commit messages.
4. **Open a pull request** against the main branch.

## License

This project is licensed under the MIT License. Feel free to use it in commercial or private projects, but please give credit to the repository if you find it helpful.

##

**Happy Coding!**

If you find this example helpful, consider giving the repo a star on GitHub. If you have any questions, feel free to open an issue. Enjoy building custom Combine publishers and subscribers!

##

**Copyright (c) 2025 Batuhan Gundogdu**
