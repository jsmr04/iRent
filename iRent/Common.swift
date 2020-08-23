//
//  Common.swift
//  iRent
//
//  Created by Jose Smith Marmolejos on 2020-08-22.
//  Copyright © 2020 Jose Smith Marmolejos. All rights reserved.
//

import UIKit
class Common {
  static func getDateTime(_ type:String)->String{
       //Getting current date and time
       let formatter = DateFormatter()
       let now = Date()
       
       if type == "DATE"{
           formatter.dateFormat = "yyyy-MM-dd"
       }else{
           formatter.dateFormat = "HH:mm:ss"
       }
       
       let dateString = formatter.string(from:now)
       print(dateString)
       
       return dateString
   }
    static func convertImageToBase64(_ image: UIImage) -> String {
          let imageData:NSData = image.jpegData(compressionQuality: 0.4)! as NSData
             let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
             return strBase64
      }
      
     static func convertBase64ToImage(_ str: String) -> UIImage {
        let dataDecoded : Foundation.Data = Foundation.Data(base64Encoded: str, options: .ignoreUnknownCharacters)!
              let decodedimage = UIImage(data: dataDecoded)
              return decodedimage!
      }
    
    static func convertAudioToBase64(_ url:URL)->String{
        let fileData = NSData(contentsOf: url)
        let base64String = fileData?.base64EncodedString(options: .lineLength64Characters)
        return base64String!
    }
    
    static func convertBase64ToAudio(_ str: String) -> Foundation.Data {
      let dataDecoded : Foundation.Data = Foundation.Data(base64Encoded: str, options: .ignoreUnknownCharacters)!
        
        return dataDecoded
    }
}
