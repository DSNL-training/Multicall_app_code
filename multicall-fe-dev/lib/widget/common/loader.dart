import 'package:flutter/material.dart';

class Loader {
  static OverlayEntry? _overlayEntry;
  static int _loadingCount = 0;

  static get loaderCount => _loadingCount;

  static void showLoader(BuildContext context) {
    _loadingCount++;

    if (_overlayEntry == null && _loadingCount > 0) {
      _overlayEntry = OverlayEntry(
        builder: (BuildContext context) => const FullScreenLoadingWidget(),
      );
      Overlay.of(context).insert(_overlayEntry!);
    }
  }

  static void hideLoader(BuildContext context) {
    if (_loadingCount > 0) {
      _loadingCount--;

      if (_loadingCount == 0 && _overlayEntry != null) {
        _overlayEntry!.remove();
        _overlayEntry = null;
      }
    }
  }
}

class FullScreenLoadingWidget extends StatefulWidget {
  final bool showBackgroundOverlay;
  final double imageSize;
  final double borderRadius;

  const FullScreenLoadingWidget({
    Key? key,
    this.showBackgroundOverlay = true,
    this.imageSize = 60.0,
    this.borderRadius = 16.0,
  }) : super(key: key);

  @override
  State<FullScreenLoadingWidget> createState() =>
      _FullScreenLoadingWidgetState();
}

class _FullScreenLoadingWidgetState extends State<FullScreenLoadingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _controller.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          widget.showBackgroundOverlay
              ? Container(
                  color: Colors.black.withOpacity(0.5),
                )
              : const SizedBox(),
          Center(
            child: Container(
              height: 60.0,
              width: 180.0,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(widget.borderRadius),
              ),
              child: Center(
                child: FadeTransition(
                  opacity: _controller.drive(Tween(begin: 0.1, end: 1.0)),
                  child: const Text(
                    "Reconnecting...",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: Color.fromRGBO(0, 134, 181, 1),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
