//
//  ContentView.swift
//  phone
//
//  Created by Andrew Monshizadeh on 7/16/20.
//

import SwiftUI

struct ContentView: View {
  @State var selection: Int = 3

  var body: some View {
    TabView(
      selection: $selection,
      content:  {
        FavoritesView()
          .tabItem {
            Label {
              Text("Favorites")
            } icon: {
              Image(systemName: "star.fill")
            }
          }
          .tag(1)
        RecentsView()
          .tabItem {
            Label {
              Text("Recents")
            } icon: {
              Image(systemName: "clock.fill")
            }
          }
          .tag(2)
        ContactsListView()
          .tabItem {
            Label {
              Text("Contacts")
            } icon: {
              Image(systemName: "person.crop.circle")
            }
          }
          .tag(3)
        KeypadView()
          .tabItem {
            Label {
              Text("Kepyad")
            } icon: {
              Image(systemName: "circle.grid.3x3.fill")
            }
          }
          .tag(4)
        VoicemailView()
          .tabItem {
            Label {
              Text("Voicemail")
            } icon: {
              Image(systemName: "waveform.circle.fill")
            }
          }
          .tag(5)
      })
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
