//
//  Communicator.swift
//  TinkoffFintechIOSProject
//
//  Created by Юрий Забегаев on 24/10/2018.
//  Copyright © 2018 Юрий Забегаев. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class MultipeerCommunicator: NSObject {

    // MARK: - Properties

    private(set) var serviceType = "tinkoff-chat"
    private var discoveryInfo: [String: String]

    private let myPeerId: MCPeerID

    private let defaultTimeout: TimeInterval = 60

    private var sessionsForPeer: [MCPeerID: MCSession] = [:]

    private let serviceAdvertiser: MCNearbyServiceAdvertiser
    private let serviceBrowser: MCNearbyServiceBrowser

    weak var delegate: CommunicatorDelegate?
    var online: Bool = true

    var myUserID: String {
        return myPeerId.displayName
    }

    var visibleUserName: String {
        get {
            return discoveryInfo["userName"]!
        }
        set(newName) {
            discoveryInfo["userName"] = newName
        }
    }

    // MARK: - Initialization

    init(username: String) {

        discoveryInfo = ["userName": username]
        myPeerId = MCPeerID(displayName: UIDevice.current.name)

        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: discoveryInfo, serviceType: serviceType)
        serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: serviceType)

        super.init()

        serviceAdvertiser.delegate = self
        serviceAdvertiser.startAdvertisingPeer()

        serviceBrowser.delegate = self
        serviceBrowser.startBrowsingForPeers()
    }

    deinit {
        serviceBrowser.stopBrowsingForPeers()
        serviceAdvertiser.stopAdvertisingPeer()

        for session in sessionsForPeer.values {
            session.disconnect()
        }
    }

}

extension MultipeerCommunicator: Communicator {

    func sendMessage(string: String, to userId: String, completionHandler: ((Bool, Error?) -> Void)?) {
        guard let receiverPeerID = sessionsForPeer.keys.first(where: {peer in
            peer.displayName == userId
        }) else {
            let error = MultipeerCommunicatorError.sessionNotFoundError(#function + " No peer found for given userId")
            completionHandler?(false, error)
            return
        }

        guard let session = sessionsForPeer[receiverPeerID] else {
            let error = MultipeerCommunicatorError.sessionNotFoundError(#function + " No session available for given userId")
            completionHandler?(false, error)
            return
        }
        let message = MultipeerCommunicatorMessage(text: string)
        do {
            let messageData = try message.encoded()
            try session.send(messageData, toPeers: [receiverPeerID], with: .reliable)
        } catch let error {
            let error = MultipeerCommunicatorError.unableToSendMessage(error)
            completionHandler?(false, error)
            return
        }
        completionHandler?(true, nil)
    }
}

extension MultipeerCommunicator: MCSessionDelegate {

    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {

        switch state {
        case .connected:
            print(peerID.displayName + " is connected")
        case .notConnected:
            print(peerID.displayName + " not connected")
            serviceBrowser.invitePeer(peerID, to: session, withContext: nil, timeout: defaultTimeout)
        case .connecting:
            print(peerID.displayName + " connecting")
        }
    }

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        if let message = try? MultipeerCommunicatorMessage(jsonData: data) {
            let sender = peerID.displayName
            delegate?.didReceiveMessage(text: message.text,
                                        fromUser: sender,
                                        toUser: myPeerId.displayName)
        }
    }

    func session(_ session: MCSession,
				 didReceive stream: InputStream,
				 withName streamName: String,
				 fromPeer peerID: MCPeerID) {
        return
    }

    func session(_ session: MCSession,
				 didStartReceivingResourceWithName resourceName: String,
				 fromPeer peerID: MCPeerID,
				 with progress: Progress) {
        return
    }

    func session(_ session: MCSession,
				 didFinishReceivingResourceWithName resourceName: String,
				 fromPeer peerID: MCPeerID,
				 at localURL: URL?,
				 withError error: Error?) {
        return
    }

}

extension MultipeerCommunicator: MCNearbyServiceAdvertiserDelegate {

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {

        // check if peer has a session already established
        if let oldSession = sessionsForPeer[peerID] {
            invitationHandler(true, oldSession)
            return
        }

        let newSession = MCSession(peer: myPeerId, securityIdentity: nil, encryptionPreference: .none)
        newSession.delegate = self
        sessionsForPeer[peerID] = newSession

        invitationHandler(true, newSession)
    }

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        delegate?.failedToStartAdvertising(error: error)
    }

}

extension MultipeerCommunicator: MCNearbyServiceBrowserDelegate {

    func browser(_ browser: MCNearbyServiceBrowser,
				 foundPeer peerID: MCPeerID,
				 withDiscoveryInfo info: [String: String]?) {

        if peerID.displayName == myPeerId.displayName {
            return
        }

        delegate?.didFoundUser(userId: peerID.displayName, userName: info?["userName"])

        // check if peer has a session already established
        if sessionsForPeer[peerID] != nil {
            return
        }

        // make an invite
        let newSession = MCSession(peer: myPeerId, securityIdentity: nil, encryptionPreference: .none)
        newSession.delegate = self
        browser.invitePeer(peerID, to: newSession, withContext: nil, timeout: defaultTimeout)

        sessionsForPeer[peerID] = newSession
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {

        if peerID.displayName == myPeerId.displayName {
            return
        }
        if sessionsForPeer.removeValue(forKey: peerID) != nil {
            delegate?.didLostUser(userId: peerID.displayName)
        }
    }

    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        delegate?.failedToStartBrowsingForUsers(error: error)
    }

}

extension MultipeerCommunicator {
    enum MultipeerCommunicatorError: Error {
        case sessionNotFoundError(String)
        case unableToSendMessage(Error)
    }

    private struct MultipeerCommunicatorMessage: Codable {
        private static let decoder = JSONDecoder()
        private static let encoder = JSONEncoder()

        private(set) var eventType: String = "TextMessage"
        private(set) var messageId: String
        private(set) var text: String

        init(text: String) {
            self.text = text
            self.messageId = MultipeerCommunicatorMessage.generateMessagId()
        }

        init(jsonData: Data) throws {
            do {
                self = try MultipeerCommunicatorMessage.decoder
					.decode(MultipeerCommunicatorMessage.self, from: jsonData)
            } catch let error {
                throw error
            }
        }

        func encoded() throws -> Data {
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(self)
                return data
            } catch let error {
                throw error
            }
        }

        private static func generateMessagId() -> String {
			return """
				(arc4random_uniform(UINT32_MAX))+\(Date.timeIntervalSinceReferenceDate)+
				\(arc4random_uniform(UINT32_MAX))
				"""
				.data(using: .utf8)!.base64EncodedString()
        }

    }
}
