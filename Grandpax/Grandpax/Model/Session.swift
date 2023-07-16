//
//  Session.swift
//  Grandpax
//
//  Created by Alex Albu on 08.03.2023.
//

import RealmSwift

class Session: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id = UUID()
    @Persisted var name: String
    @Persisted var maxGForce: Double
    @Persisted var maxSpeed: Double
    @Persisted var mapSnapshot: String
}
