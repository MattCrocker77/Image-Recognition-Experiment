//
//  ViewController.swift
//  ImageRecognitionExperiment
//
//  Created by Matt Crocker on 01/11/2019.
//  Copyright © 2019 Lithobraking Ltd. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    var visualEffect: NSVisualEffectView!

    @IBOutlet weak var recogniserView: RecogniserView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addVibrancy()

    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func addVibrancy() {
        visualEffect = NSVisualEffectView()
        visualEffect.translatesAutoresizingMaskIntoConstraints = false
        visualEffect.state = .active
        
        // Default material is ".appearanceBased"
        visualEffect.material = .fullScreenUI
        
        // The following is used to position a view relative to another (front to back).
        // If relativeTo is nil then the view is placed behind all its siblings.
        view.addSubview(visualEffect, positioned: NSWindow.OrderingMode.below, relativeTo: nil)
        
        // Ensure the NSVisualEffectView fills the window
        visualEffect.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        visualEffect.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        visualEffect.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        visualEffect.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }


}

