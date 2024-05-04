//
//  CharacterRealm.swift
//  RickMortyUIKit
//
//  Created by Mario Ban on 31.01.2023..
//

import Foundation
import RealmSwift
import Realm

class SavedCharacter: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String
    @Persisted var status: String
    @Persisted var species: String
    @Persisted var type: String
    @Persisted var gender: String
    @Persisted var image: String
    @Persisted var url: String
    @Persisted var created: String
    
    convenience init(character: Character) {
        self.init()
        self.name = character.name
        self.status = character.status
        self.species = character.species
        self.type = character.type
        self.gender = character.gender
        self.image = character.image
        self.url = character.url
        self.created = character.created
    }
    convenience init(savedCharacter: SavedCharacter) {
        self.init()
        self.name = savedCharacter.name
        self.status = savedCharacter.status
        self.species = savedCharacter.species
        self.type = savedCharacter.type
        self.gender = savedCharacter.gender
        self.image = savedCharacter.image
        self.url = savedCharacter.url
        self.created = savedCharacter.created
    }
}
