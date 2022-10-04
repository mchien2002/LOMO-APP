//
//  FacebookTracking.swift
//  Runner
//
//  Created by Meo Luoi on 20/08/2021.
//

import Foundation
import FBSDKCoreKit

class FacebookTracking{
    static let instance = FacebookTracking()
    
    func tracking(event:String){
        AppEvents.logEvent(AppEvents.Name(event))
    }
}
