#!/usr/bin/env python3
"""
Check an app against the Loom layout and print every deviation.

    python3 check_layout.py <path-to-app>

Errors break the layout (a reader can no longer find a file by its name);
warnings are drift worth fixing when you touch that code. Exit status is 1
when there are errors.
"""
import os
import re
import sys

SERVICE_SUBFOLDERS = {"Reducers", "Models", "Ops", "Views", "Environment", "Utilities"}
COMPONENT_SUBFOLDERS = {"Reducers", "Views", "Actions", "Models", "Utility"}
SHARED_FOLDERS = {"Views", "Extensions", "Design", "Utility", "i18n"}

errors, warnings = [], []


def err(msg):
    errors.append(msg)


def warn(msg):
    warnings.append(msg)


def entries(path):
    return sorted(e for e in os.listdir(path) if not e.startswith("."))


def swift_files(root):
    for base, dirs, files in os.walk(root):
        dirs[:] = [d for d in dirs if not d.startswith(".") and not d.endswith((".xcodeproj", ".xcassets")) and d not in ("Packages", "Tests")]
        for f in files:
            if f.endswith(".swift"):
                yield os.path.join(base, f)


def check_root(app):
    for folder in ("Components", "Services", "Shared"):
        if not os.path.isdir(os.path.join(app, folder)):
            err(f"{folder}/ is missing at the project root")
    for nested in ("Shared/Components", "Shared/Services"):
        if os.path.isdir(os.path.join(app, nested)):
            err(f"{nested}/ belongs at the project root as {nested.split('/')[1]}/")


def check_shared(app):
    shared = os.path.join(app, "Shared")
    if not os.path.isdir(shared):
        return
    names = entries(shared)
    for required in ("App.swift", "AppDelegate.swift"):
        if required not in names:
            err(f"Shared/{required} is missing")
    for name in names:
        path = os.path.join(shared, name)
        if os.path.isdir(path):
            if name.startswith("LA") and name[2:] in ("Views", "Extensions"):
                err(f"Shared/{name}/ is the old prefix: merge it into Shared/{name[2:]}/")
            elif name in ("Utilities",):
                err("Shared/Utilities/ is named Shared/Utility/")
            elif name not in SHARED_FOLDERS and not name.endswith((".xcassets", ".lproj")):
                warn(f"Shared/{name}/ is not a standard Shared folder ({', '.join(sorted(SHARED_FOLDERS))})")
        elif name.endswith(".swift") and name not in ("App.swift", "AppDelegate.swift"):
            warn(f"Shared/{name} sits loose in Shared/; only App.swift and AppDelegate.swift live there")


def check_service(app, name):
    folder = os.path.join(app, "Services", name)
    rel = f"Services/{name}"
    if not name.endswith("Service"):
        err(f"{rel}/ must be named {name}Service/")
    for required in (f"{name}.swift", f"{name}+Center.swift"):
        if not os.path.exists(os.path.join(folder, required)):
            err(f"{rel}/{required} is missing")
    for entry in entries(folder):
        path = os.path.join(folder, entry)
        if os.path.isdir(path):
            if entry not in SERVICE_SUBFOLDERS:
                warn(f"{rel}/{entry}/ is not a standard service folder ({', '.join(sorted(SERVICE_SUBFOLDERS))})")
        elif entry.endswith(".swift") and not re.match(rf"^{re.escape(name)}(\+\w+)?\.swift$", entry):
            warn(f"{rel}/{entry} at the service root should be {name}+<Topic>.swift or move into a subfolder")
    reducers = os.path.join(folder, "Reducers")
    if os.path.isdir(reducers):
        for f in entries(reducers):
            if f.endswith(".swift") and not f.startswith(f"{name}."):
                err(f"{rel}/Reducers/{f} must be named {name}.<Verb>.swift")


def check_component(app, name):
    folder = os.path.join(app, "Components", name)
    rel = f"Components/{name}"
    if name.endswith("Component"):
        err(f"{rel}/ and its type are named without the Component suffix")
    for required in (f"{name}.swift", f"{name}+Center.swift", f"{name}+View.swift"):
        if not os.path.exists(os.path.join(folder, required)):
            err(f"{rel}/{required} is missing")
    for entry in entries(folder):
        path = os.path.join(folder, entry)
        if os.path.isdir(path):
            if entry not in COMPONENT_SUBFOLDERS:
                warn(f"{rel}/{entry}/ is not a standard component folder ({', '.join(sorted(COMPONENT_SUBFOLDERS))})")
        elif entry.endswith(".swift") and not re.match(rf"^{re.escape(name)}(\+\w+)?\.swift$", entry):
            warn(f"{rel}/{entry} at the component root should be {name}+<Topic>.swift or move into a subfolder")
    for sub in ("Reducers", "Actions", "Views"):
        path = os.path.join(folder, sub)
        if not os.path.isdir(path):
            continue
        for base, _, files in os.walk(path):
            for f in files:
                if f.endswith(".swift") and not f.startswith(name):
                    target = err if sub == "Reducers" else warn
                    target(f"{os.path.relpath(os.path.join(base, f), app)} should start with {name}")


def check_types(app):
    for path in swift_files(app):
        rel = os.path.relpath(path, app)
        with open(path, errors="ignore") as fh:
            src = fh.read()
        for t in re.findall(r"struct (\w+)\s*:\s*GraniteService\b", src):
            if not rel.startswith("Services/"):
                err(f"{t} (a GraniteService) is declared in {rel}; it belongs in Services/{t}/")
            elif not rel.startswith(f"Services/{t}/"):
                err(f"{t} is declared in {rel}; it belongs in Services/{t}/{t}.swift")
        for t in re.findall(r"struct (\w+)\s*:\s*GraniteComponent\b", src):
            if not rel.startswith("Components/"):
                err(f"{t} (a GraniteComponent) is declared in {rel}; it belongs in Components/{t}/")
            elif not rel.startswith(f"Components/{t}/"):
                err(f"{t} is declared in {rel}; it belongs in Components/{t}/{t}.swift")
        if re.search(r"^@main\b", src, re.M) and rel != os.path.join("Shared", "App.swift"):
            err(f"the @main App is in {rel}; it belongs in Shared/App.swift")


def main():
    if len(sys.argv) != 2:
        print("usage: check_layout.py <path-to-app>", file=sys.stderr)
        sys.exit(2)
    app = os.path.abspath(sys.argv[1])
    check_root(app)
    check_shared(app)
    for kind, check in (("Services", check_service), ("Components", check_component)):
        root = os.path.join(app, kind)
        if os.path.isdir(root):
            for name in entries(root):
                if os.path.isdir(os.path.join(root, name)):
                    check(app, name)
    check_types(app)

    for e in errors:
        print(f"✗ {e}")
    for w in warnings:
        print(f"! {w}")
    print(f"{len(errors)} error(s), {len(warnings)} warning(s)")
    sys.exit(1 if errors else 0)


if __name__ == "__main__":
    main()
