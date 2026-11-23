import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Receives Android TV hardware D-pad events directly from MainActivity.
///
/// Some TV firmware reports key events at the Activity level but doesn't
/// focus Flutter's navigation rail. The Activity sends each key-down here and
/// consumes the original event to avoid performing the action twice. No
/// change to VPN startup, lifecycle, connection, or application settings.
class DoomNetTvRemoteBridge extends StatefulWidget {
  const DoomNetTvRemoteBridge({super.key, required this.child});

  final Widget child;

  static const channelName = 'com.forzeus.doomnet/tv_remote';
  static const _channel = MethodChannel(channelName);

  /// Debugging aid for the TV About page; never stores or transmits key data.
  static final ValueNotifier<int?> lastNativeKeyCode = ValueNotifier<int?>(null);
  static final ValueNotifier<bool> nativeBridgeEnabled = ValueNotifier<bool>(false);

  // Android KeyEvent.KEYCODE_DPAD_*, ENTER and gamepad A.
  @visibleForTesting
  static bool handleAndroidKey(BuildContext context, int keyCode) {
    final direction = switch (keyCode) {
      19 => TraversalDirection.up,
      20 => TraversalDirection.down,
      21 => TraversalDirection.left,
      22 => TraversalDirection.right,
      _ => null,
    };
    if (direction != null) {
      final node = FocusManager.instance.primaryFocus;
      if (node != null && node.context != null) {
        node.focusInDirection(direction);
      } else {
        // First press, or route/dialog just replaced its last focus node.
        FocusScope.of(context).nextFocus();
      }
      return true;
    }
    if (const {23, 66, 160, 96}.contains(keyCode)) {
      final focusedContext = FocusManager.instance.primaryFocus?.context;
      if (focusedContext != null) {
        Actions.maybeInvoke(focusedContext, const ActivateIntent());
      } else {
        FocusScope.of(context).nextFocus();
      }
      return true;
    }
    return false;
  }

  @override
  State<DoomNetTvRemoteBridge> createState() => _DoomNetTvRemoteBridgeState();
}

class _DoomNetTvRemoteBridgeState extends State<DoomNetTvRemoteBridge> {
  bool? _lastTvViewport;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb && Platform.isAndroid) {
      DoomNetTvRemoteBridge._channel.setMethodCallHandler(_onPlatformCall);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (kIsWeb || !Platform.isAndroid) return;
    // TV vendors may omit FEATURE_LEANBACK; our wide Flutter layout is
    // independent confirmation that this is the TV application surface.
    final wideScreen = MediaQuery.sizeOf(context).width >= 700;
    if (_lastTvViewport == wideScreen) return;
    _lastTvViewport = wideScreen;
    DoomNetTvRemoteBridge._channel
        .invokeMethod<bool>('start', wideScreen)
        .then((enabled) => DoomNetTvRemoteBridge.nativeBridgeEnabled.value = enabled == true)
        .catchError((Object _) {});
  }

  Future<void> _onPlatformCall(MethodCall call) async {
    if (!mounted || call.method != 'key' || call.arguments is! int) return;
    final keyCode = call.arguments as int;
    DoomNetTvRemoteBridge.lastNativeKeyCode.value = keyCode;
    DoomNetTvRemoteBridge.handleAndroidKey(context, keyCode);
  }

  @override
  void dispose() {
    if (!kIsWeb && Platform.isAndroid) {
      DoomNetTvRemoteBridge._channel.setMethodCallHandler(null);
      DoomNetTvRemoteBridge.nativeBridgeEnabled.value = false;
      DoomNetTvRemoteBridge._channel.invokeMethod<void>('stop').catchError((Object _) {});
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
