//
//  FavoritesModels.swift
//  phone
//
//  Created by Andrew Monshizadeh on 7/24/20.
//

import Foundation

struct FavoritesList: Decodable {
  let results: [Favorite]
}

struct Favorite: Decodable {
  let title: String
  let first: String
  let last: String

  enum OutterKeys: String, CodingKey {
    case name
  }

  enum InnerKeys: String, CodingKey {
    case title
    case first
    case last
  }

  init(title: String?, first: String, last: String) {
    self.title = title ?? ""
    self.first = first
    self.last = last
  }

  init(from decoder: Decoder) throws {
    let outterContainer = try decoder.container(keyedBy: OutterKeys.self)

    let nameContainer = try outterContainer.nestedContainer(keyedBy: InnerKeys.self, forKey: OutterKeys.name)
    self.init(
      title: try nameContainer.decode(String.self, forKey: InnerKeys.title),
      first: try nameContainer.decode(String.self, forKey: InnerKeys.first),
      last: try nameContainer.decode(String.self, forKey: InnerKeys.last))
  }
}

extension Favorite: Identifiable {
  var id: String { first + " " + last }
}
extension Favorite: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}

let favorites: [Favorite] = {
  guard let url = Bundle.main.url(forResource: "contacts", withExtension: "json") else { return [] }

  do {
    let data = try Data(contentsOf: url)
    let list = try JSONDecoder().decode(FavoritesList.self, from: data)
    return list.results
  } catch {
    return []
  }
}()
