//
//  ConnectStatus.swift
//  MPVPN
//
//  Created by Manh Pham on 5/6/19.
//  Copyright © 2019 Manh Pham. All rights reserved.
//

import Foundation

public enum ConnectStatus {
    case success
    case failure
    
    public var description: String {
        switch self {
        case .success:
            return "success"
        case .failure:
            return "failure"
        }
    }
}
