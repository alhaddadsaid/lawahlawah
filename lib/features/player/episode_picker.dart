import 'package:flutter/material.dart';

/// Returns an episode index; the caller retains playback on dismissal.
Future<int?> showEpisodePicker(BuildContext context, {required List<int> numbers, required int selected}) =>
    showModalBottomSheet<int>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => _EpisodePicker(numbers: numbers, selected: selected),
    );

class _EpisodePicker extends StatefulWidget {
  const _EpisodePicker({required this.numbers, required this.selected});
  final List<int> numbers;
  final int selected;
  @override
  State<_EpisodePicker> createState() => _EpisodePickerState();
}

class _EpisodePickerState extends State<_EpisodePicker> {
  ScrollController? _controller;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final columns = (MediaQuery.sizeOf(context).width / 76).floor().clamp(3, 8);
    _controller ??= ScrollController(initialScrollOffset: (widget.selected ~/ columns) * 64.0);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SafeArea(
    top: false,
    child: SizedBox(
      height: MediaQuery.sizeOf(context).height * .6,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 12, 12),
            child: Row(
              children: [
                Expanded(
                  child: Text('Episodes · ${widget.numbers.length}', style: Theme.of(context).textTheme.titleLarge),
                ),
                IconButton(
                  tooltip: 'Close episodes',
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final columns = (constraints.maxWidth / 76).floor().clamp(3, 8);
                return GridView.builder(
                  controller: _controller,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    mainAxisExtent: 56,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemCount: widget.numbers.length,
                  itemBuilder: (context, index) => OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: index == widget.selected ? Theme.of(context).colorScheme.primaryContainer : null,
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: () => Navigator.pop(context, index),
                    child: Text(
                      '${widget.numbers[index]}',
                      semanticsLabel: 'Episode ${widget.numbers[index]}${index == widget.selected ? ", playing" : ""}',
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}
