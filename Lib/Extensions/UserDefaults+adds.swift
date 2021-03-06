//
//  UserDefaults+adds.swift
//  Task100
//
//  Created by Максим Ламанский on 14.09.2021.
//

import Foundation

enum UserDefaultsKeys: String {
    case taskList
    case menuList
}

extension UserDefaults {
    
    static var menuList: [String] {
        get {
            return (standard.array(forKey: UserDefaultsKeys.menuList.rawValue) as? [String]) ?? []
        }
        
        set(newValue) {
            standard.setValue(newValue, forKey: UserDefaultsKeys.menuList.rawValue)
        }
    }

    static var taskList: Root.TaskList {
        get {
            return self.getObject(for: UserDefaultsKeys.taskList.rawValue, castTo: Root.TaskList.self) ?? Root.TaskList.defaultList
        }
        
        set(newValue) {
            self.setObject(newValue, for: UserDefaultsKeys.taskList.rawValue)
        }
    }
    
    static func setObject<Object>(_ object: Object, for key: String) where Object: Encodable {
            let encoder = JSONEncoder()
            do {
                let data = try encoder.encode(object)
                self.standard.set(data, forKey: key)
            } catch {
                print(error)
            }
        }
        
    static func getObject<Object>(for key: String, castTo type: Object.Type) -> Object? where Object: Decodable {
        guard let data = self.standard.data(forKey: key) else { print("UD: error data get"); return nil }
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(type, from: data)
            return object
        } catch {
            print(error)
            return nil
        }
    }
    
}
