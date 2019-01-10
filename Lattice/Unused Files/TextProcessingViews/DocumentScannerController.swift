//
//  DocumentScannerController.swift
//  Lattice
//
//  Created by Eli Zhang on 12/30/18.
//  Copyright © 2018 Eli Zhang. All rights reserved.
//

import UIKit
import SnapKit
import IRLDocumentScanner

class DocumentScannerController: UIViewController, IRLScannerViewControllerDelegate {

    var imageView: UIImageView!
    var scanButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        imageView = UIImageView()
        view.addSubview(imageView)

        scanButton = UIButton()
        scanButton.setTitle("Scan", for: .normal)
        scanButton.addTarget(self, action: #selector(scan(sender:)), for: .touchUpInside)
        view.addSubview(scanButton)
        setupConstraints()
    }

    func setupConstraints() {
        scanButton.snp.makeConstraints { (make) -> Void in
            make.leading.trailing.equalTo(view).inset(30)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.height.equalTo(40)
        }
        imageView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(scanButton.snp.bottom).offset(30)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(30)
        }
    }

    @objc func scan(sender: AnyObject) {
        let scanner = IRLScannerViewController.standardCameraView(with: self)
        scanner.showControls = true
        scanner.showAutoFocusWhiteRectangle = false
        present(scanner, animated: true, completion: nil)
    }

    func pageSnapped(_ image: UIImage, from cameraView: IRLScannerViewController) {
        dismiss(animated: true) { () -> Void in
            let text = PhotoProcessor.processPhoto(image: image)
            let strings = TextSimilarityCheck.findClosestStrings(inputString: text)
            print(text)
            if !strings.isEmpty {
                print(strings)
            }
            self.imageView.image = image
        }
    }

    func didCancel(_ cameraView: IRLScannerViewController) {
        cameraView.dismiss(animated: true) {}
    }

}
