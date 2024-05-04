//
//  RealmWrapper.swift
//  RickMortyUIKit
//
//  Created by Mario Ban on 31.01.2023..
//

import UIKit
import RealmSwift

class RealmWrapper {
    
    static var realm: Realm {
        get{
            do{
                return try Realm()
            } catch{
                print(error)
            }
            return self.realm
        }
    }
    
    func saveObjects<T: Object>(objects: T) {
         do{
             try RealmWrapper.realm.write{
                 RealmWrapper.realm.add(objects)
             }
         } catch{
             debugPrint(error)
         }
     }
    
    func getObjects<T: Object>(objects: T.Type) -> Results<T>? {
        return RealmWrapper.realm.objects(objects)
    }

    func deleteObjects<T: Object>(objects: T) {
        do{
            try RealmWrapper.realm.write{
                RealmWrapper.realm.delete(objects)
            }
        } catch{
            debugPrint(error)
        }
    }
    
    func doesExist(name: String) -> Bool {
        let characters = RealmWrapper.realm.objects(SavedCharacter.self)
        
        let query = characters.where {
            $0.name == name
        }
        
        return query.count != 0
    }
    
    func deleteChracter(withName name: String) {
        let characters = RealmWrapper.realm.objects(SavedCharacter.self)

        try! RealmWrapper.realm.write {
            let query = characters.where {
                $0.name == name
            }
            
            RealmWrapper.realm.delete(query)
        }
    }
}
