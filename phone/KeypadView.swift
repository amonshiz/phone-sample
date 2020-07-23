//
//  KeypadView.swift
//  phone
//
//  Created by Andrew Monshizadeh on 7/16/20.
//

import SwiftUI

struct KeypadView: View {
  @State var phoneNumber: String = ""

  let keys: [(String, String)] = { [
    ("1", ""),
    ("2", "A B C"),
    ("3", "D E F"),
    ("4", "G H I"),
    ("5", "J K L"),
    ("6", "M N O"),
    ("7", "P Q R S"),
    ("8", "T U V"),
    ("9", "W X Y Z"),
    ("*", ""),
    ("0", "+"),
    ("#", ""),
  ] }()

  var body: some View {
    VStack {
      Spacer()
      TextField(" ", text: $phoneNumber)
        .padding()
        .font(.largeTitle)
        .textContentType(.telephoneNumber)
        .multilineTextAlignment(.center)
        .allowsHitTesting(false)

      Text("Add Number")
        .foregroundColor(.blue)
        .modifier(AnimatedHiding(phoneNumber.isEmpty))

      Spacer()
      Keypad(keys: keys, phoneNumber: $phoneNumber)
    }
    .accentColor(.black)
    .padding([.bottom])
  }
}

struct Keypad: View {
  private let gridItems = [
    GridItem(.flexible(minimum: 75, maximum: 200)),
    GridItem(.flexible(minimum: 75, maximum: 200)),
    GridItem(.flexible(minimum: 75, maximum: 200)),
  ]

  let keys: [(String, String)]
  @Binding var phoneNumber: String

  var body: some View {
    LazyVGrid(columns: gridItems, alignment: .center, spacing: 5) {
      ForEach(keys, id: \.0) { (primary, sub) in
        KeyButton(primaryText: primary, secondaryText: sub, numberText: $phoneNumber)
          .modifier(KeyboardButtonModifier(color: Color(UIColor.systemFill)))
      }
    }
    .padding(10)

    LazyVGrid(columns: gridItems) {
      ForEach(0 ..< 3) { index in
        if index == 0 {
          Text("")
        } else if index == 1 {
          Button {
          } label: {
            Image(systemName: "phone.fill")
              .interpolation(.high)
              .imageScale(.large)
              .scaleEffect(1.5)
          }
          .padding()
          .modifier(KeyboardButtonModifier(color: Color(UIColor.systemGreen)))
          .accentColor(.white)
        } else {
          Button {
            phoneNumber = String(phoneNumber.dropLast())
          } label: {
            Image(systemName: "delete.left")
              .imageScale(.large)
          }
          .modifier(AnimatedHiding(phoneNumber.isEmpty))
        }
      }
    }
  }
}

struct AnimatedHiding: ViewModifier {
  let opacity: Double
  let duration: Double
  let delay: Double
  let animation: (Double) -> Animation

  init(_ shouldHide: Bool = false) {
    if shouldHide {
      opacity = 0
      duration = 0.5
      delay = 0.5
      animation = Animation.easeInOut(duration:)
    } else {
      opacity = 1
      duration = 0.1
      delay = 0
      animation = Animation.linear(duration:)
    }
  }

  func body(content: Content) -> some View {
    content
      .opacity(opacity)
      .animation(animation(duration).delay(delay))
  }
}

struct KeyButton: View {
  let primaryText: String
  let secondaryText: String
  @Binding var numberText: String

  var body: some View {
    Button {
      numberText = numberText.trimmingCharacters(in: .whitespacesAndNewlines).appending(primaryText)
    } label: {
      VStack {
        if secondaryText.isEmpty && primaryText == "*" {
          Spacer()
        }

        Text(primaryText)
          .font(Font.largeTitle.weight(.semibold))

        if !secondaryText.isEmpty {
          Text(secondaryText)
            .font(Font.footnote.smallCaps().weight(.semibold))
            .kerning(-1)
            .padding([.top], -5)
        }
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}

struct KeyboardButtonModifier: ViewModifier {
  let color: Color
  func body(content: Content) -> some View {
    content
      .padding(14)
      .background(
        Circle()
          .fill()
          .foregroundColor(color)
      )
  }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        KeypadView()
    }
}
