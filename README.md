<p align="center"><img src="Resources/README/logo.png" height="120px" /></p>

<h1 align="center">Loom (iOS & macOS)</h1>

> [!IMPORTANT]
> **This repository is a reference.** Loom is a social app architecture I built from scratch, and a pre-AI reference for design patterns in modern iOS applications built with [Granite](https://github.com/riteshpakala/Granite). The skill files (`SKILL.md`) in my projects point here when building applications; the layout itself is written up as a skill in [`Skills/loom-app-architecture`](Skills/loom-app-architecture/SKILL.md).
>
> It is kept self-contained so it builds on its own, always: every package it depends on is vendored in [`Packages/`](Packages), except Granite and a few public libraries, which are pinned to exact revisions.

<p align="center"><img src="Resources/README/loom-bloom.svg" width="100%" alt="A concentrated beam, Loom and Granite built solo, enters a reactor labelled Apple, Inc. and blooms into a spectrum: AI safety, social app safety, iOS architecture, on-device ML, core research, Rao Studios and 2026 Year in Review." /></p>

> [!NOTE]
> **The beam before the bloom.** Building Loom and Granite solo, design included, was the experience that focused my interests in iOS architecture, AI safety and social app safety, and sharpened CoreML, on-device ML, app architecture, iOS application performance, engineering, design and project management. Joining Apple, Inc. was the reactor: it exploded into [2026 Year in Review](https://riteshpakala.github.io/French-Visa-Application/), [Rao Studios](https://rao.nyc) and my [core research](https://paka.la/blog#core-research).

<p align="center"><img src="Resources/README/header.gif" width="90%" /></p>

<p align="center">Aggregating aggregation. Providing everyone with a premium experience when interacting with federated servers. Meanwhile, providing view libraries and solutions for others to implement their own interpretations in the Apple ecosystem.</p>

## WARNING

- If Loom requests for "Local Network Access" it is because a neighboring server is using a localhost equivalent address. It is not because of the application itself. So please DO NOT ALLOW ACCESS. (unless you are expecting it).

## Requirements
![Swift Compatibility](https://img.shields.io/badge/Swift-6.4%20toolchain%20(Swift%205%20mode)-orange?logo=swift)
![Platform Compatibility](https://img.shields.io/badge/Platform-iOS%2027%20%7C%20macOS%2027-blue)
[![License](https://img.shields.io/badge/License-MIT--Clause-orange.svg)](https://opensource.org/license/mit/)

> Last verified: Xcode 27.1 // macOS 27 // iOS 27 Simulator (2026-10-28)

## Building

Open `Loom.xcodeproj` and run the `Loom (iOS)` or `Loom (macOS)` scheme. No accounts, tokens or private repositories are needed.

- **Vendored** in [`Packages/`](Packages): FederationKit, LemmyKit, MastodonKit, FeedKit, ModerationKit, IPFSKit, MarkdownView. Each keeps its own `LICENSE`.
- **Remote, pinned** to exact revisions: [Granite](https://github.com/riteshpakala/Granite), [Nuke](https://github.com/kean/Nuke), [KeyboardToolbar](https://github.com/pexavc/KeyboardToolbar), and MarkdownView's [swift-markdown](https://github.com/apple/swift-markdown) and [Highlightr](https://github.com/raspu/Highlightr) (see `Package.resolved`).

## Disclaimers
- Due to the nature of possible state schemas being changed. Saved data such as account information or bookmarks may be removed in future release versions (or not at all).
- Keychain access warning. Keychain is only used for STORING your passwords and nothing else.

## Features
- Translated into 28 languages (MTL)
- Bookmarks are locally stored for offline viewing
- IPFS Content generation (Add your own config, gateway, etc)
- Login, Create Posts, Comments, Interact, update profiles as normal

| Expanded Layout (iPad/macOS)   | |
| :-------- | -------: |
| ![Image](Resources/README/1.gif) | [Granite](https://github.com/riteshpakala/Granite) supports macOS. Same navigation API can direct window spawning or navigation stack pushing. |
| ![Image](Resources/README/2.png) | Spawn multiple windows of entire feed layouts with multiple communities to observe. Will be helpful in the case of moderating multiple communities for instance. |

| Looms    | |
| :-------- | -------: |
| ![Image](Resources/README/3.gif) | Create "Looms" of any group of communities from any instance. Merging their content into a singular feed.|

| Explore    | |
| :-------- | -------: |
| ![Image](Resources/README/4.gif)  | Visit linked instances when connected to a lemmy server. View small snippets of each and their ping response time.   |

| Aggregation Sources (Aside from Lemmy)    | |
| :-------- | -------: |
| ![Image](Resources/README/5.gif)  | RSS feeds can be pulled when setting the instance URL to a valid endpoint. Pagination is not currently supported, but will be in the future. Looking at supporting Atom/JSON streams as well.   |
| ![Image](Resources/README/6.gif)  | Mastodon feeds can be pulled when setting the instance URL to a valid mastodon instance. Pagination is not currently supported, but will be in the future. Interactions are disabled for the time being `2023-9-4`.   |

| Safety    | |
| :-------- | -------: |
| ![Image](Resources/README/7.gif)  | On-device CoreML models + keyword filtering to remove posts from the feed. `NSFW Shield` will remove posts that are detected as NSFW even if they are not flagged as so. Based on: [NSFWDetector](https://github.com/lovoo/NSFWDetector), [open_nsfw](https://github.com/yahoo/open_nsfw)     |

| Styling    | |
| :-------- | -------: |
| ![Image](Resources/README/8.gif)  |  Intended to allow full user customization in the future. Currently supports a "social app feel" and a "reddit-like reader".   |

| MD helper  | |
| :-------- | -------: |
| ![Image](Resources/README/9.gif) | Keyboard toolbar provides easy to access shortcuts on iPhone/iPad to help with Markdown formatting. |

| Travelling Modals    | |
| :-------- | -------: |
| ![Image](Resources/README/10.gif)  | Writing modals can travel with your viewing context. Allowing you to browse content in any stack prior to publishing.   |

| Bookmark Syncing    | |
| :-------- | -------: |
| ![Image]()  | All your saved posts and comments can be switched between accounts in a dedicated component.   |

| Sharing    | |
| :-------- | -------: |
| ![Image](Resources/README/11.gif) | Share posts or comments as images. With the intention of supporting QR codes and *Engravings* in the future. |

| Search    | |
| :-------- | -------: |
| ![Image](Resources/README/12.gif) | Either search all, a specific subcategory with sort support. View expanded contents within the view, interacting with content as normal. |

| Profile    | |
| :-------- | -------: |
| ![Image](Resources/README/13.gif) | Dynamic threads, despite viewing context. Swipe to reply to comments or tap the more button, to modify, remove, block, etc.  |
| ![Image](Resources/README/14.gif) | Deleting and restoring with toast reactions. |
| ![Image](Resources/README/15.gif) | Switch accounts, view their profiles, and their scores. |

| Embedded Webview    | |
| :-------- | -------: |
| ![Image](Resources/README/16.gif) | Custom JS insertion supported, customizing how webpages are viewed via direct user input is a possibility. |

| Light Mode    | |
| :-------- | -------: |
| ![Image](Resources/README/17.gif) | Light mode and Dark mode supported. Refer to the color group in `Assets` to define your own preferences for each. |




## Contributing

Loom uses [Granite](https://github.com/riteshpakala/Granite) as a backing for components and services. The Components folder in this repo serves as a good example for many future components that may be needed. Any suggestions on Granite or other component layouts as a whole is greatly appreciated. Always feel free to open a PR and/or Issue.

An interactive websites to generate boilerplate components using a GUI to define styling and needed state properties is in the works! This will allow you to simply download the generated component and drag into XCode for immediate use.

### Why Granite?

Mostly because of *Relays* and project organization. I'd say testing too, but once I get around towards writing the unit tests, I'd feel more confident in sharing the strengths then. These work like @Observables/@AppStorage, but are more flexible in initializations and caching data. The ability to simply declare relays in any `View` or `GraniteComponent` allows for a more effective iterative process and cleaner context passing throughout the application.

```swift
@Relay var configService: ConfigService
```

## Swift Packages

- [Granite](https://github.com/riteshpakala/Granite)
- FederationKit, LemmyKit, MastodonKit (vendored in `Packages/`)
- [FeedKit](https://github.com/nmdias/FeedKit) Thanks to [@nmdias](https://github.com/nmdias) (vendored)
- ModerationKit (vendored, GPL-3.0; NSFW model based on [open_nsfw](https://github.com/yahoo/open_nsfw))
- [IPFSKit](https://github.com/pexavc/ipfskit) (vendored)
- [MarkdownView](https://github.com/LiYanan2004/MarkdownView) Thanks to [@LiYanan2004](https://github.com/LiYanan2004) (vendored, patched for the iOS 27 SDK)
- [NukeUI](https://github.com/kean/nuke) Thanks to [@kean](https://github.com/kean)
- [KeyboardToolbar](https://github.com/simonbs/KeyboardToolbar) Thanks to [@simonbs](https://github.com/simonbs)
- MarbleKit is no longer available; its YouTube shader player lives on as a local stand-in in `Shared/Marble/Marble.swift`.

### Contact

- [Twitter @pexavc](https://twitter.com/pexavc)
