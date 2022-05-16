import 'package:fluiver/fluiver.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

void main() {
  testGoldens('GoogleAvatar', (tester) async {
    final cases = [
      GoogleAvatar(size: 48, index: 0, name: 'John Doe'),
      GoogleAvatar(size: 36, index: 1, name: 'John Doe'),
      GoogleAvatar(size: 24, index: 2, name: 'John Doe'),
      GoogleAvatar(size: 48, index: 3, name: 'John'),
      GoogleAvatar(size: 36, index: 4, name: 'John'),
      GoogleAvatar(size: 24, index: 5, name: 'John'),
      GoogleAvatar(size: 64, index: 6, name: 'John Doe'),
      GoogleAvatar(size: 64, index: 7, name: 'JD'),
    ];
    final builder = GoldenBuilder.grid(columns: 4, widthToHeightRatio: 1);
    for (var e in cases) {
      builder.addScenario('${e.name} - ${e.size} - ${e.index}', e);
    }

    await tester.pumpWidgetBuilder(
      builder.build(),
      wrapper: materialAppWrapper(),
    );
    await screenMatchesGolden(tester, 'google_avatar');
  });
}
