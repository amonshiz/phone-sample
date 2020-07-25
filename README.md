# Phone-Sample

## Objective
To gain experience building interfaces using [SwiftUI](https://developer.apple.com/xcode/swiftui/) by rebuilding a well known interface in iOS. There are others doing something similar with various other interfaces but I wanted to try something a little more varied.

## Approach
I essentially just took screenshots of each view and then attempted to recreate it to a reasonable fidelity. This process was definitely a learning experience and one that let me uncover a few rough edges.

## Issues
You can follow along in my repo [feedback-examples](https://github.com/amonshiz/feedback-examples) for all the Feedback that I eventually file, but the following are ones filed directly because of this project:
- [listview-scrollviewreader](https://github.com/amonshiz/feedback-examples#listview-scrollviewreader): `List` within a `ScrollViewReader` does not scroll when `scrollTo(_, anchor:)` is used
- [recents-tab-sample](https://github.com/amonshiz/feedback-examples#recents-tab-sample): The navigation bar does not allow both a toolbar item in the `.principal` position *and* a title for the view
- [navigationtitle-large](https://github.com/amonshiz/feedback-examples#navigationtitle-largeu): When using the `.automatic/.large` options for `navigationBarTitleDisplayMode` and displaying a `ScrollView` as the "root" view, the title will immediately jump into the navigation bar on any scroll thus disrupting the flow/offset that the user would expect. `List` does not suffer from this issue.
- [listview-editmode-move](https://github.com/amonshiz/feedback-examples#listview-editmode-move):The move/reorder control on `List` rows changes the divider's trailing inset when this is not what happens with a normal `UITableView`
- No obvious way to set the toolbar/tab bar background for a given view, so the `Keypad` is unable to make the background white and thus "hide" the tab bar.
- No clear way to prevent a `TextField` from displaying a keyboard

## References
- [Random User Generator](https://randomuser.me) for sample users in the [FavoritesView](./phone/FavoritesView.swift)
- SF Symbols Beta 2 for the various icons
