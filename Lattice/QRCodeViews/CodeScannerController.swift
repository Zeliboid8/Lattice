//
//  CodeScannerController.swift
//  Lattice
//
//  Created by Eli Zhang on 12/18/18.
//  Copyright © 2018 Eli Zhang. All rights reserved.
//

import UIKit

import UIKit
import SnapKit
import AVFoundation
import Vision

class CodeScannerController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var imageView: UIImageView!
    var backButton: UIButton!
    var session = AVCaptureSession()
    
    var qrCodeFrameView: UIView!
    var imageLayer: AVCaptureVideoPreviewLayer!
    
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
        
        // Initialize QR Code Frame to highlight the QR code
        qrCodeFrameView = UIView()
        
        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView)
            view.bringSubviewToFront(qrCodeFrameView)
        }
        
        startLiveVideo()        
        setUpConstraints()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if session.isRunning {
            session.stopRunning()
        } else {
            session.startRunning()
        }
    }
    
    func setUpConstraints() {
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
        // Setting up input
        let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)      // Setting the camera to the back camera
        let input = try! AVCaptureDeviceInput(device: backCamera!)
        session.addInput(input)
        
        // Setting up output
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        // Setting up camera preview on screen
        session.sessionPreset = AVCaptureSession.Preset.hd1920x1080
        imageLayer = AVCaptureVideoPreviewLayer(session: session)
        imageLayer.videoGravity = AVLayerVideoGravity.resizeAspect
        imageLayer.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        imageLayer.frame = imageView.bounds
        imageView.layer.addSublayer(imageLayer)
        
        session.startRunning()
    }
    
    override func viewDidLayoutSubviews() {
        imageView.layer.sublayers?[0].frame = imageView.bounds
    }
    
    @objc func dismissModalView() {
        dismiss(animated: true, completion: nil)
    }
}

extension CodeScannerController {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            print("No QR code is detected")
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = imageLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                print(metadataObj.stringValue)
            }
        }
    }
}
