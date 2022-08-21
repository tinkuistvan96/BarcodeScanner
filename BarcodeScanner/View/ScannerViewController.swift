//
//  ScannerViewController.swift
//  BarcodeScanner
//
//  Created by Tinku István on 2022. 03. 05..
//

import AVFoundation
import UIKit

protocol ScannerViewControllerDelegate: AnyObject {
    func didFinishScanning(barcode: Barcode)
}

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    let closeButton = UIButton()
    
    weak var delegate: ScannerViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        style()
        layout()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    func style() {
        view.backgroundColor = UIColor.black
        
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        let boldConfig = UIImage.SymbolConfiguration(font: .boldSystemFont(ofSize: 30), scale: .large)
        let boldClose = UIImage(systemName: "xmark", withConfiguration: boldConfig)?.withTintColor(.white, renderingMode: .alwaysOriginal)
        closeButton.setImage(boldClose, for: .normal)
        closeButton.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
    }
    
    func layout() {
        view.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: closeButton.trailingAnchor, multiplier: 1),
            closeButton.topAnchor.constraint(equalToSystemSpacingBelow: view.topAnchor, multiplier: 1)
        ])
    }
    
    func setup() {
        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417]
        } else {
            failed()
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
    }

    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
    }

    func found(code: String) {
        let ac = UIAlertController(title: "Scanned barcode:", message: code, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Copy", style: .default, handler: { action in
            let pasteBoard = UIPasteboard.general
            pasteBoard.string = code
            self.dismiss(animated: true)
        }))
        ac.addAction(UIAlertAction(title: "Save", style: .default, handler: { action in
            let barcode = Barcode(barcode: code, date: Date(), image: nil)
            self.delegate?.didFinishScanning(barcode: barcode)
            self.dismiss(animated: true)
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { action in
            self.captureSession.startRunning()
        }))
        self.present(ac, animated: true, completion: nil)
    }
    
    @objc func handleClose() {
        self.dismiss(animated: true)
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
