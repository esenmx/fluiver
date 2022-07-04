import 'package:fluiver/fluiver.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

void main() {
  testGoldens('GoogleAvatar', (tester) async {
    final cases = [
      GoogleAvatar(size: 48, name: 'John Doe'),
      GoogleAvatar(size: 36, name: 'John Doe'),
      GoogleAvatar(size: 24, name: 'Down Johns'),
      GoogleAvatar(size: 48, name: 'John'),
      GoogleAvatar(size: 36, name: 'Johnny'),
      GoogleAvatar(size: 24, name: 'Johanna'),
      GoogleAvatar(size: 64, name: 'John Doe'),
      GoogleAvatar(size: 64, name: 'JD'),
    ];
    final builder = GoldenBuilder.grid(columns: 4, widthToHeightRatio: 1);
    for (var e in cases) {
      builder.addScenario('${e.name} - ${e.size.toInt()}', e);
    }

    await tester.pumpWidgetBuilder(
      builder.build(),
      wrapper: materialAppWrapper(),
    );
    await screenMatchesGolden(tester, 'google_avatar');
  });
}
