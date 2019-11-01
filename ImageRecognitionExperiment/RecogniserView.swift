//
//  RecogniserView.swift
//  ImageRecognitionExperiment
//
//  Created by Matt Crocker on 01/11/2019.
//  Copyright © 2019 Lithobraking Ltd. All rights reserved.
//

import Cocoa

protocol DragViewDelegate {
    func processDraggedURLs(_ urls: [URL])
}

class RecogniserView: NSView {
    
    var delegate: DragViewDelegate?
    
    var isReceivingDrag = false {
        didSet {
            needsDisplay = true
        }
    }
    
    override func awakeFromNib() {
        registerForDraggedTypes([.fileURL])
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    // MARK: - Drag and drop methods
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        
        // Is this drag permitted?
        let allowed = shouldAllowDrag(sender)
        isReceivingDrag = allowed
        
        if allowed {
            return NSDragOperation.copy
        }
        else {
            return NSDragOperation() //alternatively: []
        }
    }
    
    // This next function is used to filter dragged items to make sure we can do something with them
    func shouldAllowDrag(_ draggingInfo: NSDraggingInfo) -> Bool {
        
        var canAccept = false
        let pasteBoard = draggingInfo.draggingPasteboard
        if pasteBoard.canReadObject(forClasses: [NSURL.self], options: [:]) {
            canAccept = true
        }
        return canAccept
        
    }
    
    override func draggingExited(_ sender: NSDraggingInfo?) {
        isReceivingDrag = false
    }
    
    override func draggingEnded(_ sender: NSDraggingInfo?) {
        isReceivingDrag = false
    }
    
    override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
        let allowed = shouldAllowDrag(sender)
        return allowed
    }
    
    override func performDragOperation(_ draggingInfo: NSDraggingInfo) -> Bool {
        
        isReceivingDrag = false
        let pasteBoard = draggingInfo.draggingPasteboard
        
        
        if let urls = pasteBoard.readObjects(forClasses: [NSURL.self], options:[:]) as? [URL], urls.count > 0 {
            print(urls)
            delegate?.processDraggedURLs(urls)
            return true
        }
        return false
        
    }
    
}
