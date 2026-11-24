import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hiddify/doomnet/doomnet_tv_focus.dart';

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
    final activate = const {23, 66, 160, 96}.contains(keyCode);
    if (direction == null && !activate) return false;
    final manager = FocusManager.instance;
    // Fast remote presses must observe the previous pending focus request.
    manager.applyFocusChangesIfNeeded();
    final node = manager.primaryFocus;
    if (!DoomNetTvFocusZones.isControl(node)) {
      final scope = node?.nearestScope ?? manager.rootScope;
      final candidates = DoomNetTvFocusZones.controls(scope);
      if (candidates.isNotEmpty) {
        DoomNetTvFocusZones.focus(candidates.first);
      }
      return true;
    }
    final current = node!;
    final focusedContext = current.context!;
    if (direction != null) {
      final zones = focusedContext.getInheritedWidgetOfExactType<DoomNetTvFocusZones>();
      if (zones != null && zones.move(current, direction)) return true;
      if (!current.focusInDirection(direction)) {
        final next = DoomNetTvFocusZones.directional(
          current, DoomNetTvFocusZones.controls(current.nearestScope), direction,
        );
        if (next != null) DoomNetTvFocusZones.focus(next);
      }
      return true;
    }
    final editor = focusedContext.findAncestorStateOfType<EditableTextState>();
    if (editor != null) {
      editor.requestKeyboard();
    } else {
      Actions.maybeInvoke(focusedContext, const ActivateIntent());
    }
    return true;
  }

  @override
  State<DoomNetTvRemoteBridge> createState() => _DoomNetTvRemoteBridgeState();
}

class _DoomNetTvRemoteBridgeState extends State<DoomNetTvRemoteBridge> {
  bool? _lastTvViewport;
  FocusHighlightStrategy? _originalHighlightStrategy;

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
        .then((enabled) {
          if (!mounted) return;
          DoomNetTvRemoteBridge.nativeBridgeEnabled.value = enabled == true;
          if (enabled == true) {
            _originalHighlightStrategy ??= FocusManager.instance.highlightStrategy;
            FocusManager.instance.highlightStrategy = FocusHighlightStrategy.alwaysTraditional;
          }
        })
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
      if (_originalHighlightStrategy != null) {
        FocusManager.instance.highlightStrategy = _originalHighlightStrategy!;
      }
      DoomNetTvRemoteBridge._channel.invokeMethod<void>('stop').catchError((Object _) {});
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => DoomNetTvFocusOutline(
    enabled: DoomNetTvRemoteBridge.nativeBridgeEnabled,
    child: widget.child,
  );
}
