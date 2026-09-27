import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_text_style.dart';
import '../../core/constants/color_constants.dart';
import '../../core/constants/dimension_constants.dart';

class PropertyVideoPlayerView extends StatefulWidget {
  final String videoUrl;
  final String? propertyName;

  const PropertyVideoPlayerView({
    super.key,
    required this.videoUrl,
    this.propertyName,
  });

  @override
  State<PropertyVideoPlayerView> createState() =>
      _PropertyVideoPlayerViewState();
}

class _PropertyVideoPlayerViewState extends State<PropertyVideoPlayerView> {
  late VideoPlayerController _controller;
  bool _initialized = false;
  bool _hasError = false;
  bool _completed = false;
  bool _showControls = true;
  Timer? _hideControlsTimer;

  @override
  void initState() {
    super.initState();
    _enterFullscreen();
    WakelockPlus.enable();
    _initPlayer();
  }

  Future<void> _enterFullscreen() async {
    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
      overlays: [],
    );
    await SystemChrome.setPreferredOrientations(const [
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  Future<void> _exitFullscreen() async {
    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
    );
    await SystemChrome.setPreferredOrientations(const [
      DeviceOrientation.portraitUp,
    ]);
    await WakelockPlus.disable();
  }

  Future<void> _initPlayer() async {
    try {
      final uri = Uri.parse(widget.videoUrl);
      _controller = VideoPlayerController.networkUrl(
        uri,
        videoPlayerOptions: VideoPlayerOptions(
          mixWithOthers: false,
          allowBackgroundPlayback: false,
        ),
      );

      _controller.addListener(() {
        if (!mounted) return;
        if (_controller.value.hasError) {
          setState(() {
            _hasError = true;
          });
          return;
        }
        if (_controller.value.isInitialized && !_initialized) {
          setState(() {
            _initialized = true;
          });
        }
        if (_controller.value.isCompleted && !_completed) {
          setState(() {
            _completed = true;
          });
          _onVideoCompleted();
        }
      });

      await _controller.initialize();
      if (!mounted) return;
      setState(() {
        _initialized = true;
      });
      _controller.play();
      _scheduleHideControls();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _hasError = true;
      });
    }
  }

  void _onVideoCompleted() {
    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) {
        _close();
      }
    });
  }

  void _close() {
    _exitFullscreen().then((_) {
      if (Navigator.of(AppConstants.globalNavKey.currentContext!).canPop()) {
        Navigator.of(AppConstants.globalNavKey.currentContext!).pop();
      } else if (Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }
    });
  }

  void _scheduleHideControls() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && _controller.value.isPlaying) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  void _togglePlayPause() {
    if (!_initialized) return;
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _showControls = true;
        _hideControlsTimer?.cancel();
      } else {
        _controller.play();
        _scheduleHideControls();
      }
    });
  }

  void _toggleControlsVisibility() {
    setState(() {
      _showControls = !_showControls;
    });
    if (_showControls && _controller.value.isPlaying) {
      _scheduleHideControls();
    }
  }

  void _restart() {
    if (!_initialized) return;
    _controller.seekTo(Duration.zero);
    setState(() {
      _completed = false;
    });
    _controller.play();
  }

  String _formatDuration(Duration? d) {
    if (d == null) return '0:00';
    final total = d.inSeconds;
    final m = (total ~/ 60).toString().padLeft(1, '0');
    final s = (total % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  void dispose() {
    _hideControlsTimer?.cancel();
    _controller.dispose();
    _exitFullscreen();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _exitFullscreen();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: GestureDetector(
          onTap: _initialized && !_hasError ? _toggleControlsVisibility : null,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (!_hasError)
                SizedBox.expand(
                  child: Center(
                    child: _initialized
                        ? AspectRatio(
                            aspectRatio: _controller.value.aspectRatio > 0
                                ? _controller.value.aspectRatio
                                : 16 / 9,
                            child: VideoPlayer(_controller),
                          )
                        : const CircularProgressIndicator(
                            color: ColorConstants.pronexPrimary,
                            strokeWidth: 3,
                          ),
                  ),
                ),
              if (_hasError) _buildError(),
              if (_initialized && !_hasError) _buildPlaybackOverlay(),
              _buildTopBar(),
              _buildBottomControls(),
              if (_completed) _buildCompletedBadge(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return AnimatedOpacity(
      opacity: _showControls ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      child: Visibility(
        visible: _showControls,
        child: Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: kToolbarHeight + MediaQuery.of(context).padding.top,
            padding: EdgeInsets.fromLTRB(
              Dimensions.px12,
              MediaQuery.of(context).padding.top + Dimensions.px4,
              Dimensions.px12,
              Dimensions.px4,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.7),
                  Colors.black.withValues(alpha: 0),
                ],
              ),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: _close,
                  child: Container(
                    width: Dimensions.px44,
                    height: Dimensions.px44,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                      size: Dimensions.px24,
                    ),
                  ),
                ),
                const SizedBox(width: Dimensions.px12),
                Expanded(
                  child: Text(
                    widget.propertyName ?? 'Property Video',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.semiBoldText(
                      fontSize: Dimensions.px16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaybackOverlay() {
    if (_completed) {
      return GestureDetector(
        onTap: _restart,
        child: Container(
          width: Dimensions.px80,
          height: Dimensions.px80,
          decoration: BoxDecoration(
            color: ColorConstants.pronexPrimary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: ColorConstants.pronexPrimary.withValues(alpha: 0.4),
                blurRadius: Dimensions.px20,
              ),
            ],
          ),
          alignment: Alignment.center,
          child: const Icon(
            Icons.replay_rounded,
            color: Colors.white,
            size: Dimensions.px40,
          ),
        ),
      );
    }
    if (!_controller.value.isPlaying) {
      return GestureDetector(
        onTap: _togglePlayPause,
        child: Container(
          width: Dimensions.px72,
          height: Dimensions.px72,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.5),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.25),
              width: 1.5,
            ),
          ),
          alignment: Alignment.center,
          child: const Icon(
            Icons.play_arrow_rounded,
            color: Colors.white,
            size: Dimensions.px40,
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildBottomControls() {
    return AnimatedOpacity(
      opacity: _showControls ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      child: Visibility(
        visible: _showControls && _initialized && !_hasError,
        child: Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.fromLTRB(
              Dimensions.px16,
              Dimensions.px12,
              Dimensions.px16,
              Dimensions.px20,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.8),
                  Colors.black.withValues(alpha: 0),
                ],
              ),
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: _togglePlayPause,
                        child: Icon(
                          _controller.value.isPlaying
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: Dimensions.px28,
                        ),
                      ),
                      const SizedBox(width: Dimensions.px10),
                      Text(
                        _formatDuration(_controller.value.position),
                        style: AppTextStyles.regularText(
                          fontSize: Dimensions.px13,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: Dimensions.px10),
                      Expanded(
                        child: VideoProgressIndicator(
                          _controller,
                          allowScrubbing: true,
                          padding: const EdgeInsets.symmetric(
                            vertical: Dimensions.px8,
                          ),
                          colors: const VideoProgressColors(
                            playedColor: ColorConstants.pronexPrimary,
                            bufferedColor: Color.fromRGBO(185, 242, 205, 0.7),
                            backgroundColor: Color.fromRGBO(255, 255, 255, 0.25),
                          ),
                        ),
                      ),
                      const SizedBox(width: Dimensions.px10),
                      Text(
                        _formatDuration(_controller.value.duration),
                        style: AppTextStyles.regularText(
                          fontSize: Dimensions.px13,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: Dimensions.px8),
                      GestureDetector(
                        onTap: _close,
                        child: Icon(
                          Icons.fullscreen_exit_rounded,
                          color: Colors.white,
                          size: Dimensions.px24,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompletedBadge() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + kToolbarHeight,
      child: AnimatedOpacity(
        opacity: _completed ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 400),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: Dimensions.px16,
            vertical: Dimensions.px8,
          ),
          decoration: BoxDecoration(
            color: ColorConstants.pronexPrimary,
            borderRadius: BorderRadius.circular(Dimensions.px20),
            boxShadow: [
              BoxShadow(
                color: ColorConstants.pronexPrimary.withValues(alpha: 0.4),
                blurRadius: Dimensions.px12,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle_rounded,
                color: Colors.white,
                size: Dimensions.px18,
              ),
              const SizedBox(width: Dimensions.px6),
              Text(
                'Playback complete — closing…',
                style: AppTextStyles.semiBoldText(
                  fontSize: Dimensions.px13,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildError() {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.px24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: Dimensions.px72,
            height: Dimensions.px72,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.error_outline_rounded,
              color: ColorConstants.radicalRed,
              size: Dimensions.px40,
            ),
          ),
          const SizedBox(height: Dimensions.px16),
          Text(
            'Unable to play video',
            style: AppTextStyles.boldText(
              fontSize: Dimensions.px18,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: Dimensions.px8),
          Text(
            'The video URL is invalid or you are offline.',
            style: AppTextStyles.regularText(
              fontSize: Dimensions.px14,
              color: Colors.white.withValues(alpha: 0.75),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Dimensions.px24),
          GestureDetector(
            onTap: _close,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.px24,
                vertical: Dimensions.px12,
              ),
              decoration: BoxDecoration(
                color: ColorConstants.pronexPrimary,
                borderRadius: BorderRadius.circular(Dimensions.px16),
              ),
              child: Text(
                'Back',
                style: AppTextStyles.semiBoldText(
                  fontSize: Dimensions.px14,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
