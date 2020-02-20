//
//  ViewController.swift
//  MPVPN
//
//  Created by manhpham90vn on 05/06/2019.
//  Copyright (c) 2019 manhpham90vn. All rights reserved.
//

import UIKit
import MPVPN

class ViewController: UIViewController {

    let account = Account(serverAddress: "159.65.129.252", sharedSecret: "4ec04e07-f030-4445-ba59-3d8c1cb180a2")
    
    lazy var vpn: VPN = {
        let _vpn = VPN(delegate: self)
        return _vpn
    }()
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBAction func requestBtnTapped(_ sender: Any) {
        vpn.requestPermision(account: account)
    }
    
    @IBAction func connectBtnTapped(_ sender: Any) {
        vpn.connect()
    }
    
    @IBAction func disconnectBtnTapped(_ sender: Any) {
        vpn.disconnect()
    }
    
    @IBAction func removeBtnTapped(_ sender: Any) {
        vpn.removeFromPreferences()
//    }ß
    
    override func viewDidLoad() {
        super.viewDidLoad()
//    }ß

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: VPNDelegate {
    func vpn(_ vpn: VPN, statusDidChange status: VpnStatus) {
        statusLabel.text = status.description
    }
    
    func vpn(_ vpn: VPN, didRequestPermission status: ConnectStatus) {
        print(status.description)
    }
    
    func vpn(_ vpn: VPN, didConnectWithError error: String?) {
        print(error ?? "")
    }
    
    func vpnDidDisconnect(_ vpn: VPN) {
        print("disconnect")
    }
}
