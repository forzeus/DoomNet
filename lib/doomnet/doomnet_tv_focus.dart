import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Explicit focus boundaries for the two-pane television layout.
class DoomNetTvFocusZones extends InheritedWidget {
  const DoomNetTvFocusZones({
    super.key,
    required this.rail,
    required this.content,
    required super.child,
  });

  final FocusScopeNode rail;
  final FocusScopeNode content;

  static Rect? bounds(FocusNode? node) {
    final context = node?.context;
    if (context == null || !context.mounted) return null;
    final box = context.findRenderObject();
    if (box is! RenderBox || !box.attached || !box.hasSize || box.size.isEmpty) return null;
    RenderObject? ancestor = box;
    while (ancestor != null) {
      if (ancestor is RenderOffstage && ancestor.offstage) return null;
      final parent = ancestor.parent;
      ancestor = parent is RenderObject ? parent : null;
    }
    final rect = MatrixUtils.transformRect(box.getTransformTo(null), Offset.zero & box.size);
    return rect.isFinite && !rect.isEmpty ? rect : null;
  }

  static bool isControl(FocusNode? node) {
    if (node == null || node is FocusScopeNode || !node.canRequestFocus || node.skipTraversal) return false;
    return bounds(node) != null;
  }

  static List<FocusNode> controls(FocusScopeNode? scope) {
    return scope?.traversalDescendants.where(isControl).toList() ?? <FocusNode>[];
  }

  static void focus(FocusNode node) {
    node.requestFocus();
    final context = node.context;
    if (context != null && context.mounted) {
      Scrollable.ensureVisible(context, alignment: .5, duration: Duration.zero);
    }
  }

  static FocusNode? directional(FocusNode from, Iterable<FocusNode> candidates, TraversalDirection direction) {
    final a = bounds(from);
    if (a == null) return null;
    FocusNode? best;
    var bestScore = double.infinity;
    final horizontal = direction == TraversalDirection.left || direction == TraversalDirection.right;
    final sign = direction == TraversalDirection.left || direction == TraversalDirection.up ? -1 : 1;
    for (final candidate in candidates) {
      if (identical(candidate, from)) continue;
      final b = bounds(candidate);
      if (b == null) continue;
      final delta = b.center - a.center;
      final primary = (horizontal ? delta.dx : delta.dy) * sign;
      if (primary <= 1) continue;
      final secondary = (horizontal ? delta.dy : delta.dx).abs();
      final overlap = horizontal
          ? b.bottom > a.top && b.top < a.bottom
          : b.right > a.left && b.left < a.right;
      final score = primary + secondary * (overlap ? .45 : 2.5);
      if (score < bestScore) {
        best = candidate;
        bestScore = score;
      }
    }
    return best;
  }

  bool move(FocusNode from, TraversalDirection direction) {
    final inRail = rail.descendants.contains(from);
    final inContent = content.descendants.contains(from);
    if (!inRail && !inContent) return false;
    if (inRail) {
      if (direction == TraversalDirection.right) {
        final candidates = controls(content);
        if (candidates.isNotEmpty) {
          focus(directional(from, candidates, direction) ?? candidates.first);
        }
      } else if (direction == TraversalDirection.up || direction == TraversalDirection.down) {
        final next = directional(from, controls(rail), direction);
        if (next != null) focus(next);
      }
      // At a rail boundary retain the currently visible selection.
      return true;
    }

    final next = directional(from, controls(content), direction);
    if (next != null) {
      focus(next);
    } else if (direction == TraversalDirection.left) {
      final previous = rail.focusedChild;
      final candidates = controls(rail);
      if (previous != null && candidates.contains(previous)) {
        focus(previous);
      } else if (candidates.isNotEmpty) {
        focus(directional(from, candidates, direction) ?? candidates.first);
      }
    }
    return true;
  }

  @override
  bool updateShouldNotify(DoomNetTvFocusZones oldWidget) => rail != oldWidget.rail || content != oldWidget.content;
}

/// A single inexpensive high-contrast focus border, painted over any page,
/// including dialogs. Independent of individual Material control themes.
class DoomNetTvFocusOutline extends StatefulWidget {
  const DoomNetTvFocusOutline({super.key, required this.enabled, required this.child});
  final ValueNotifier<bool> enabled;
  final Widget child;

  @override
  State<DoomNetTvFocusOutline> createState() => _DoomNetTvFocusOutlineState();
}

class _DoomNetTvFocusOutlineState extends State<DoomNetTvFocusOutline> {
  final _scroll = ValueNotifier<int>(0);

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => NotificationListener<ScrollNotification>(
    onNotification: (_) {
      _scroll.value++;
      return false;
    },
    child: CustomPaint(
      foregroundPainter: _FocusOutlinePainter(context, widget.enabled, _scroll),
      child: widget.child,
    ),
  );
}

class _FocusOutlinePainter extends CustomPainter {
  _FocusOutlinePainter(this.context, this.enabled, Listenable scroll)
    : super(repaint: Listenable.merge([FocusManager.instance, enabled, scroll]));

  final BuildContext context;
  final ValueNotifier<bool> enabled;

  @override
  void paint(Canvas canvas, Size size) {
    if (!enabled.value) return;
    final focused = FocusManager.instance.primaryFocus;
    if (!DoomNetTvFocusZones.isControl(focused)) return;
    final rect = DoomNetTvFocusZones.bounds(focused);
    final origin = context.findRenderObject();
    if (rect == null || origin is! RenderBox || !origin.attached) return;
    final local = Rect.fromPoints(origin.globalToLocal(rect.topLeft), origin.globalToLocal(rect.bottomRight));
    final visible = local.intersect(Offset.zero & size);
    if (visible.isEmpty || !visible.isFinite) return;
    final border = RRect.fromRectAndRadius(visible.deflate(2), const Radius.circular(9));
    canvas.drawRRect(border, Paint()
      ..color = const Color(0xCC00150B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5);
    canvas.drawRRect(border, Paint()
      ..color = const Color(0xFF81FFC0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5);
  }

  @override
  bool shouldRepaint(covariant _FocusOutlinePainter oldDelegate) => true;
}
