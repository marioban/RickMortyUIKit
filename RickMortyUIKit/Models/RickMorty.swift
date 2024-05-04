// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import UIKit
import Kingfisher

// MARK: - Info
struct ResultsInfo: Codable {
    let next: String?
}


// MARK: - Welcome
struct Response: Codable {
    let info: ResultsInfo
    let results: [Character]
}

// MARK: - Result
struct Character: Codable {
    var id: Int
    var name: String
    var status: String
    var species: String
    var type: String
    var gender: String
    var image: String
    var episode: [String]
    var url: String
    var created: String
}


class RickMortyApi {
    
    var character = [Character]()
    
    func getData(page: Int, completion: @escaping (Response)->()) {
        guard let url = URL(string: "https://rickandmortyapi.com/api/character?page=\(page)") else {return}
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {return}
            let characterList = try! JSONDecoder().decode(Response.self, from: data)
            DispatchQueue.main.async {
                completion(characterList)
            }
        }.resume()
    }
    
}
