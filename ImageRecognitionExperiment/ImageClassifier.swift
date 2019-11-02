//
//  ImageClassifier.swift
//  ImageRecognitionExperiment
//
//  Created by Matt Crocker on 01/11/2019.
//  Copyright © 2019 Lithobraking Ltd. All rights reserved.
//

import Cocoa
import CoreML
import Vision

class ImageClassifier: NSObject {

    var classification: VNClassificationObservation!
    
    func classify(url: URL) -> VNClassificationObservation{
        
        // The "try" below has to be wrapped in a do/catch
        do {
            // Initialise the model
            // For others see https://github.com/likedan/Awesome-CoreML-Models
            let classifier = try VNCoreMLModel(for: Inceptionv3().model)
            
            // The following makes use of the Vision (VN) framework to avoid having to process the images explicitly
            let request = VNCoreMLRequest(model: classifier, completionHandler: self.handleResults)
            let handler = VNImageRequestHandler(url: url)
            try handler.perform([request])
        
        } catch  {
            print("Something went wrong (\(error))")
        }
    
        return classification
    }
    
    func handleResults(request: VNRequest, error: Error?) {
        guard let results = request.results as? [VNClassificationObservation]
            else {
                fatalError("Classification failed")
                
        }
        classification = results[0]
        
    }
    
}
