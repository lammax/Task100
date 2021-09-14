//
//  UserDefaults+adds.swift
//  Task100
//
//  Created by Максим Ламанский on 14.09.2021.
//

import Foundation

enum UserDefaultsKeys: String {
    case taskList
}

extension UserDefaults {
    static var taskList: [Main.Task] {
        get {
            return (self.standard.object(forKey: UserDefaultsKeys.taskList.rawValue) as? [Main.Task]) ?? []
        }
        
        set(newValue) {
            self.standard.set(newValue, forKey: UserDefaultsKeys.taskList.rawValue)
        }
    }
    
    static func setObject<Object>(_ object: Object) where Object: Encodable {
            let encoder = JSONEncoder()
            do {
                let data = try encoder.encode(object)
                self.standard.set(data, forKey: UserDefaultsKeys.taskList.rawValue)
            } catch {
                print(error)
            }
        }
        
    static func getObject<Object>(castTo type: Object.Type) -> Object? where Object: Decodable {
        guard let data = self.standard.data(forKey: UserDefaultsKeys.taskList.rawValue) else { print("UD: error data get"); return nil }
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
