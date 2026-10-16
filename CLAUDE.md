# Agent rules

For coding agents working on this repo, locally or on GitHub (`@claude`).
README.md is for the package's users; rules for using the package's API live in
`skills/*/SKILL.md`.

## Verify before you finish

- CI (`.github/workflows/ci.yaml`) is the gate, and a pull request merges only
  when every CI job is green. Before you finish, run its format, analyze,
  snippet and test steps on the stable channel and fix what fails.
- Format tracked Dart files only:
  `git ls-files -z -- '*.dart' | xargs -0 dart format`.
- New behaviour ships with a test that fails without the change.
- Never skip hooks (`--no-verify`) or weaken a check to get green.

## Dart

- Tests assert with `package:checks` only, never `package:matcher`.
- Never use `!`.
- `await` by default; never `unawaited(...)`.
- Extension members are methods, never getters.
- No explanatory comments: names carry the meaning. Comment only units,
  non-obvious invariants, traps and external contracts.
- Never `final` on a type that a test doubles: mockito emits `implements`.

## API design

Natural APIs, no cover-ups. Misuse throws `StateError`, `ArgumentError` or
`RangeError` in every build mode, not a debug-only assert. Never clamp, ignore,
migrate or quietly degrade on the caller's behalf. A callback or name does what
it says, or it doesn't exist.

## Docs

- The README is for humans first: what the package does, why to use it, and how
  (install line plus the smallest real example).
- Markdown stays within 80 columns, code blocks included. Tables are exempt from
  the lint but must not scroll sideways on pub.dev. Dart blocks in the README
  and skills are analyzed with the package lints (`tool/check_snippets.dart`).

## Changes and releases

- Commit messages follow Conventional Commits (`feat:`, `fix:`, `docs:`, `ci:`,
  `chore:`); a breaking change says so.
- A user-visible change gets a CHANGELOG entry under `## Unreleased`, added at
  the top if missing. Never edit `version:`, tag or publish: the maintainer
  releases.
- Secrets never go in git.
