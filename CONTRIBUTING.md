# Contributing

1. `flutter pub get`
2. Run what CI runs:

   ```bash
   git ls-files -z -- '*.dart' |
     xargs -0 dart format --output=none --set-exit-if-changed
   flutter analyze --fatal-infos --fatal-warnings
   flutter test
   flutter pub publish --dry-run
   npx --yes markdownlint-cli2@0.23.3
   dart run tool/check_snippets.dart \
     --import package:fluiver/fluiver.dart \
     --import package:material_ui/material_ui.dart
   ```

3. Add a line under `## Unreleased` in `CHANGELOG.md` for every user-visible
   change.

Releases are published manually by the maintainer.
