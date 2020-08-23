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
}
