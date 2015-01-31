//
//  TraitOverrideSplitViewController.swift
//  WeatherGuru
//
//  Created by Aida Zhumabekova on 11/22/14.
//  Copyright (c) 2014 Aida Zhumabekova. All rights reserved.
//

import Foundation
import UIKit

class TraitOverrideSplitViewController: UISplitViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        performTraitCollectionOverrideForSize(view.bounds.size)
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        performTraitCollectionOverrideForSize(size)
    }
    
    private func performTraitCollectionOverrideForSize(size: CGSize) { var overrideTraitCollection: UITraitCollection? = nil
        if size.width > 375 {
            overrideTraitCollection = UITraitCollection(horizontalSizeClass: .Regular)
        }
        
        for vc in self.childViewControllers as [UIViewController] {
            setOverrideTraitCollection(overrideTraitCollection, forChildViewController: vc)
        }
    }
}