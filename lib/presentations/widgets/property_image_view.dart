import 'dart:async';

import 'package:flutter/material.dart';
import '../../core/constants/color_constants.dart';

void openPropertyImages(
  BuildContext context, {
  required List<String> urls,
  int initialIndex = 0,
}) {
  final images = urls.map((url) => url.trim()).where((url) => url.isNotEmpty).toList();
  if (images.isEmpty) return;
  final index = initialIndex.clamp(0, images.length - 1);
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => FullScreenImageViewer(
        urls: images,
        initialIndex: index,
      ),
    ),
  );
}

class PropertyImageView extends StatefulWidget {
  final List<String> urls;
  final double? height;
  final double? width;
  final BoxFit fit;
  final bool autoPlay;
  final int initialIndex;
  final Widget? fallback;

  const PropertyImageView({
    super.key,
    required this.urls,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.autoPlay = true,
    this.initialIndex = 0,
    this.fallback,
  });

  @override
  State<PropertyImageView> createState() => _PropertyImageViewState();
}

class _PropertyImageViewState extends State<PropertyImageView> {
  Timer? _timer;
  int _index = 0;

  List<String> get _urls => widget.urls
      .map((url) => url.trim())
      .where((url) => url.isNotEmpty)
      .toList();

  @override
  void initState() {
    super.initState();
    final count = _urls.length;
    _index = count == 0 ? 0 : widget.initialIndex.clamp(0, count - 1);
    _start();
  }

  @override
  void didUpdateWidget(PropertyImageView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.urls.join() != widget.urls.join()) {
      _index = 0;
      _start();
    }
  }

  void _start() {
    _timer?.cancel();
    if (!widget.autoPlay || _urls.length < 2) return;
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;
      setState(() => _index = (_index + 1) % _urls.length);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final urls = _urls;
    final child = urls.isEmpty
        ? (widget.fallback ??
            Container(
              color: ColorConstants.pronexPrimaryLight,
              alignment: Alignment.center,
              child: Icon(
                Icons.apartment_rounded,
                color: ColorConstants.pronexPrimary.withValues(alpha: 0.45),
                size: 40,
              ),
            ))
        : GestureDetector(
            onTap: () => openPropertyImages(
              context,
              urls: urls,
              initialIndex: _index,
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: Image.network(
                urls[_index % urls.length],
                key: ValueKey(urls[_index % urls.length]),
                fit: widget.fit,
                width: widget.width ?? double.infinity,
                height: widget.height,
                errorBuilder: (_, __, ___) =>
                    widget.fallback ??
                    Container(color: ColorConstants.pronexPrimaryLight),
              ),
            ),
          );

    if (widget.height == null && widget.width == null) return child;
    return SizedBox(height: widget.height, width: widget.width, child: child);
  }
}

class FullScreenImageViewer extends StatefulWidget {
  final List<String> urls;
  final int initialIndex;

  const FullScreenImageViewer({
    super.key,
    required this.urls,
    required this.initialIndex,
  });

  @override
  State<FullScreenImageViewer> createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<FullScreenImageViewer> {
  late final PageController _pageController;
  late int _index;
  bool _zoomed = false;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            physics: _zoomed
                ? const NeverScrollableScrollPhysics()
                : const PageScrollPhysics(),
            itemCount: widget.urls.length,
            onPageChanged: (index) => setState(() {
              _index = index;
              _zoomed = false;
            }),
            itemBuilder: (context, index) {
              return _ZoomableImage(
                url: widget.urls[index],
                onZoomChanged: (zoomed) {
                  if (_zoomed == zoomed) return;
                  setState(() => _zoomed = zoomed);
                },
              );
            },
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded, color: Colors.white),
                  ),
                  const Spacer(),
                  if (widget.urls.length > 1)
                    Text(
                      '${_index + 1} / ${widget.urls.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  const SizedBox(width: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ZoomableImage extends StatefulWidget {
  final String url;
  final ValueChanged<bool> onZoomChanged;

  const _ZoomableImage({required this.url, required this.onZoomChanged});

  @override
  State<_ZoomableImage> createState() => _ZoomableImageState();
}

class _ZoomableImageState extends State<_ZoomableImage> {
  final TransformationController _controller = TransformationController();
  TapDownDetails? _doubleTapDetails;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onInteractionEnd(ScaleEndDetails details) {
    widget.onZoomChanged(_controller.value.getMaxScaleOnAxis() > 1.02);
  }

  void _handleDoubleTap() {
    final zoomed = _controller.value.getMaxScaleOnAxis() > 1.02;
    if (zoomed) {
      _controller.value = Matrix4.identity();
      widget.onZoomChanged(false);
      return;
    }
    final position = _doubleTapDetails?.localPosition ?? Offset.zero;
    const scale = 2.5;
    _controller.value = Matrix4.identity()
      ..translate(-position.dx * (scale - 1), -position.dy * (scale - 1))
      ..scale(scale);
    widget.onZoomChanged(true);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTapDown: (details) => _doubleTapDetails = details,
      onDoubleTap: _handleDoubleTap,
      child: InteractiveViewer(
        transformationController: _controller,
        minScale: 1,
        maxScale: 4,
        onInteractionEnd: _onInteractionEnd,
        child: Center(
          child: Image.network(
            widget.url,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const Icon(
              Icons.broken_image_outlined,
              color: Colors.white54,
              size: 48,
            ),
          ),
        ),
      ),
    );
  }
}
