//
//  VoicemailView.swift
//  phone
//
//  Created by Andrew Monshizadeh on 7/19/20.
//

import SwiftUI

enum VoicemailKind {
  case voicemail(phoneNumber: String)
  case deletedMessages(messages: [VoicemailKind])
}

func randomPhoneNumber() -> String {
  let rn = {
    arc4random_uniform(10)
  }

  let rnn: (Int) -> String = { n in
    var s = ""
    for _ in 0 ..< n {
      s += "\(rn())"
    }
    return s
  }

  return "+1 (\(rnn(3))) \(rnn(3))-\(rnn(4))"
}

struct VoicemailView: View {
  @State var rows: [VoicemailKind] = {
    var a: [VoicemailKind] = (0..<25).map { _ in
      VoicemailKind.voicemail(phoneNumber: randomPhoneNumber())
    }
    a.append(.deletedMessages(messages: a))
    return a
  }()

  var body: some View {
    NavigationView {
      List {
        ForEach(Array(rows.enumerated()), id: \.0) {
          VoicemailRow(call: $0.1)
        }
        .onDelete { indexSet in
          rows.remove(atOffsets: indexSet)
        }
      }
      .navigationTitle("Voicemail")
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          Text("Greeting")
            .foregroundColor(.blue)
        }
        ToolbarItem(placement: .navigationBarTrailing) {
          EditButton()
        }
      }
    }
  }
}

struct DeletedVoicemailView: View {
  @State var calls: [VoicemailKind]
  var body: some View {
    List {
      ForEach(Array(calls.enumerated()), id: \.0) {
        VoicemailRow(call: $0.1)
      }
    }
    .navigationTitle("Deleted")
    .toolbar {
      ToolbarItem(placement: ToolbarItemPlacement.automatic) {
        Button {
        } label: {
          Text("Clear All")
        }
      }
    }
  }
}

struct VoicemailRow: View {
  let call: VoicemailKind
  @Environment(\.editMode) var editMode

  var body: some View {
    switch call {
      case .voicemail(let pn):
        HStack {
          VStack(alignment: .leading) {
            Text("\(pn)")
              .font(.headline)
            Text("Washington, DC")
              .font(.footnote)
              .foregroundColor(.gray)
          }
          Spacer()
          VStack(alignment: .trailing) {
            Text("5/20/20")
              .font(.footnote)
            Text("01:04")
              .font(.footnote)
              .foregroundColor(.gray)
          }
          if case .inactive = editMode?.wrappedValue {
            Image(systemName: "info.circle")
              .foregroundColor(.blue)
          }
        }
      case .deletedMessages(let calls):
        NavigationLink(
          destination: DeletedVoicemailView(calls: calls),
          label: {
            Text("Deleted Messages")
          })
    }
  }
}

struct VoicemailView_Previews: PreviewProvider {
  static var previews: some View {
    VoicemailView()
  }
}
