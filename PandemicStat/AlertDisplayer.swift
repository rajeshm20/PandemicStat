//
//  AlertDisplayer.swift
//  PandemicStat
//
//  Created by Rajesh M on 11/04/20.
//  Copyright © 2020 Rajesh M. All rights reserved.
//

import Foundation
import UIKit

protocol canPresentViewControllers {
    
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool,
                 completion: (() -> Void)?)
    
    
}

protocol AlertDisplayer {
    var canPresentControllers: canPresentViewControllers { get set }
    func displayAlert(withTitle title: String?, andMessage message: String?)
}

struct ErrorAlertDisplayer: AlertDisplayer {
    
    var canPresentControllers: canPresentViewControllers
    
    init(canPresentControllers: canPresentViewControllers) {
        
        self.canPresentControllers = canPresentControllers
    }
    
    func displayAlert(withTitle title: String?, andMessage message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle:
            .alert)
        alert.addAction( UIAlertAction(title: "OK", style: .cancel, handler: nil) )
        canPresentControllers.present(alert, animated: UIView.areAnimationsEnabled, completion: nil)
    }
    
    
}

protocol canDisplayErrors: class {
    var alertDisplayer: AlertDisplayer { get set }
}

struct AertDisplayer {
    
    var canPresentControllers: canPresentViewControllers
    init(canPresentControllers: canPresentViewControllers) { self.canPresentControllers = canPresentControllers
    }
    func displayAlert(withTitle title: String?, andMessage message: String?) {
        // present UIAlertController
    }
}


extension UIViewController: canPresentViewControllers {}


