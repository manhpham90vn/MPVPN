//
//  Vpn.swift
//  MPVPN
//
//  Created by Manh Pham on 5/6/19.
//  Copyright © 2019 Manh Pham. All rights reserved.
//

import Foundation
import NetworkExtension

public final class VPN {
    
    public static let share = VPN()
    public weak var delegate: VPNDelegate?
    
    public func status() -> VpnStatus {
        guard let status = self.vpnStatus else { return .invalid}
        switch status {
        case .connected: return .connected
        case .connecting: return .connecting
        case .disconnected: return .disconnected
        case .disconnecting: return .disconnecting
        case .invalid: return .invalid
        case .reasserting: return .reasserting
        }
    }
    
    private let KEYCHAIN_VPN_SECRET = "keychain_vpn_secret"
    private var vpnStatus: NEVPNStatus!
    private var manager: NEVPNManager {
        return NEVPNManager.shared()
    }
    
    private init() {
        addObservers()
    }
    
    deinit {
        removeObservers()
    }
    
    public func requestPermision(account: Account) {
        loadFromPreferences {
            self.save(account: account)
        }
    }
    
    private func loadFromPreferences(completion: @escaping () -> Void) {
        manager.loadFromPreferences { error in
            guard error == nil else {
                self.delegate?.vpn(self, didRequestPermission: .failure)
                return
            }
            completion()
        }
    }
    
    public func removeFromPreferences() {
        manager.removeFromPreferences { (_) in
            
        }
    }
    
    public func save(account: Account) {
        
        KeychainWrapper.standard.set(account.sharedSecret, forKey: KEYCHAIN_VPN_SECRET)
        let passwordDataRef = KeychainWrapper.standard.dataRef(forKey: KEYCHAIN_VPN_SECRET)
        guard let passwordRef = passwordDataRef else {
            self.delegate?.vpn(self, didConnectWithError: "Unable to save password to keychain")
            return
        }
        
        let neVPNProtocolIKEv2 = NEVPNProtocolIKEv2()
        neVPNProtocolIKEv2.remoteIdentifier = account.serverAddress
        neVPNProtocolIKEv2.serverAddress = account.serverAddress
        neVPNProtocolIKEv2.useExtendedAuthentication = true
        neVPNProtocolIKEv2.authenticationMethod = .sharedSecret
        neVPNProtocolIKEv2.sharedSecretReference = passwordRef
        neVPNProtocolIKEv2.disconnectOnSleep = false
        
        manager.protocolConfiguration = neVPNProtocolIKEv2
        manager.isEnabled = true
        
        manager.saveToPreferences { (error) in
            guard error == nil else {
                self.delegate?.vpn(self, didRequestPermission: .failure)
                return
            }
            self.delegate?.vpn(self, didRequestPermission: .success)
        }
    }
    
    public func connect() {
        do {
            try manager.connection.startVPNTunnel()
        } catch NEVPNError.configurationInvalid {
            self.delegate?.vpn(self, didConnectWithError: "configurationInvalid")
        } catch NEVPNError.configurationDisabled {
            self.delegate?.vpn(self, didConnectWithError: "configurationDisabled")
        } catch NEVPNError.configurationReadWriteFailed {
            self.delegate?.vpn(self, didConnectWithError: "configurationReadWriteFailed")
        } catch NEVPNError.configurationStale {
            self.delegate?.vpn(self, didConnectWithError: "configurationStale")
        } catch {
            self.delegate?.vpn(self, didConnectWithError: "error")
        }
    }
    
    public func disconnect() {
        manager.connection.stopVPNTunnel()
        delegate?.vpnDidDisconnect(self)
    }
    
    public func toggleVpn() {
        if vpnStatus == .connected  {
            disconnect()
        } else if vpnStatus == .disconnected {
            connect()
        }
    }
    
    private func addObservers(inQueue queue: OperationQueue = OperationQueue.main) {
        NotificationCenter
            .default
            .addObserver(
                forName: NSNotification.Name.NEVPNStatusDidChange,
                object: nil,
                queue: queue,
                using: { notification in
                    let vpnConnection = notification.object as! NEVPNConnection
                    self.vpnStatus = vpnConnection.status
                    if self.vpnStatus == .connected {
                        self.delegate?.vpn(self, statusDidChange: .connected)
                    } else if self.vpnStatus == .disconnected {
                        self.delegate?.vpn(self, statusDidChange: .disconnected)
                    } else if self.vpnStatus == .connecting {
                        self.delegate?.vpn(self, statusDidChange: .connecting)
                    } else if self.vpnStatus == .reasserting {
                        self.delegate?.vpn(self, statusDidChange: .reasserting)
                    } else if self.vpnStatus == .disconnecting {
                        self.delegate?.vpn(self, statusDidChange: .disconnecting)
                    } else if self.vpnStatus == .invalid {
                        self.delegate?.vpn(self, statusDidChange: .invalid)
                    }
            })
    }
    
    
    private func removeObservers() {
        NotificationCenter.default.removeObserver(
            self,
            name: NSNotification.Name.NEVPNStatusDidChange,
            object: nil
        )
    }
    
}
