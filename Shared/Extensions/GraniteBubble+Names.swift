//
//  GraniteBubble+Names.swift
//  Loom
//

import Granite

/// The names Loom's views bubble actions under, with `bubble(.name)` or `bubble(.name, value)`,
/// and route with `.onBubble { On(.name) { … } }`.
///
/// A route's key is a name plus the type sent, so one name serves several actions of
/// different types: `.edit` is Void from a header and a `LoomManifest` from a collection card.
extension GraniteBubble.Name {
    static let add: Self = "add"
    static let addKeyword: Self = "addKeyword"
    static let addProfile: Self = "addProfile"
    static let cancel: Self = "cancel"
    static let changeLocation: Self = "changeLocation"
    static let clean: Self = "clean"
    static let closeDrawer: Self = "closeDrawer"
    static let commit: Self = "commit"
    static let connect: Self = "connect"
    static let create: Self = "create"
    static let dismiss: Self = "dismiss"
    static let edit: Self = "edit"
    static let favorite: Self = "favorite"
    static let fetch: Self = "fetch"
    static let goToPost: Self = "goToPost"
    static let goToThread: Self = "goToThread"
    static let interact: Self = "interact"
    static let isFocused: Self = "isFocused"
    static let login: Self = "login"
    static let longPressThreadLine: Self = "longPressThreadLine"
    static let notLoggedIn: Self = "notLoggedIn"
    static let onSubmit: Self = "onSubmit"
    static let pickedCommunity: Self = "pickedCommunity"
    static let present: Self = "present"
    static let query: Self = "query"
    static let refresh: Self = "refresh"
    static let remove: Self = "remove"
    static let reply: Self = "reply"
    static let replyComment: Self = "replyComment"
    static let replyPost: Self = "replyPost"
    static let replyToContent: Self = "replyToContent"
    static let save: Self = "save"
    static let search: Self = "search"
    static let showComments: Self = "showComments"
    static let showContent: Self = "showContent"
    static let showDrawer: Self = "showDrawer"
    static let switchAccount: Self = "switchAccount"
    static let tapped: Self = "tapped"
    static let tappedCrumb: Self = "tappedCrumb"
    static let tappedDetail: Self = "tappedDetail"
    static let tappedHeader: Self = "tappedHeader"
    static let tappedThreadLine: Self = "tappedThreadLine"
    static let toggle: Self = "toggle"
    static let toggleVisibility: Self = "toggleVisibility"
    static let updateComment: Self = "updateComment"
    static let updatePost: Self = "updatePost"
    static let updatedPost: Self = "updatedPost"
    static let viewCommunity: Self = "viewCommunity"
    static let write: Self = "write"
}
