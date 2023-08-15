//
//  SessionsViewModelTests.swift
//  GrandpaxTests
//
//  Created by Alex Albu on 18.06.2023.
//

import XCTest
import RealmSwift

@testable import Grandpax

class SessionsViewModelTests: XCTestCase {
    
    var viewModel: SessionsViewModel!
    var realm: Realm!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        realm = try Realm(configuration: Realm.Configuration(inMemoryIdentifier: "testRealm"))
        viewModel = SessionsViewModel()
    }
    
    override func tearDownWithError() throws {
        realm = nil
        viewModel = nil
        try super.tearDownWithError()
    }
    
    func testAddSession() {
        // Given
        let session = RealmSession()
        
        // When
        viewModel.addSession(session)
        
        // Then
        XCTAssertTrue(viewModel.realm.objects(RealmSession.self).count == viewModel.sessions.count + 1)
    }
    
    func testSoftRemoveSession() {
        // Given
        let session = RealmSession()
        viewModel.addSession(session)
        
        // When
        viewModel.softRemoveSession(session)
        
        // Then
        XCTAssertFalse(viewModel.sessions.contains(session))
    }
    
    func testHardRemoveSessions() {
        // Given
        let session1 = RealmSession()
        let session2 = RealmSession()
        let session3 = RealmSession()
        viewModel.addSession(session1)
        viewModel.addSession(session2)
        viewModel.addSession(session3)
        
        // When
        viewModel.hardRemoveSessions()
        
        // Then
        XCTAssertFalse(viewModel.sessions.contains(session1))
        XCTAssertFalse(viewModel.sessions.contains(session2))
        XCTAssertFalse(viewModel.sessions.contains(session3))
    }
}

