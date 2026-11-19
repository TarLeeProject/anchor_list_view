class AnchorList extends StatefulWidget {
  const AnchorList({super.key, required this.itemBuilder, required this.count});

  final Widget Function(BuildContext, int, bool) itemBuilder;
  final int count;

  @override
  State<AnchorList> createState() => _AnchorListState();
}

class _AnchorListState extends State<AnchorList> {
  final _scrollController = ScrollController();
  final _viewportKey = GlobalKey();

  late final List<GlobalKey> _itemKeys;

  int _closestIndex = 0;

  double anchorFraction = .5;

  @override
  void initState() {
    super.initState();
    _itemKeys = List.generate(widget.count, (_) => GlobalKey());
    _scrollController.addListener(_scheduleDetection);
  }

  void _scheduleDetection() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _detectAnchorItem();
    });
  }

  void _detectAnchorItem() {
    final viewportBox =
        _viewportKey.currentContext?.findRenderObject() as RenderBox?;

    if (viewportBox == null || !viewportBox.hasSize) return;

    final anchorY = viewportBox.size.height * anchorFraction;

    double minDistance = double.infinity;
    int closestIndex = 0;

    for (int i = 0; i < _itemKeys.length; i++) {
      final box = _itemKeys[i].currentContext?.findRenderObject() as RenderBox?;

      if (box == null || !box.hasSize) continue;

      final offset = box.localToGlobal(Offset.zero, ancestor: viewportBox);

      final itemCenterY = offset.dy + box.size.height / 2;
      final distance = (itemCenterY - anchorY).abs();

      if (distance < minDistance) {
        minDistance = distance;
        closestIndex = i;
      }
    }

    if (closestIndex != _closestIndex) {
      setState(() => _closestIndex = closestIndex);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scheduleDetection);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final anchorY = constraints.maxHeight * anchorFraction;

        return ListView.builder(
          key: _viewportKey,
          controller: _scrollController,
          itemCount: widget.count,
          padding: EdgeInsets.only(
            top: anchorY,
            bottom: constraints.maxHeight - anchorY,
          ),
          itemBuilder: (context, index) {
            return Container(
              key: _itemKeys[index],
              child: widget.itemBuilder.call(
                context,
                index,
                index == _closestIndex,
              ),
            );
          },
        );
      },
    );
  }
}
