//
//  TabBarController.swift
//  BarcodeScanner
//
//  Created by Tinku István on 2022. 03. 07..
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    private func setupTabBar() {
        view.backgroundColor = .systemBackground
        UITabBar.appearance().tintColor = .systemTeal
        tabBar.isTranslucent = false
        let scannerVC = ScannerViewController()
        let vc = HomeViewController(scannerVC: scannerVC)
        let barcodeTable = BarcodeTableViewController()
        scannerVC.delegate = barcodeTable
        
        let nav1 = UINavigationController(rootViewController: vc)
        nav1.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "barcode.viewfinder"), tag: 1)
        let nav2 = UINavigationController(rootViewController: barcodeTable)
        nav2.tabBarItem = UITabBarItem(title: "Barcodes", image: UIImage(systemName: "list.bullet"), tag: 2)
        viewControllers = [nav1, nav2]
    }
}
