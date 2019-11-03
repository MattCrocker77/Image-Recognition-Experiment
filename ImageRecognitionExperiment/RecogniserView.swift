//
//  RecogniserView.swift
//  ImageRecognitionExperiment
//
//  Created by Matt Crocker on 01/11/2019.
//  Copyright © 2019 Lithobraking Ltd. All rights reserved.
//

import Cocoa

class RecogniserView: NSView {
    
    // Sub views
    var classificationLayer = CATextLayer()
    var imageLayer = CAShapeLayer()

    let allowedTypes = ["jpg", "jpeg", "bmp", "png", "gif"]
    
    var isReceivingDrag = false {
        didSet {
            needsDisplay = true
        }
    }
    
    override func awakeFromNib() {
        registerForDraggedTypes([.fileURL])
        
        // Enable layer-backed (Core Animation) drawing.
        self.wantsLayer = true
        self.layerContentsRedrawPolicy = NSView.LayerContentsRedrawPolicy.duringViewResize
        
        // Text layer
        let titleFontName = "Helvetica-Bold" as CFString
        let titleFontSize: CGFloat = 14.0
        classificationLayer.string = "Drag images here to classify them"
        classificationLayer.font = CTFontCreateWithName(titleFontName, titleFontSize, nil)
        classificationLayer.fontSize = 14.0
        classificationLayer.alignmentMode = CATextLayerAlignmentMode.center
        classificationLayer.cornerRadius = 4.0
        classificationLayer.shadowRadius = 3.0
        classificationLayer.shadowOpacity = 0.8
        classificationLayer.shadowColor = CGColor.black
        classificationLayer.masksToBounds = true
        classificationLayer.contentsGravity = CALayerContentsGravity.resizeAspectFill
        classificationLayer.contentsScale = (NSScreen.main?.backingScaleFactor)!  // Ensure scaling for retina displays
        self.layer?.addSublayer(classificationLayer)
        
        // Image layer
        imageLayer.lineWidth = 1.0
        imageLayer.strokeColor = CGColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.9)
        imageLayer.fillColor = CGColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.1)
        imageLayer.cornerRadius = 4.0
        imageLayer.masksToBounds = true
        imageLayer.contentsGravity = CALayerContentsGravity.resizeAspect
        imageLayer.contentsScale = (NSScreen.main?.backingScaleFactor)!  // Ensure scaling for retina displays
        self.layer?.insertSublayer(imageLayer, below: classificationLayer)
        
    }
    
    override var wantsUpdateLayer: Bool {
        return true
    }
    
    override func updateLayer() {
        super.updateLayer()
        
        // The following two lines disable the animations that you get by default with CALayers.
        // Whilst pretty they cause an obvious lag in the redrawing
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        imageLayer.frame = NSInsetRect(self.layer!.bounds, 10.0, 10.0)
        classificationLayer.frame = NSInsetRect(self.layer!.bounds, 20.0, 20.0)
        
        CATransaction.commit()
        
    }
    
    // MARK: - Drag and drop methods
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        
        // Is this drag permitted?
        let allowed = shouldAllowDrag(sender, types:allowedTypes)
        isReceivingDrag = allowed
        
        if allowed {
            return NSDragOperation.copy
        }
        else {
            return NSDragOperation() //alternatively: []
        }
    }
    
    // This next function is used to filter dragged items to make sure we can do something with them
    func shouldAllowDrag(_ draggingInfo: NSDraggingInfo, types: [String]) -> Bool {
        
        let pasteBoard = draggingInfo.draggingPasteboard
        if let urls = pasteBoard.readObjects(forClasses: [NSURL.self], options:[:]) as? [URL], urls.count > 0 {
            
            // Process the images one-by-one
            let url = urls[0]
            let fileExtension = url.pathExtension.lowercased()
            
            return types.contains(fileExtension)
            }
        
        return false
    }
    
    override func draggingExited(_ sender: NSDraggingInfo?) {
        isReceivingDrag = false
    }
    
    override func draggingEnded(_ sender: NSDraggingInfo?) {
        isReceivingDrag = false
    }
    
    override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
        let allowed = shouldAllowDrag(sender, types: allowedTypes)
        return allowed
    }
    
    override func performDragOperation(_ draggingInfo: NSDraggingInfo) -> Bool {
        
        isReceivingDrag = false
        let pasteBoard = draggingInfo.draggingPasteboard
        
        
        if let urls = pasteBoard.readObjects(forClasses: [NSURL.self], options:[:]) as? [URL], urls.count > 0 {
            
            let classifier = ImageClassifier(model: "Inceptionv3")
            
            // Process the images one-by-one
            for url in urls {
                
                // Add the image at the URL to the layer
                self.imageLayer.contents = NSImage(byReferencing: url)
                
                let classification = classifier.classify(url: url)
                classificationLayer.string = String(format: "%@: %.1f%%", classification.identifier, 100.0*classification.confidence)
                
                return true
            }
        }
        return false
        
    }
    
}
