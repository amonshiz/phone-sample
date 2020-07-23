//
//  RecentsView.swift
//  phone
//
//  Created by Andrew Monshizadeh on 7/16/20.
//

import SwiftUI

struct RecentModel {
  let caller: String
  let location: String
  let time: String
  var outbound: Bool = false
}

extension RecentModel: Identifiable {
  var id: String { caller + location + time }
}

let calls = [
  RecentModel(caller: "+1 (999) 999-9999", location: "New York, NY", time: "12:02"),
  RecentModel(caller: "(319) 555-5555", location: "Waterloo, IA", time: "10:56", outbound: true),
  RecentModel(caller: "(855) 555-555", location: "unknown", time: "10:56", outbound: true),
  RecentModel(caller: "+1 (785) 555-5555", location: "Russel Springs, KS", time: "Yesterday"),
]

struct RecentsView: View {
  @State var selectedType: String = "All"
  var body: some View {
    NavigationView {
      List {
//        Text("List-Recents")
//          .multilineTextAlignment(.leading)
//          .font(Font.largeTitle.bold())
        ForEach(calls) { call in
          RecentRow(call: call)
        }
      }
      .navigationTitle("Recents")
      .navigationBarTitleDisplayMode(.large)
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          Picker(selection: $selectedType, label: EmptyView()) {
            Text("All").tag("All")
            Text("Missed").tag("Missed")
          }
          .pickerStyle(SegmentedPickerStyle())
        }
        ToolbarItem {
          EditButton()
        }
      }
    }
  }
}

struct RecentRow: View {
  private struct OutboundModifier: ViewModifier {
    let isOutbound: Bool

    @ViewBuilder func body(content: Content) -> some View {
      if isOutbound {
        content
          .labelStyle(DefaultLabelStyle())
      } else {
        content
          .labelStyle(TitleOnlyLabelStyle())
      }
    }
  }

  let call: RecentModel

  var body: some View {
    Button {
    } label: {
      HStack(alignment: .center) {
        HStack(alignment: .top) {
          Image(systemName: "phone.fill.arrow.up.right")
            .opacity(call.outbound ? 1.0 : 0.0)
          VStack(alignment: .leading) {
            Text(call.caller)
              .foregroundColor(.black)
            Text(call.location)
              .font(.footnote)
          }
        }
        Spacer()
        Text(call.time)
          .font(.footnote)

        Button {
        } label: {
          Image(systemName: "info.circle")
            .foregroundColor(.blue)
        }
      }
    }
    .foregroundColor(.gray)
  }
}

struct RecentsView_Previews: PreviewProvider {
  static var previews: some View {
    RecentsView()
  }
}
