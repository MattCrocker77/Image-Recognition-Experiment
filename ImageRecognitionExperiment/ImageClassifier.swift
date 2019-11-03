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
    var classifier: VNCoreMLModel!
    
    init(model: String = "Inceptionv3") {
        super.init()
        
        // The "try" below has to be wrapped in a do/catch
        do {
            // Initialise the classifier with a pre-trained model
            // For others see https://developer.apple.com/machine-learning/models/ and https://github.com/likedan/Awesome-CoreML-Models
            switch model {
            case "Inceptionv3":
                classifier = try VNCoreMLModel(for: Inceptionv3().model)
            case "MobileNetV2":
                classifier = try VNCoreMLModel(for: MobileNetV2().model)
            case "Resnet50":
                classifier = try VNCoreMLModel(for: Resnet50().model)
            case "VGG16":
                classifier = try VNCoreMLModel(for: VGG16().model)
            default:
                fatalError("Model \"\(model)\" is not known.")
            }
        } catch  {
            print("Unable to initialise classifier model due to error \"(\(error))\"")
        }
    }
    
    func classify(url: URL) -> VNClassificationObservation{
        
        // The "try" below has to be wrapped in a do/catch
        do {
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
