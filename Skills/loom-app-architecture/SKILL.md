---
name: loom-app-architecture
description: Opt-in only. Use this skill only when the user's message contains the phrase "designed like loom" (any casing, e.g. "make this app designed like loom", "add a settings page, designed like loom"). It then imposes the strict Loom project layout for Granite apps, with Components/, Services/ and Shared/ at the root; Shared/ holding App.swift, AppDelegate.swift and the Views/Extensions/Design/Utility libraries; NameService folders with NameService+Center files and Reducers/NameService.Verb.swift; components named without a suffix, split into Name, Name+Center and Name+View files. Without that exact phrase, do not use this skill, even for new Granite apps, folder layout questions or adding screens.
---

# Loom app architecture

> Opt-in: this skill applies only when the user says "designed like loom". Without that phrase, organize code however the request and the existing project suggest.

Loom is my reference implementation of a social app on Granite, built by hand before AI tooling. Its folder organization is the contract every new app starts from: a reader who knows one of my apps can open any other and find a service, a page, a shared view or an extension by name alone, without searching. That only works if the layout is followed exactly, so treat the rules below as fixed, not as suggestions.

- Reference repo: `~/Documents/repositories/Loom` (github.com/riteshpakala/Loom). When a rule here is unclear, look at how Loom does it, then apply the naming below (Loom predates two renames: `LAViews` → `Views`, `LAExtensions` → `Extensions`).
- **This skill owns where files go and what they are called. The `granite` skill owns how services, reducers, relays and boot behave.** Load both when writing Granite code. For a Swift package or kit (`Sources/<Kit>/`), the granite skill's `references/layout.md` applies instead; this skill is for the app project.

## The layout

```
<App>/
├── <App>.xcodeproj
├── Components/                     one folder per GraniteComponent (a page or a stateful section)
│   └── <Name>/
│       ├── <Name>.swift            struct <Name>: GraniteComponent  (@Command, @Relay, init)
│       ├── <Name>+Center.swift     Center, State, computed helpers over state
│       ├── <Name>+View.swift       extension <Name>: View { var view }
│       ├── <Name>+Listeners.swift  (optional) Granite listeners
│       ├── <Name>+Actions.swift    (optional) the few transitions with logic; Actions/ when there are many
│       ├── Actions/<Name>.<Verb>.swift
│       ├── Reducers/<Name>.<Verb>.swift
│       ├── Views/<Name>.<Role>View.swift     subviews only this component uses
│       └── Models/                 types only this component uses
├── Services/                       one folder per GraniteService
│   └── <Name>Service/
│       ├── <Name>Service.swift         struct <Name>Service: GraniteService (+ its helpers and ticketed entries)
│       ├── <Name>Service+Center.swift  Center, State, @Event list, @Store
│       ├── <Name>Service+<Topic>.swift (optional) more of the service's API, e.g. ModalService+Actions.swift
│       ├── Reducers/<Name>Service.<Verb>.swift
│       ├── Ops/<Name>Ops.swift     (optional) pure state transitions, per the granite skill
│       ├── Models/                 types this service owns
│       ├── Environment/            (optional) SwiftUI EnvironmentValues the service publishes
│       ├── Views/                  (optional) UI the service hosts itself (modals, toasts)
│       └── Utilities/              (optional) helpers private to this service
├── Shared/
│   ├── App.swift                   @main, delegate adaptor, the root Scene
│   ├── AppDelegate.swift           UIApplicationDelegate / NSApplicationDelegate, one file, #if os()
│   ├── Views/                      the app's view library (see below)
│   ├── Extensions/                 one file per extended type
│   ├── Design/                     Brand.swift, Brand.Color.swift, Style.swift, Fonts/
│   ├── Utility/                    non-Granite helpers: Device, Logger, Haptic, Pager, …
│   ├── i18n/                       <lang>.lproj localizations
│   └── Assets.xcassets
├── iOS/                            iOS-only files (platform navigation, entitlements)
├── macOS/                          macOS-only files
├── <Extension>/<Name>/             app extensions, e.g. Action/SetInstance/
├── Packages/                       vendored local Swift packages (keeps the app buildable forever)
├── Resources/                      README media and other non-target files
└── Tests iOS/, Tests macOS/
```

Components and Services sit at the root beside Shared, never inside it: they are the app's architecture, while Shared is the library they draw from. Granite's `create-granite-app.sh` template nests them in `Shared/`; `scripts/adopt_loom_layout.py` moves them out (see Bootstrapping).

## Services

- The folder, the type and every file prefix are the same word ending in `Service`: `Services/BookmarkService/BookmarkService.swift`, `BookmarkService+Center.swift`, `Reducers/BookmarkService.Boot.swift`. A folder called `Config/` or a reducer file called `Config.Boot.swift` breaks the rule that the file name says which service it belongs to.
- One reducer per file, named `<Name>Service.<Verb>.swift` after the reducer type (`AccountService.Auth.swift` holds `AccountService.Auth`). Several tiny reducers may share `<Name>Service._.swift`; split it as soon as one grows.
- Sub-reducers read as dotted paths: `AccountService.Profile.Add.swift`.
- `<Name>Service.swift` holds only the service struct and its public surface (the `set` helper, ticketed entries); state shape and the `@Event` list live in `+Center`.
- Persisted store keys follow `persistence.<app>.<store>.0001` and the number is bumped when a stored value's meaning changes.
- Anything a page, a menu or another service reads or sets is a service, not component state; the granite skill explains why.

## Components

- Named for what they are, without a suffix: `Feed`, `Bookmark`, `Settings`, `Home` (not `FeedComponent`). The folder, the type and every file prefix match.
- The three files always exist, even when one is short: `<Name>.swift` (declaration, `@Command var center`, the `@Relay`s it reads, `init`), `<Name>+Center.swift` (Center, State and small computed properties over state), `<Name>+View.swift` (`extension <Name>: View { var view: some View }`).
- A component's center holds only what its own controls touch (selection, a tab, hover). Shared state goes in a service.
- Subviews used only by this component go in its `Views/`, named `<Name>.<Role>View.swift` (`Feed.HeaderView.swift`, `Loom.CardView.swift`). The type inside is either a top-level `<Name><Role>View` struct or an `extension <Name>` of view builders. Group large sets in subfolders (`Views/Header/`, `Views/Layout/`).
- Reducers, when a component has any, follow the service rule: `Reducers/<Name>.<Verb>.swift`.
- `Models/` holds types only this component uses (`Home/Models/ContainerConfig.swift`).

## Shared/

Only `App.swift` and `AppDelegate.swift` sit loose in `Shared/`. Everything else is in one of its folders.

- **App.swift**: the `@main` struct, `@UIApplicationDelegateAdaptor` / `@NSApplicationDelegateAdaptor`, the root `Scene`. Boot is started from the root component once services report `isLoaded` (granite skill, rule 7), not from `App.init`.
- **AppDelegate.swift**: one class per platform in one file behind `#if os(iOS)` / `#elseif os(macOS)`. Platform lifecycle, URL handling, appearance proxies, AppKit event monitors. No app state.
- **Views/**: the view library. A view lives here once two or more components use it; until then it stays in the component's `Views/`.
  - Views about one domain model are grouped by that model, in plural folders: `Views/Posts/PostCardView.swift`, `Views/Comments/`, `Views/User/`, `Views/Community/`. Name them `<Model><Role>View`.
  - App-agnostic building blocks (scroll views, sliders, drawers, text inputs) take their own folder when they span several files (`Views/GraniteScrollView/`, `Views/Sliders/`) and sit at the top of `Views/` when they are one file (`LogoView.swift`, `StandardTextView.swift`).
  - Views are plain SwiftUI. Large ones may hold a `@Relay`; small ones take values and closures.
- **Extensions/**: one file per extended type, named after it: `String.swift`, `Date.swift`, and the domain models too (`Post.swift`, `Community.swift`). A SwiftUI modifier or a focused feature on a type is `<Type>+<Feature>.swift` (`View+OnLoad.swift`, `URL+Host.swift`). A set of files that form one unit gets a subfolder (`Extensions/Dictionary/`).
- **Design/**: `Brand.swift` (colors, gradients by name), `Brand.Color.swift`, `Style.swift` (spacing, radii, type), `Fonts/`.
- **Utility/**: everything app-wide that is not a view, an extension or a Granite service: `Device.swift`, `Logger.swift`, `Haptic.swift`. A utility spanning several files takes a folder (`Utility/Pager/`, `Utility/Onboarding/`).
- **i18n/**: the `.lproj` folders. (Loom calls it `i8n`; new apps use `i18n`.)

## Bootstrapping a new app

1. Generate the project with Granite's script:
   `~/Documents/repositories/Granite/Scripts/create-granite-app.sh <App> --output <path> --bundle-id <id> [--team <id>] --no-open`
2. Convert it to this layout:
   `python3 <this skill folder>/scripts/adopt_loom_layout.py <path>`
   It moves `Components/` and `Services/` to the root and registers them in the Xcode project as synchronized folders, renames `Services/Config` to `Services/ConfigService` (files included), drops the `Component` suffix from types, splits `Shared/Utilities` into `Shared/Extensions` and `Shared/Utility`, and adds `Shared/AppDelegate.swift`, the delegate adaptors in `App.swift`, and `Shared/Design/Brand.swift`. It refuses to run twice.
3. Build both schemes (`<App>-iOS` on a simulator, `<App>-macOS`), then check the layout:
   `python3 <this skill folder>/scripts/check_layout.py <path>` must report 0 errors.
4. Add the app's own services and pages following the sections above and the granite skill's recipes.

The template builds in Swift 6 language mode. As soon as a reducer holds a `@Relay` (Loom's pattern of a reducer dispatching into another service), set `SWIFT_VERSION = 5.0` on the app targets; the granite skill (rule 9) explains why.

## Adding to an existing app

| Adding | Goes in | Named |
|---|---|---|
| A page or stateful section | `Components/<Name>/` | `<Name>.swift`, `<Name>+Center.swift`, `<Name>+View.swift` |
| A subsystem with state and work | `Services/<Name>Service/` | `<Name>Service.swift`, `<Name>Service+Center.swift` |
| A reducer | the owner's `Reducers/` | `<Owner>.<Verb>.swift` |
| A view one component uses | `Components/<Name>/Views/` | `<Name>.<Role>View.swift` |
| A view two components use | `Shared/Views/<Models>/` or `Shared/Views/` | `<Model><Role>View.swift` |
| An extension | `Shared/Extensions/` | `<Type>.swift` or `<Type>+<Feature>.swift` |
| Colors, type, spacing | `Shared/Design/` | `Brand…`, `Style.swift` |
| A non-view helper | `Shared/Utility/` | what it is (`Haptic.swift`) |
| A third-party or private dependency the app must always build with | `Packages/<Name>/` | the package's own name |

When a subview from a component starts being used by a second component, move it to `Shared/Views/` and drop the component prefix from its file name.

Projects created from the template use synchronized folders, so a new file in an existing folder needs no project edit. A new top-level folder does: add it as a synchronized folder on both app targets (the adopt script shows the shape). Loom itself uses classic groups, so files added there must also be added to the Xcode project.

## Migrating an older app

Run `check_layout.py` first; each line it prints is one move or rename. The usual ones, as found in Loom:

| Old | New |
|---|---|
| `Shared/LAViews/` | merge into `Shared/Views/` (domain subfolders keep their names) |
| `Shared/LAExtensions/` | merge into `Shared/Extensions/` |
| `Shared/PEXApp.swift`, `Shared/PEXApp.AppDelegate.swift` | `Shared/App.swift`, `Shared/AppDelegate.swift` |
| `Reducers/Config.Boot.swift` | `Reducers/ConfigService.Boot.swift` |
| `Shared/i8n/` | `Shared/i18n/` |
| a component declared in another component's folder | its own `Components/<Name>/` |
| a `GraniteComponent` under `Shared/Utility/` | `Components/<Name>/` |

Renaming files never changes behavior, but in a project with classic groups each move has to be mirrored in the Xcode project (or done in Xcode), and every rename has to keep the app building on both platforms before the next one.

## Things that look fine and are not

- **A component named like a SwiftUI type** (`Settings`) compiles because the app's type shadows SwiftUI's, but inside a `Scene` builder on macOS write `SwiftUI.Settings { }` when you mean the scene.
- **Putting a page's shared state in its component center** because only one page shows it today: menus, key monitors and other windows cannot reach a component center. Use a service.
- **Starting boot from `App.init`** with `restore(wait: true)` then `boot.send()`: restore no longer blocks on current Granite, so boot runs on default state. Gate on `isLoaded` (granite skill).
- **Leaving a dependency on a branch or a private remote**: the app must keep building from a fresh clone. Vendor it into `Packages/` or pin it to an exact revision.
