//
//  BiometricsManager.swift
//  Grandpax
//
//  Created by Alex Albu on 04.04.2023.
//

import LocalAuthentication

typealias BiometricsCompletion = (Bool, Error?) -> Void

final class BiometricsManager {

    static func faceIDSecurity(completion: @escaping BiometricsCompletion) {
        let localAuthContext = LAContext()
        var localAuthError: NSError?
        let policy = LAPolicy.deviceOwnerAuthenticationWithBiometrics
        
        if localAuthContext.canEvaluatePolicy(policy, error: &localAuthError) {
            
            let reason = "Authenticate with Face ID"
            localAuthContext.evaluatePolicy(policy, localizedReason: reason) { success, error in
                
                DispatchQueue.main.async {
                    if success {
                        completion(true, nil)
                    } else {
                        completion(false, error)
                    }
                }
            }
            
        } else {
            completion(false, localAuthError)
        }
    }
}
