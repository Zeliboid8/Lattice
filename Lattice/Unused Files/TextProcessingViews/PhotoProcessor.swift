//
//  PhotoProcessor.swift
//  Lattice
//
//  Created by Eli Zhang on 12/17/18.
//  Copyright © 2018 Eli Zhang. All rights reserved.
//

import UIKit
import TesseractOCR

class PhotoProcessor: NSObject, G8TesseractDelegate {
    
    static func processPhoto(image: UIImage, frame: CGRect, imageViewFrame: CGRect) -> String {
        print("Processing photo")
        var minX = frame.minX
        if minX < 0 { minX = 0 }
        
        var maxX = frame.maxX
        if maxX > imageViewFrame.maxX { maxX = imageViewFrame.maxX }
        
        var minY = frame.minY
        if minY < 0 { minY = 0 }
        
        var maxY = frame.maxY
        if maxY > imageViewFrame.maxY { maxY = imageViewFrame.maxY }
        
        let width = (maxX - minX)
        let height = (maxY - minY)
        
        let rect = CGRect(x: minX, y: minY, width: width, height: height)//.enlarge(factor: 0.2)
        
        if let croppedRect = image.cgImage?.cropping(to: rect) {
            let croppedImage = UIImage(cgImage: croppedRect, scale: image.scale, orientation: image.imageOrientation)
            
            let tesseract: G8Tesseract = G8Tesseract(language: "eng")!
            tesseract.image = croppedImage
            tesseract.recognize()
            return tesseract.recognizedText!
        }
        return ""
    }
    
    static func processPhoto(image: UIImage) -> String {
        let tesseract: G8Tesseract = G8Tesseract(language: "eng")!
        tesseract.image = image
        tesseract.recognize()
        return tesseract.recognizedText!
    }
    
    static func image(with image: UIImage, scaledTo newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? UIImage()
    }
}

extension CGRect {
    func enlarge(factor: CGFloat) -> CGRect {
        let biggerRect = self.insetBy(
            dx: -self.size.width * factor,
            dy: -self.size.height * factor
        )
        return biggerRect
    }
}
