//
//  BaseViewController.swift
//  SkyWatchDemo
//
//  Created by BruceWu on 2022/7/7.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
    }
    
    func setNavigationBar(title: String, textColor: UIColor, backgroundColor: UIColor = UIColor(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1)) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = backgroundColor
        appearance.shadowColor = .systemBlue
        let titleAttribute = [NSAttributedString.Key.foregroundColor: textColor]
        appearance.titleTextAttributes = titleAttribute
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        self.title = title
    }
    
    func setTitle(title: String) {
        self.title = title
    }

}
