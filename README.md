This Flutter project implements the logic for downloading multiple files concurrently. It handles
permission requests, progress tracking, file management, and download cancellation. The core logic
uses a MultiFileDownloaderController that manages multiple FileDownloader instances, each
responsible for downloading a single file with real-time progress updates and error handling.
