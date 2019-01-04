//
//  TextSelectionViewController.swift
//  Lattice
//
//  Created by Eli Zhang on 12/16/18.
//  Copyright © 2018 Eli Zhang. All rights reserved.
//

import UIKit

import UIKit
import SnapKit
import AVFoundation
import Vision

class TextSelectionController: UIViewController {
    
    var imageView: UIImageView!
    var backButton: UIButton!
    var session = AVCaptureSession()
    var cameraOutput = AVCapturePhotoOutput()
    var selectedImage: UIImage!
    var buttonFrame: CGRect!
    var requests = [VNRequest]()
    
    let buttonOffset: CGFloat = 8
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView = UIImageView()
        imageView.tag = 1
        view.addSubview(imageView)
        
        backButton = UIButton()
        backButton.setImage(UIImage(named: "BackArrowWhite"), for: .normal)
        backButton.addTarget(self, action: #selector(dismissModalView), for: .touchUpInside)
        backButton.tag = 1
        view.addSubview(backButton)
        
        startLiveVideo()
        startTextDetection()
        
        setupConstraints()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if session.isRunning {
            session.stopRunning()
        } else {
            session.startRunning()
        }
    }
    
    func setupConstraints() {
        imageView.snp.makeConstraints{ (make) -> Void in
            make.edges.equalTo(view)
        }
        backButton.snp.makeConstraints{ (make) -> Void in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).offset(buttonOffset)
            make.height.width.equalTo(30)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startLiveVideo() {
        session.sessionPreset = AVCaptureSession.Preset.photo
        // Setting up input
        let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)      // Setting the camera to the back camera
        let input = try! AVCaptureDeviceInput(device: backCamera!)
        session.addInput(input)
        
        // Setting up output
        let output = AVCaptureVideoDataOutput()
        output.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
        output.setSampleBufferDelegate(self, queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.default))
        output.alwaysDiscardsLateVideoFrames = true
        session.addOutput(output)
        
        // Setting up camera preview on screen
        session.sessionPreset = AVCaptureSession.Preset.hd1920x1080
        let imageLayer = AVCaptureVideoPreviewLayer(session: session)
        imageLayer.videoGravity = AVLayerVideoGravity.resizeAspect
        imageLayer.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        imageLayer.frame = imageView.bounds
        imageView.layer.addSublayer(imageLayer)
        
        session.startRunning()
    }
    
    override func viewDidLayoutSubviews() {
        imageView.layer.sublayers?[0].frame = imageView.bounds
    }
    
    func startTextDetection() {
        session.addOutput(cameraOutput)
        cameraOutput.isHighResolutionCaptureEnabled = true
        let textRequest = VNDetectTextRectanglesRequest(completionHandler: self.detectTextHandler)
        textRequest.reportCharacterBoxes = true
        self.requests = [textRequest]
    }
    
    func detectTextHandler(request: VNRequest, error: Error?) {
        guard let observations = request.results else {
            print("No result found.")
            return
        }
        
        let result = observations.map({$0 as? VNTextObservation})
        
        DispatchQueue.main.async() {
            for subview in self.view.subviews {
                if subview.tag != 1 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        subview.removeFromSuperview()                   // Clears all buttons
                    }
                }
            }
            self.imageView.layer.sublayers?.removeSubrange(1...)        // Clears the previous layers
            
            for region in result {
                guard let rg = region else {
                    continue
                }
                
                self.highlightWord(box: rg)
            }
        }
    }
    
    func highlightWord(box: VNTextObservation) {
        let flippedBox = CGRect(x: box.boundingBox.origin.x, y: 1 - box.boundingBox.origin.y - box.boundingBox.height,
                                width: box.boundingBox.size.width, height: box.boundingBox.size.height)
        let x = flippedBox.origin.x * imageView.frame.size.width
        let y = flippedBox.origin.y * imageView.frame.size.height
        let width = flippedBox.width * imageView.frame.size.width
        let height = flippedBox.height * imageView.frame.size.height
        
        let wordOutline = CALayer()
        wordOutline.frame = CGRect(x: x, y: y, width: width, height: height).enlarge(factor: 0.1) // Increases box size by a bit for text recognition
        wordOutline.borderWidth = 1.5
        wordOutline.borderColor = UIColor.red.cgColor
        
        let button = UIButton(frame: CGRect(x: x, y: y, width: width, height: height).enlarge(factor: 0.1))     // Correct repositioning
        button.layer.backgroundColor = UIColor.white.cgColor
        button.layer.opacity = 0.1
        button.addTarget(self, action: #selector(captureAndProcessText(sender:)), for: .touchUpInside)
        view.addSubview(button)
        imageView.layer.addSublayer(wordOutline)
    }
    
    @objc func captureAndProcessText(sender: UIButton) {
        buttonFrame = sender.frame
        capturePhoto()
    }
    
    func processPhoto() {
        let resizedImage = PhotoProcessor.image(with: selectedImage, scaledTo: CGSize(width: imageView.frame.width, height: imageView.frame.height))
        let text = PhotoProcessor.processPhoto(image: resizedImage, frame: buttonFrame, imageViewFrame: imageView.frame)
        print("Text: \(text)")
        let strings = TextSimilarityCheck.findClosestStrings(inputString: text)
        if !strings.isEmpty {
            presentNewEventView(strings: strings)
        }
    }
    
    @objc func dismissModalView() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func presentNewEventView(strings: Set<String>) {
        let newEventView = EventCreationController()
        newEventView.modalPresentationStyle = .overCurrentContext
        present(newEventView, animated: true, completion: nil)
    }
}

extension TextSelectionController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        var requestOptions:[VNImageOption : Any] = [:]
        
        if let camData = CMGetAttachment(sampleBuffer, key: kCMSampleBufferAttachmentKey_CameraIntrinsicMatrix, attachmentModeOut: nil) {
            requestOptions = [.cameraIntrinsics:camData]
        }
        
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: CGImagePropertyOrientation(rawValue: 6)!, options: requestOptions)
        
        do {
            try imageRequestHandler.perform(self.requests)
        } catch {
            print(error)
        }
    }
}

extension TextSelectionController: AVCapturePhotoCaptureDelegate {
    func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
        let previewFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
                             kCVPixelBufferWidthKey as String: 160,
                             kCVPixelBufferHeightKey as String: 160]
        settings.previewPhotoFormat = previewFormat
        self.cameraOutput.capturePhoto(with: settings, delegate: self)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard error == nil else {
            print("Error: \(String(describing: error))")
            return
        }
        guard let imageData = photo.fileDataRepresentation() else {
            print("Failed to get image data from photo")
            return
        }
        guard let capturedImage = UIImage.init(data: imageData , scale: 1.0) else {
            print("Failed to make a UIImage")
            return
        }

        selectedImage = capturedImage
        processPhoto()
    }
}
