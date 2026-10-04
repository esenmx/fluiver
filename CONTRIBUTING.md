# Contributing

1. `flutter pub get`
2. Run what CI runs:
   - `git ls-files -z -- '*.dart' | xargs -0 dart format --output=none --set-exit-if-changed`
   - `flutter analyze --fatal-infos --fatal-warnings`
   - `flutter test`
   - `flutter pub publish --dry-run`
3. Add a line under `## Unreleased` in `CHANGELOG.md` for every user-visible change.

Releases are published manually by the maintainer.
