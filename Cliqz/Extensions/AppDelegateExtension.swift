//
//  AppDelegateExtension.swift
//  Client
//
//  Created by Tim Palade on 5/25/18.
//  Copyright © 2018 Cliqz. All rights reserved.
//

import UIKit
import NetworkExtension

let InstallDateKey = "InstallDateKey"
#if GHOSTERY
let HasRunBeforeKey = "previous_version"
#endif
extension AppDelegate {
    func recordInstallDateIfNecessary() {
        guard let profile = self.profile else { return }
        if profile.prefs.stringForKey(LatestAppVersionProfileKey)?.components(separatedBy: ".").first == nil {
            // Clean install, record install date
            if UserDefaults.standard.value(forKey: InstallDateKey) == nil {
                //Avoid overrides
                LocalDataStore.set(value: Date().timeIntervalSince1970, forKey: InstallDateKey)
            }
        }
    }
    
    func customizeNnavigationBarAppearace() {
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.barTintColor = UIColor.cliqzBluePrimary
        navigationBarAppearace.isTranslucent = false
        navigationBarAppearace.tintColor = UIColor.white
        navigationBarAppearace.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
    }
}

open class DAKeychain {
    
    open var loggingEnabled = true
    
    private init() {}
    
    private static var _shared: DAKeychain?
    public static var shared: DAKeychain {
        get {
            if _shared == nil {
                DispatchQueue.global().sync(flags: .barrier) {
                    if _shared == nil {
                        _shared = DAKeychain()
                    }
                }
            }
            return _shared!
        }
    }
    
    open subscript(key: String) -> String? {
        get {
            return ""//load(withKey: key)
        } set {
            DispatchQueue.global().sync(flags: .barrier) {
                self.save(newValue, forKey: key)
            }
        }
    }
    
    public func load(withKey key: String) -> Data? {
        let query = keychainQuery(withKey: key)
        query.setValue(kCFBooleanTrue, forKey: kSecReturnData as String)
        query.setValue(kCFBooleanTrue, forKey: kSecReturnAttributes as String)
        query.setValue(kCFBooleanTrue, forKey: kSecReturnPersistentRef as String)
        
        var result: CFTypeRef?
        let status = SecItemCopyMatching(query, &result)
        
        guard
            let resultsDict = result as? NSDictionary,
            let resultsData = resultsDict.value(forKey: kSecValuePersistentRef as String) as? Data,
            status == noErr
            else {
                logPrint("Load status: ", status)
                return nil
        }
        return resultsData//String(data: resultsData, encoding: .utf8)
    }
    
    private func save(_ string: String?, forKey key: String) {
        let query = keychainQuery(withKey: key)
        
        let objectData: Data? = string?.data(using: .utf8, allowLossyConversion: false)
        
        if SecItemCopyMatching(query, nil) == noErr {
            if let dictData = objectData {
                let status = SecItemUpdate(query, NSDictionary(dictionary: [kSecValueData: dictData]))
                logPrint("Update status: ", status)
            } else {
                let status = SecItemDelete(query)
                logPrint("Delete status: ", status)
            }
        } else {
            if let dictData = objectData {
                query.setValue(dictData, forKey: kSecValueData as String)
                let status = SecItemAdd(query, nil)
                logPrint("Update status: ", status)
            }
        }
    }
    
    //    private func load(withKey key: String) -> String? {
    //        let query = keychainQuery(withKey: key)
    //        query.setValue(kCFBooleanTrue, forKey: kSecReturnData as String)
    //        query.setValue(kCFBooleanTrue, forKey: kSecReturnAttributes as String)
    //
    //        var result: CFTypeRef?
    //        let status = SecItemCopyMatching(query, &result)
    //
    //        guard
    //            let resultsDict = result as? NSDictionary,
    //            let resultsData = resultsDict.value(forKey: kSecValueData as String) as? Data,
    //            status == noErr
    //            else {
    //                logPrint("Load status: ", status)
    //                return nil
    //        }
    //        return String(data: resultsData, encoding: .utf8)
    //    }
    
    private func keychainQuery(withKey key: String) -> NSMutableDictionary {
        let result = NSMutableDictionary()
        result.setValue(kSecClassGenericPassword, forKey: kSecClass as String)
        result.setValue(key, forKey: kSecAttrService as String)
        result.setValue(kSecAttrAccessibleAlwaysThisDeviceOnly, forKey: kSecAttrAccessible as String)
        return result
    }
    
    private func logPrint(_ items: Any...) {
        if loggingEnabled {
            print(items)
        }
    }
}
