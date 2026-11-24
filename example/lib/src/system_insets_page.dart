import 'package:fluiver/fluiver.dart';
import 'package:material_ui/material_ui.dart';

class const SystemInsetsPage({super.key}) extends StatelessWidget {
  static const Color _color = Colors.indigo;

  void _rename(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => const ViewInsetsPadding(
        child: SafeArea(
          top: false,
          child: Padding(
            padding: .all(16),
            child: TextField(
              autofocus: true,
              decoration: InputDecoration(labelText: 'Name'),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final onColor = _color.contrastText;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: StatusBarHeader(
              color: _color,
              child: Row(
                children: [
                  BackButton(color: onColor),
                  Text(
                    'System insets',
                    style: Theme.of(context).textTheme.titleLarge
                        ?.copyWith(color: onColor),
                  ),
                ],
              ),
            ),
          ),
          SliverList.builder(
            itemCount: 30,
            itemBuilder: (context, index) => ListTile(
              title: Text('Message $index'),
              onTap: () => _rename(context),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const ViewInsetsPadding(
        child: ColoredBox(
          color: Colors.white,
          child: SafeArea(
            top: false,
            child: Padding(
              padding: .all(8),
              child: TextField(
                decoration: InputDecoration(hintText: 'Message'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
