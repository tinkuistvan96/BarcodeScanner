# BarcodeScanner
This is an app for scanning barcodes, storing them temporarily and copying their data to clipboard.

## Screen Shots
<img src="https://github.com/tinkuistvan96/BarcodeScanner/files/9392306/barcodescanner_screenshot.pdf" width="70%">

---

## Description

- Acquiring images using AVCaptureSession with AVCaptureDevice as input and AVCaptureMetadataOutput as an output

- The AVCaptureMetadataOutput can be configured to recognize different types of barcodes like ean8 or ean13

- When relevant metadata received, the func metadataOutput(AVCaptureMetadataOutput, didOutput: [AVMetadataObject], from: AVCaptureConnection) is triggered

- Showing the data in a TableView

- Project was completed using UIKit without Storyboard

- Using Protocol Delegate Pattern to communicate between views

#### Technologies / Frameworks

- UIKit

- Programmatic UI

- UITableView
---