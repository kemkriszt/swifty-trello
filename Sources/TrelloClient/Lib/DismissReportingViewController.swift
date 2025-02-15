//
//  DismissReportingViewController.swift
//  Briefed
//
//  Created by Krisztián Kemenes on 10.02.2025.
//

#if canImport(UIKit)
import UIKit

class DismissReportingViewController: UIViewController, UIAdaptivePresentationControllerDelegate {
    var dismissHandler: (() -> Void)? = nil
    
    override func viewWillAppear(_ animated: Bool) {
        presentationController?.delegate = self
    }
    
    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        dismissHandler?()
    }
}

#endif
