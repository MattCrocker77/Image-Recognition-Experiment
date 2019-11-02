# Image-Recognition-Experiment
Stand-alone experiment to test Swift's built-in machine learning capabilities on the desktop.

## Raison D'etre
The examples provided by Apple and third parties for using the image classification capabilities of CoreML tend to focus upon iOS platforms and on building and training a model.  This repository contains a stand-alone application onto which a user can drag and drop an image file and have a pre-trained image classifier produce its best guess.

## Requirements
The model was developed using Xcode 10 and Swift 4 on a MacBook Pro.

The pre-trained classifier models are not included in the repository as
* They can be big.
* They may be subject to license restrictions.
The good news is that they can be downloaded from [Apple](https://developer.apple.com/machine-learning/models/) or [third parties](https://github.com/likedan/Awesome-CoreML-Models).  The code as supplied here assumes that you have access to the Inceptionv3 model from the latter.  To use it, just download it from [here](https://github.com/yulingtianxia/Core-ML-Sample/blob/master/CoreMLSample/Inceptionv3.mlmodel) and add it to your Xcode project.

If you use a different model change line `23` of `ImageClassifier.swift` from
```
let classifier = try VNCoreMLModel(for: Inceptionv3().model)
```
to reference the appropriate model.

## Running
The model should run directly from Xcode.  You will be presented with a window like the one below

![empty window](./ImageRecognitionExperiment/docs/Empty.png)
