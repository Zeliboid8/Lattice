//
//  QRCode.swift
//  Lattice
//
//  Created by Eli Zhang on 12/19/18.
//  Copyright © 2018 Eli Zhang. All rights reserved.
//
import Alamofire
import AlamofireImage

class QRCode {
    func getProfileQRCode(completion: @escaping (UIImage) -> Void) {
        let customQRCodeURL = "/qr/custom"
        
        let configParams: Parameters =
            ["body": "dot",
             "frame13": "ball",
             "gradientColor1": "#26357E",
             "gradientColor2": "#1082A6",
             "gradientOnEyes": true,
//             "logo": ,
//             "logoMode": "clean"
            ]
        
        let parameters: Parameters =
            ["data": "http://www.github.com/Zeliboid8/Lattice",
            "size": 500,
            "config": configParams,
            "file": "png",
            "download": "false"]
        
        Alamofire.request(customQRCodeURL, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseImage { response in
            guard let image = response.result.value else {
                print("No image found!")
                return
            }
            completion(image)
        }
    }
    
    /*
    func uploadLogo() {
        let uploadLogoURL = "/qr/uploadImage"
        
        
        
        Alamofire.request(uploadLogoURL, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseData { response in
            switch response.result {
            case let .success(data):
                let decoder = JSONDecoder()
                if let user = try? decoder.decode(DeletedUserFromCourseData.self, from: data) {
                    if user.success {
                        completion()
                    }
                }
            case let .failure(error):
                if let data = response.data {
                    let decoder = JSONDecoder()
                    if let errorMessage = try? decoder.decode(ErrorMessage.self, from: data) {
                        print(errorMessage.error)
                    }
                }
                else {
                    print(error.localizedDescription)
                }
            }
        }
    }
 */
}
