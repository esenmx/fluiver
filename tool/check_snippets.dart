import 'dart:convert';
import 'dart:io';

const String _usage = '''
Analyzes the ```dart blocks of README.md and skills/*/SKILL.md against this
package with its analysis_options.yaml and fails on any diagnostic, except
those that only fire because a block is a fragment. A block whose previous
non-blank line is <!-- no-compile --> is skipped.

dart run tool/check_snippets.dart [--import <uri>]... [--dep <package>]... [file]...''';

const String _noCompile = '<!-- no-compile -->';

const List<String> _fragmentDiagnostics = [
  'unused_element',
  'unused_field',
  'unused_import',
  'unused_local_variable',
];

const List<String> _fragmentLints = [
  'depend_on_referenced_packages',
  'directives_ordering',
  'public_member_api_docs',
];

final RegExp _declaration = RegExp(
  '^(import |export |library|part |class |abstract |base |final class |'
  'sealed |interface |mixin |extension |enum |typedef |@|void main|'
  'Future<void> main)',
);

final RegExp _variable = RegExp('^(final |const |var |late )');

final class _Snippet(
  final String file,
  final int fenceLine,
  final List<String> lines,
);

final class _Rendered(
  final _Snippet snippet,
  final List<String> lines,
  // 0-based snippet line of each rendered line; -1 for generated lines.
  final List<int> origins,
);

_Rendered _render(_Snippet snippet, List<String> imports) {
  final hasDeclarations = snippet.lines.any(_declaration.hasMatch);
  final declarations = <int>[];
  final statements = <int>[];
  var inDeclaration = false;
  for (final (i, line) in snippet.lines.indexed) {
    final atColumnZero = line.isNotEmpty && !line.startsWith(RegExp(r'\s'));
    if (atColumnZero && !line.startsWith(RegExp(r'[})\]]'))) {
      inDeclaration =
          _declaration.hasMatch(line) ||
          (hasDeclarations && _variable.hasMatch(line));
    }
    (inDeclaration ? declarations : statements).add(i);
  }
  final hasStatements = statements.any(
    (i) => snippet.lines[i].trim().isNotEmpty,
  );
  final lines = <String>[];
  final origins = <int>[];
  void emit(String line, int origin) {
    lines.add(line);
    origins.add(origin);
  }

  for (final uri in imports) {
    if (!snippet.lines.any((l) => l.contains("'$uri'"))) {
      emit("import '$uri';", -1);
    }
  }
  for (final i in declarations) {
    emit(snippet.lines[i], i);
  }
  if (hasStatements) {
    emit('Future<void> _snippet() async {', -1);
    for (final i in statements) {
      emit(snippet.lines[i], i);
    }
    emit('}', -1);
  }
  return _Rendered(snippet, lines, origins);
}

Future<void> main(List<String> args) async {
  final imports = <String>[];
  final deps = <String>[];
  final files = <String>[];
  for (var i = 0; i < args.length; i++) {
    switch (args[i]) {
      case '--import' when i + 1 < args.length:
        imports.add(args[++i]);
      case '--dep' when i + 1 < args.length:
        deps.add(args[++i]);
      case '-h' || '--help':
        stdout.writeln(_usage);
        return;
      case final arg when arg.startsWith('-'):
        stderr.writeln('Unknown option $arg\n\n$_usage');
        exit(64);
      case final arg:
        files.add(arg);
    }
  }
  if (files.isEmpty) {
    files.add('README.md');
    final skills = Directory('skills');
    if (skills.existsSync()) {
      final found =
          skills
              .listSync(recursive: true)
              .whereType<File>()
              .map((f) => f.path)
              .where((p) => p.endsWith('SKILL.md'))
              .toList()
            ..sort();
      files.addAll(found);
    }
  }

  final pubspec = File('pubspec.yaml').readAsStringSync();
  final name = RegExp(
    r'^name:\s*(\S+)',
    multiLine: true,
  ).firstMatch(pubspec)?.group(1);
  final sdk = RegExp(
    r'''^environment:\s*\n(?:\s+.*\n)*?\s+sdk:\s*['"]?([^'"\n]+)''',
    multiLine: true,
  ).firstMatch(pubspec)?.group(1)?.trim();
  if (name == null || sdk == null) {
    stderr.writeln('pubspec.yaml has no name or environment sdk constraint');
    exit(65);
  }
  final options = File('analysis_options.yaml');
  if (!options.existsSync()) {
    stderr.writeln('analysis_options.yaml not found; snippets use its lints');
    exit(65);
  }
  final included = RegExp(
    r'^include:\s*package:(\w+)/',
    multiLine: true,
  ).firstMatch(options.readAsStringSync())?.group(1);
  final includedConstraint = included == null
      ? null
      : RegExp(
          '^\\s+$included:\\s*(\\S+)',
          multiLine: true,
        ).firstMatch(pubspec)?.group(1);
  if (included != null && includedConstraint == null) {
    stderr.writeln(
      'analysis_options.yaml includes package:$included, which pubspec.yaml '
      'does not depend on',
    );
    exit(65);
  }
  final usesFlutter = RegExp(
    r'^\s+sdk:\s*flutter\s*$',
    multiLine: true,
  ).hasMatch(pubspec);

  final snippets = <_Snippet>[];
  var skipped = 0;
  for (final file in files) {
    final lines = File(file).readAsLinesSync();
    for (var i = 0; i < lines.length; i++) {
      if (lines[i].trim() != '```dart') {
        continue;
      }
      final start = i;
      final body = <String>[];
      for (i++; i < lines.length && lines[i].trim() != '```'; i++) {
        body.add(lines[i]);
      }
      final previous = lines
          .take(start)
          .lastWhere((l) => l.trim().isNotEmpty, orElse: () => '');
      if (previous.trim() == _noCompile) {
        skipped++;
      } else {
        snippets.add(_Snippet(file, start + 1, body));
      }
    }
  }

  if (snippets.isEmpty) {
    stdout.writeln(
      'check_snippets: no ```dart blocks to analyze ($skipped marked '
      '$_noCompile).',
    );
    return;
  }

  final workspace = Directory.systemTemp.createTempSync('check_snippets_');
  try {
    final repo = Directory.current.absolute.path;
    final dependencies = <String, String>{
      for (final dep in deps) dep: ' any',
      ?included: ' $includedConstraint',
      if (usesFlutter) 'flutter': '\n    sdk: flutter',
      name: '\n    path: ${jsonEncode(repo)}',
    };
    File('${workspace.path}/pubspec.yaml').writeAsStringSync(
      [
        'name: snippets',
        'publish_to: none',
        'environment:',
        "  sdk: '$sdk'",
        'dependencies:',
        for (final dep in dependencies.keys.toList()..sort())
          '  $dep:${dependencies[dep]}',
        '',
      ].join('\n'),
    );
    File('${workspace.path}/analysis_options.yaml').writeAsStringSync(
      [
        'include: ${jsonEncode(options.absolute.path)}',
        'analyzer:',
        '  errors:',
        for (final code in _fragmentDiagnostics) '    $code: ignore',
        'linter:',
        '  rules:',
        for (final rule in _fragmentLints) '    $rule: false',
        '',
      ].join('\n'),
    );

    final rendered = <String, _Rendered>{};
    for (final (index, snippet) in snippets.indexed) {
      final render = _render(snippet, imports);
      final path = '${workspace.path}/lib/snippet_$index.dart';
      File(path)
        ..createSync(recursive: true)
        ..writeAsStringSync('${render.lines.join('\n')}\n');
      rendered[File(path).resolveSymbolicLinksSync()] = render;
    }

    final get = await Process.run(usesFlutter ? 'flutter' : 'dart', [
      'pub',
      'get',
    ], workingDirectory: workspace.path);
    if (get.exitCode != 0) {
      stderr
        ..writeln('pub get failed for the snippet package:')
        ..writeln(get.stdout)
        ..writeln(get.stderr);
      exit(1);
    }
    final analyze = await Process.run('dart', [
      'analyze',
      '--format=machine',
      '--no-fatal-warnings',
      '.',
    ], workingDirectory: workspace.path);

    var issues = 0;
    for (final line in '${analyze.stdout}\n${analyze.stderr}'.split('\n')) {
      final fields = line.split('|');
      if (fields.length < 8 ||
          !const {'ERROR', 'WARNING', 'INFO'}.contains(fields[0])) {
        continue;
      }
      issues++;
      final severity = fields[0].toLowerCase();
      final code = fields[2].toLowerCase();
      final message = fields.sublist(7).join('|');
      final target =
          rendered[File(fields[3]).absolute.path] ??
          rendered[_resolve(fields[3])];
      if (target == null) {
        stdout.writeln(
          '${fields[3]}:${fields[4]}: $severity: $message ($code)',
        );
        continue;
      }
      final renderedLine = int.parse(fields[4]) - 1;
      final origin = renderedLine < target.origins.length
          ? target.origins[renderedLine]
          : -1;
      final mdLine = target.snippet.fenceLine + origin + 1;
      stdout.writeln(
        '${target.snippet.file}:$mdLine: $severity: $message ($code)',
      );
    }
    if (analyze.exitCode != 0 && issues == 0) {
      stderr
        ..writeln('dart analyze exited ${analyze.exitCode} with no diagnostic:')
        ..writeln(analyze.stdout)
        ..writeln(analyze.stderr);
      exit(1);
    }
    stdout.writeln(
      'check_snippets: ${snippets.length} block(s) analyzed, $skipped '
      'marked $_noCompile, $issues issue(s).',
    );
    if (issues > 0) {
      exit(1);
    }
  } finally {
    workspace.deleteSync(recursive: true);
  }
}

String _resolve(String path) {
  final file = File(path);
  return file.existsSync() ? file.resolveSymbolicLinksSync() : path;
}
