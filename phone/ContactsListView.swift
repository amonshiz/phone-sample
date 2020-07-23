//
//  ContactsListView.swift
//  phone
//
//  Created by Andrew Monshizadeh on 7/20/20.
//

import SwiftUI
import Contacts

class ContactFetcher: ObservableObject {
  struct ContactSection: Hashable {
    let firstLetter: String
    let contacts: [CNContact]
  }

  let contactStore: CNContactStore
  @Published var contactSections: [ContactSection]

  init() {
    self.contactStore = CNContactStore()
    var c: [ContactSection] = []
    var lastSection: ContactSection? = nil
    do {
      let keys = [CNContactGivenNameKey, CNContactFamilyNameKey] as [CNKeyDescriptor]
      let fetchRequest = CNContactFetchRequest(keysToFetch: keys)
      fetchRequest.sortOrder = .familyName
      try contactStore.enumerateContacts(with: fetchRequest, usingBlock: { (contact, stop) in
        if let firstCharacter = contact.familyName.first {
          var cs = [contact]
          let fl = String(firstCharacter)
          if let ls = lastSection {
            if ls.firstLetter == fl {
              cs = ls.contacts + cs
            } else {
              c.append(ls)
            }
          }

          lastSection = ContactSection(firstLetter: fl, contacts: cs)
        }
      })
    } catch {
      print("\(error)")
    }

    if lastSection != nil {
      c.append(lastSection!)
    }

    self.contactSections = c
  }
}

struct ContactsListView: View {
  @State var searchText: String = ""
  @ObservedObject var contactFetcher = ContactFetcher()

  @State var selectedIndex: String?

  private func sectionHeader(_ firstLetter: String) -> some View {
    let text = (firstLetter == (selectedIndex ?? "") ? "*" : "") + "\(firstLetter)"
    return
      HStack {
        Text(text)
          .padding([.leading])
        Spacer()
      }
      .id(firstLetter)
      .background(
        Color(UIColor.systemGroupedBackground)
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      )
  }

  var body: some View {
    NavigationView {
      ScrollView {
        ScrollViewReader { scrollViewProxy in
          TextField("Search", text: $searchText)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .frame(maxWidth: .infinity)

          MyRowView()

          ForEach(contactFetcher.contactSections, id: \.firstLetter) { s in
            Section(
              header: sectionHeader(s.firstLetter)) {
              ForEach(Array(s.contacts.enumerated()), id: \.1.self) { (i, c) in
                ContactRowView(contact: c)
                  .modifier(DividerModifier(isLast: (i == (s.contacts.count - 1))))
                  .padding([.leading])
              }
            }
          }
          .onChange(of: selectedIndex) { index in
            guard let index = index else { return }
            scrollViewProxy.scrollTo(index, anchor: .top)
          }
        }
      }
      .listStyle(PlainListStyle())
      .overlay(
        ListSectionIndex(
          sectionIndices: contactFetcher.contactSections.map {
            $0.firstLetter
          }) { index in
          selectedIndex = index
        }
      )
      .navigationTitle("Contacts")
      .toolbar {
        Button {
        } label: {
          Image(systemName: "plus")
        }
      }
    }
  }
}

struct DividerModifier: ViewModifier {
  let isLast: Bool

  func body(content: Content) -> some View {
    content
      .background(
        VStack {
          if isLast {
            EmptyView()
          } else {
            Spacer()
            Divider()
          }
        }
      )
  }
}

struct ContactRowView: View {
  let contact: CNContact

  var body: some View {
    HStack(spacing: 0) {
      (Text("\(contact.givenName)")
        + Text(" ")
        + Text("\(contact.familyName)")
        .fontWeight(.bold)
      )
      Spacer()
    }
    .padding([.top, .bottom])
  }
}

struct MyRowView: View {
  var body: some View {
    HStack {
      Image(uiImage: UIImage(imageLiteralResourceName: "3C8B4DBE-9390-4685-B3D1-1D818F749C16_1_105_c.jpeg"))
        .frame(width: 60, height: 60)
        .scaledToFit()
        .clipShape(Circle())
      VStack(alignment: .leading) {
        Text("Andrew Monshizadeh")
          .font(.title3)
        Text("My Card")
          .font(.subheadline)
          .foregroundColor(.gray)
      }
    }
    .padding([.top, .bottom], 5)
  }
}

struct ContactsListView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      ContactsListView()
    }
  }
}
