//
//  BarcodeTableViewController.swift
//  BarcodeScanner
//
//  Created by Tinku István on 2022. 03. 07..
//

import UIKit

class BarcodeTableViewController: UITableViewController, ScannerViewControllerDelegate {
    
    var barcodes = [Barcode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        navigationItem.title = "BarcodeList"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.isTranslucent = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func didFinishScanning(barcode: Barcode) {
        barcodes.append(barcode)
        tableView.reloadData()
    }
    
}

//MARK: - Datasource
extension BarcodeTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return barcodes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.image = UIImage(systemName: "barcode")
        content.text = barcodes[indexPath.row].barcode
        content.secondaryText = barcodes[indexPath.row].date.formatted(date: .numeric, time: .standard)
        cell.contentConfiguration = content
        return cell
    }
}
