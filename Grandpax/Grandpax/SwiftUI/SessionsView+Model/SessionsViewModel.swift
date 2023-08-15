//
//  SessionsViewModel.swift
//  Grandpax
//
//  Created by Alex Albu on 15.03.2023.
//

import SwiftUI
import RealmSwift

class SessionsViewModel: ObservableObject {
    
    // MARK: - Realm
    
    @Published var sessions = [Session]()
    
    // MARK: - Environment
    
    @Environment(\.realm) var realm
    
    // MARK: - Lifecycle
    
    init() {
        sessions = Array(realm.objects(Session.self))
    }
    
    // MARK: - Methods
    
    func hardRemoveSessions() {
        let persistedSessions = realm.objects(Session.self)
        persistedSessions.forEach { persistedSession in
            if sessions.firstIndex(of: persistedSession) == nil {
                hardRemoveSession(persistedSession)
            }
        }
    }
    
    func presentActivityViewControllerWithSnapshot(_ snapshot: String?) -> ActivityViewController {
        if let snapshot {
            let imageData = Data(base64Encoded: snapshot) ?? Data()
            let items: [AnyObject] = [UIImage(data: imageData) ?? UIImage()]
            return ActivityViewController(activityItems: items)
        }
        
        return ActivityViewController(activityItems: [])
    }
    
    func softRemoveSession(_ session: Session) {
        if let sessionIndex = sessions.firstIndex(of: session) {
            sessions.remove(at: sessionIndex)
            ToastService.shared.showToast(message: "Session removed successfully!", type: .success)
        } else {
            ToastService.shared.showToast(message: "There was an error removing the session", type: .error)
        }
    }
    
    func addSession(_ session: Session) {
        do {
            try realm.write {
                realm.add(session)
            }
        } catch {
            ToastService.shared.showToast(message: "There was an error adding the session", type: .error)
        }
        ToastService.shared.showToast(message: "Session added successfully!", type: .success)
    }
    
    private func hardRemoveSession(_ session: Session) {
        try? realm.write {
            realm.delete(session)
        }
    }
}
