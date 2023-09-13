# DownloadManager and PlayerManager

`DownloadManager` and `PlayerManager` are Swift classes designed to manage media downloads and playback, respectively. These classes can be used in SwiftUI-based applications to handle media-related tasks. This README provides an overview of their features and usage.

## DownloadManager

## Features

### DownloadManager

- Download media files from a given URL.
- Pause and resume ongoing downloads.
- Cancel ongoing downloads.
- Check if media files exist in the local directory.
- Remove downloaded media files from the local directory.
- Configure local notifications for download events.

### PlayerManager

- Play audio from a given URL.
- Pause and resume audio playback.
- Play video from a given URL using `AVPlayerViewController`.
- Seek to specific playback positions.
- Skip forward and backward during audio playback.

## Installation

To use the Media Management Library in your project, follow these steps:

1. Add the library as a Swift package dependency.

- In Xcode, open your project.
- Go to "File" > "Swift Packages" > "Add Package Dependency..."
- Enter the following URL: `https://github.com/Quokka-Labs-LLP/download-manager-swift.git`
- Select the version or branch you want to use.
- Click "Finish."
- Import package with `import DownloadManager`


## Usage

### Usage of Download Manager:

// Create an instance of DownloadManager in your SwiftUI view.
@StateObject var downloadManager = DownloadManager()

// Download media from a URL
downloadManager.downloadMedia(with: "your_media_file_url")

// Pause a download
downloadManager.pauseDownload()

// Resume a paused download
downloadManager.resumeDownload()

// Cancel a download
downloadManager.cancelDownload(with: "your_media_file_url")

// Check if media is already downloaded
let isMediaDownloaded = downloadManager.isMediaExistInDir(with: "your_media_file_url")

// Remove downloaded media file
downloadManager.removeMediaFromDir(with: "your_media_file_url")

// Enable or disable notifications
downloadManager.configNotification(isRequire: true)

// Check if notifications are enabled
let isNotificationsEnabled = downloadManager.isNotificationEnable()

### Usage of Player Manager:

// Import PlayerManager into your SwiftUI view.
import PlayerManager

// Create an instance of PlayerManager in your SwiftUI view.
@StateObject var playerManager = PlayerManager()

// Play audio from a URL
playerManager.playAudio(with: "your_audio_file_url")

// Play video from a URL
playerManager.playVideo(url: "your_video_file_url")

// Pause playback
playerManager.pauseAudio()

// Resume playback
playerManager.resumeAudio()

// Skip forward and backward
playerManager.skipForward()
playerManager.skipBackward()

// Seek playback using a slider value
playerManager.updateSeek(with: 0.5)

// Check if media is currently playing
let isPlaying = playerManager.isPlay

// Access the total duration of the media
let totalDuration = playerManager.totalDuration

// Access the current playback duration
let currentDuration = playerManager.currentDuration

// Open an audio player for media playback
let audioPlayerView = playerManager.openAudioPlayer(with: "your_audio_file_url")

// Open a video player for media playback
playerManager.openVideoPlayer(with: "your_video_file_url")











