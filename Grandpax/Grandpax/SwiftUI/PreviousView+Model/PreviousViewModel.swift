//
//  PreviousViewModel.swift
//  Grandpax
//
//  Created by Alex Albu on 15.03.2023.
//

import SwiftUI
import RealmSwift

class PreviousViewModel: ObservableObject {
    
    // MARK: - Realm
    
    @ObservedResults(Session.self) var previousSessions
    
    // MARK: - Environment
    
    @Environment(\.realm) var realm
    
    // MARK: - Methods
    
    func removePreviousSession(_ session: Session) {
        do {
            try realm.write({
                realm.delete(session)
            })
        } catch {
            ToastService.shared.showToast(message: "There was an error removing the session")
        }
        ToastService.shared.showToast(message: "Session removed successfully!")
    }
    
    func addSession(_ session: Session) {
        do {
            try realm.write {
                realm.add(session)
            }
        } catch {
            ToastService.shared.showToast(message: "There was an error adding the session")
        }
        ToastService.shared.showToast(message: "Session added successfully!")
    }
}
