//
//  HideKeyboard.swift
//  videoSearch
//
//  Created by Arihant Arora on 7/17/18.
//  Copyright © 2018 Arihant Arora. All rights reserved.
//

import Foundation
import UIKit


extension UIViewController
{
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
