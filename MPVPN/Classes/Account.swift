//
//  Account.swift
//  MPVPN
//
//  Created by Manh Pham on 5/6/19.
//  Copyright © 2019 Manh Pham. All rights reserved.
//

import Foundation

public struct Account {
    
    var serverAddress: String
    var sharedSecret: String
    
    public init(serverAddress: String, sharedSecret: String) {
        self.serverAddress = serverAddress
        self.sharedSecret = sharedSecret
    }
}
