//
//  Constant.swift
//  CareemTestEvaluation
//
//  Created by Silver Shark on 16/05/18.
//  Copyright © 2018 RudraApps. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration

//MARK: - API URL COMPONENTS
let API_KEY = "2696829a81b1b5827d515ff121700838"
let BASE_URL = "http://api.themoviedb.org/"
let API_PATH = "3/"

//MARK: - IMAGE URL COMPONENTS
let IMAGE_BASEURL = "http://image.tmdb.org"
let IMAGE_PATH = "/t/p/"


//MARK: - COREDB ENTITIES
let ENITYTSEARCH = "SearchQuery"

//MARK: - Network indicator
public func ShowNetworkIndicator(_ xx :Bool){
    UIApplication.shared.isNetworkActivityIndicatorVisible = xx
}

//MARK: - Check Internet connection
func isConnectedToNetwork() -> Bool {
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
    zeroAddress.sin_family = sa_family_t(AF_INET)
    let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
            SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
        }
    }
    var flags = SCNetworkReachabilityFlags()
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
        return false
    }
    let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
    let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
    return (isReachable && !needsConnection)
}

//MARK: - CREATE RANDOM COLOR WITH ALPHA
public func randomColorWith( _ alpha : CGFloat) -> UIColor {
    let r: UInt32 = arc4random_uniform(255)
    let g: UInt32 = arc4random_uniform(255)
    let b: UInt32 = arc4random_uniform(255)
    return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
}
