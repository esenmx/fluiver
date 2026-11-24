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

<!-- rules: start (generated, do not edit) -->
## Rules

These hold for every change, whoever or whatever writes it.

### Before you push

- CI (`.github/workflows/ci.yaml`) is the gate, and a pull request merges only
  when every CI job is green. Run its format, analyze, snippet and test steps on
  the stable channel and fix what fails.
- Format with `dart format .`; it covers every file the CI format job checks.
- New behaviour ships with a test that fails without the change.
- Never skip hooks (`--no-verify`) or weaken a check to get green.

### Dart

- Tests assert with `package:checks` only, never `package:matcher`.
- Never use `!`.
- `await` by default; never `unawaited(...)`.
- Extension members: getters for pure zero-argument reads, methods for actions,
  arguments, I/O, `toX()` conversions and `Future`/`Stream` wrappers.
- No explanatory comments: names carry the meaning. Comment only units,
  non-obvious invariants, traps and external contracts.
- Never `final` on a type that a test doubles: mockito emits `implements`.

### API design

Natural APIs, no cover-ups. Misuse throws `StateError`, `ArgumentError` or
`RangeError` in every build mode, not a debug-only assert. Never clamp, ignore,
migrate or quietly degrade on the caller's behalf. A callback or name does what
it says, or it doesn't exist.

### Docs

- README.md is for the package's users; rules for coding agents that use the
  package's API live in `skills/*/SKILL.md`.
- The README is for humans first: what the package does, why to use it, and how
  (install line plus the smallest real example).
- Markdown stays within 80 columns, code blocks included, except tables (must
  not scroll sideways on pub.dev) and `skills/**/*.md` (unwrapped for token
  efficiency). Dart blocks in the README, `doc/` and skills are analyzed with
  the package lints (`tool/check_snippets.dart`).

### Changes and releases

- Commit messages follow Conventional Commits (`feat:`, `fix:`, `docs:`, `ci:`,
  `chore:`); a breaking change says so.
- A user-visible change gets a CHANGELOG entry under `## Unreleased`, added at
  the top if missing. Never edit `version:`, tag or publish: the maintainer
  releases.
- Secrets never go in git.
<!-- rules: end -->
