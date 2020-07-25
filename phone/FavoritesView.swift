//
//  FavoritesView.swift
//  phone
//
//  Created by Andrew Monshizadeh on 7/24/20.
//

import SwiftUI

enum FavoriteKind: CaseIterable {
  case mobile
  case messages
  case facetime
}

extension FavoriteKind {
  var icon: Image {
    switch self {
    case .mobile:
      return Image(systemName: "phone.fill")
    case .messages:
      return Image(systemName: "message.fill")
    case .facetime:
      return Image(systemName: "video.fill")
    }
  }

  var name: String {
    switch self {
    case .mobile:
      return "mobile"
    case .messages:
      return "Messages"
    case .facetime:
      return "Facetime"
    }
  }
}

var favoriteRows = favorites.map { f -> (Favorite, FavoriteKind) in
  (f, FavoriteKind.allCases.randomElement() ?? .mobile)
}

struct FavoritesView: View {
  var body: some View {
    NavigationView {
      List {
        ForEach(favoriteRows, id: \.0) { (f, k) in
          FavoriteRow(favorite: f, kind: k)
        }
        .onDelete { indexSet in
          favoriteRows.remove(atOffsets: indexSet)
        }
        .onMove { indices, newOffset in
          favoriteRows.move(fromOffsets: indices, toOffset: newOffset)
        }
      }
      .navigationTitle("Favorites")
      .toolbar(items: {
        ToolbarItem(placement: .navigationBarLeading) {
          Button {

          } label: {
            Image(systemName: "plus")
          }
        }
        ToolbarItem {
          EditButton()
        }
      })
    }
  }
}

struct FavoriteRow: View {
  let favorite: Favorite
  let kind: FavoriteKind
  @Environment(\.editMode) var editMode

  var body: some View {
    HStack(alignment: .center) {
      Text("\(String(favorite.first.first!))\(String(favorite.last.first!))")
        .font(.body)
        .foregroundColor(.white)
        .padding(12)
        .background(
          Circle()
            .fill()
            .foregroundColor(.gray)
        )

      VStack {
        HStack {
          VStack(alignment: .leading) {
            (Text(favorite.first) + Text(" ") + Text(favorite.last))
              .padding([.top], 2)
              .font(.headline)
            HStack {
              kind.icon
                .imageScale(.small)
                .padding([.trailing], -2)
                .foregroundColor(Color(UIColor.systemGray3))
              Text(kind.name)
                .font(.subheadline)
                .foregroundColor(Color(UIColor.systemGray))
            }
            .padding([.bottom], -4)
          }

          Spacer()

          if let em = editMode, !em.wrappedValue.isEditing {
            Button {
            } label: {
              Image(systemName: "info.circle")
                .foregroundColor(.blue)
            }
          }
        }
      }

      Spacer()
    }
  }
}

struct FavoritesView_Previews: PreviewProvider {
  static var previews: some View {
    FavoritesView()
      .preferredColorScheme(.dark)
    FavoritesView()
  }
}
