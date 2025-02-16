//
//  NFCReader.swift
//  Blendr
//
//  Created by Kevin Nimi on 2024-07-06.
//

import Foundation
import SwiftUI
import CoreNFC

class NFCReader: NSObject, ObservableObject, NFCNDEFReaderSessionDelegate {
    static let shared = NFCReader()
   
    var nfcSession: NFCNDEFReaderSession?
    
    // Propriété pour stocker le message NDEF
    var ndefMessage: NFCNDEFMessage?
    
    func scan(theactualdata: String) {
        guard NFCNDEFReaderSession.readingAvailable else {
            let alertController = UIAlertController(
                title: "Scanning Not Supported",
                message: "This device doesn't support tag scanning.",
                preferredStyle: .alert
            )
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            // Présenter l'alerte ici si vous utilisez SwiftUI
            return
        }

        // Créez un message NDEF à partir de theactualData pour stocker une URL
        guard let url = URL(string: theactualdata) else {
            print("Invalid URL")
            return
        }
        
        // Créez le payload NDEF avec le type U pour les URI
        guard let payload = NFCNDEFPayload.wellKnownTypeURIPayload(url: url) else {
            print("Failed to create payload")
            return
        }
        
        // Assignez le message NDEF
        ndefMessage = NFCNDEFMessage(records: [payload])

        // Initialisez la session NFC
        nfcSession = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: false)
        nfcSession?.alertMessage = "Hold your iPhone near the item to learn more about it."
        nfcSession?.begin()
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        // Gérer l'erreur ici
//        print("NFC Session invalidated: \(error.localizedDescription)")
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        // Gérer les messages détectés ici
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [NFCNDEFTag]) {
        if tags.count > 1 {
            let retryInterval = DispatchTimeInterval.milliseconds(500)
            session.alertMessage = "More than one Tag Detected, please try again"
            DispatchQueue.global().asyncAfter(deadline: .now() + retryInterval) {
                session.restartPolling()
            }
            return
        }
        
        guard let tag = tags.first else { return }
        
        session.connect(to: tag) { (error: Error?) in
            if let error = error {
                session.alertMessage = "Unable To Connect to Tag: \(error.localizedDescription)"
                session.invalidate()
                return
            }
            
            tag.queryNDEFStatus { (ndefStatus: NFCNDEFStatus, capacity: Int, error: Error?) in
                guard error == nil else {
                    session.alertMessage = "Unable to query the NDEF status of tag."
                    session.invalidate()
                    return
                }
                
                switch ndefStatus {
                case .notSupported:
                    session.alertMessage = "Tag is not NDEF compliant."
                    session.invalidate()
                case .readOnly:
                    session.alertMessage = "Tag is read only."
                    session.invalidate()
                case .readWrite:
                    // Vérifie que le message NDEF existe avant d'essayer de l'écrire
                    guard let message = self.ndefMessage else {
                        session.alertMessage = "No NDEF message to write."
                        session.invalidate()
                        return
                    }
                    
                    tag.writeNDEF(message) { (error: Error?) in
                        if let error = error {
                            session.alertMessage = "Write NDEF message failed: \(error.localizedDescription)"
                        } else {
                            session.alertMessage = "Write NDEF message successful."
                        }
                        session.invalidate()
                    }
                @unknown default:
                    session.alertMessage = "Unknown NDEF tag status."
                    session.invalidate()
                }
            }
        }
    }
}
