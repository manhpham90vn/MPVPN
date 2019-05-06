//
//  VpnStatus.swift
//  MPVPN
//
//  Created by Manh Pham on 5/6/19.
//  Copyright © 2019 Manh Pham. All rights reserved.
//

import Foundation

public enum VpnStatus {
    case connected
    case disconnected
    case connecting
    case reasserting
    case disconnecting
    case invalid
    
    public var description: String {
        switch self {
        case .connected:
            return "connected"
        case .disconnected:
            return "disconnected"
        case .connecting:
            return "connecting"
        case .reasserting:
            return "reasserting"
        case .disconnecting:
            return "disconnecting"
        case .invalid:
            return "disconnecting"
        }
    }
}
