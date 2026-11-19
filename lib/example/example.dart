import 'package:material_ui/material_ui.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 700,
              child: AnchorList(
                count: 10,
                itemBuilder: (context, index, anchor) {
                  return AnimatedScale(
                    duration: const Duration(milliseconds: 300),
                    scale: anchor ? 1 : .9,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      decoration: BoxDecoration(
                        color: anchor
                            ? Theme.of(context).colorScheme.primaryContainer
                            : Theme.of(context).colorScheme.surfaceContainerLow,
                        border: Border.all(
                          color: anchor
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(
                                  context,
                                ).colorScheme.surfaceContainerHighest,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          if (anchor)
                            BoxShadow(
                              blurRadius: 30,
                              color: Theme.of(
                                context,
                              ).colorScheme.primary.withAlpha(100),
                            ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16.0),
                        title: Text(
                          'Item $index',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                            color: anchor
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.outlineVariant,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
