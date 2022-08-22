//
//  HomeViewController.swift
//  BarcodeScanner
//
//  Created by Tinku István on 2022. 03. 05..
//

import UIKit

class HomeViewController: UIViewController {
    
    let imageView = UIImageView()
    let scanButton = UIButton(type: .system)
    var scannerViewController : ScannerViewController?

    init(scannerVC: ScannerViewController) {
        super.init(nibName: nil, bundle: nil)
        self.scannerViewController = scannerVC
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
    }
}

extension HomeViewController {
    private func style() {
        navigationItem.title = "BarcodeScanner"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemGray5
        navigationController?.navigationBar.isTranslucent = false
        let scanImage = UIImage(systemName: "barcode.viewfinder")
        
        imageView.image = scanImage?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        scanButton.setTitle("Scan", for: .normal)
        scanButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title3)
        scanButton.backgroundColor = .systemTeal
        scanButton.setTitleColor(.white, for: .normal)
        scanButton.layer.cornerRadius = 12
        scanButton.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        scanButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func layout() {
        view.addSubview(imageView)
        view.addSubview(scanButton)
        
        //imageView
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 100),
            imageView.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        //scanButton
        NSLayoutConstraint.activate([
            scanButton.topAnchor.constraint(equalToSystemSpacingBelow: imageView.bottomAnchor, multiplier: 3),
            scanButton.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 3),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: scanButton.trailingAnchor, multiplier: 2)
        ])
    }
    
    @objc func handleTap() {
        if let scannerVC = scannerViewController {
            present(scannerVC, animated: true, completion: nil)
        }
    }
}
