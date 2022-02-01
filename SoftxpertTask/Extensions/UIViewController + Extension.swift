//
//  UIViewController + Extension.swift
//  SoftxpertTask
//
//  Created by Macbook on 29/01/2022.
//

import Foundation
import MBProgressHUD

extension UIViewController {
    func showIndicator(withTitle title: String, and description: String) {
        let indicator = MBProgressHUD.showAdded(to: self.view, animated: true)
        indicator.label.text = title
        indicator.isUserInteractionEnabled = false
        indicator.detailsLabel.text = description
        indicator.show(animated: true)
        self.view.isUserInteractionEnabled = false
    }
    func hideIndicator() {
        MBProgressHUD.hide(for: self.view, animated: true)
        self.view.isUserInteractionEnabled = true
    }
}
