//
//  VPNDelegate.swift
//  MPVPN
//
//  Created by Manh Pham on 5/6/19.
//  Copyright © 2019 Manh Pham. All rights reserved.
//

import Foundation

public protocol VPNDelegate: class {
    func vpn(_ vpn: VPN, statusDidChange status: VpnStatus)
    func vpn(_ vpn: VPN, didRequestPermission status: ConnectStatus)
    func vpn(_ vpn: VPN, didConnectWithError error: String?)
    func vpnDidDisconnect(_ vpn: VPN)
}
