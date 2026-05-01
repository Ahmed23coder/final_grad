import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// A circular avatar that shows the user's network image when available, or
/// falls back to a colored gradient circle with the user's initials.
///
/// Drop-in replacement for the previous `AssetImage('placeholder_avatar.png')`
/// which referenced a non-existent asset.
class AvatarFallback extends StatelessWidget {
  /// Optional remote image URL. Empty/null falls back to initials.
  final String? avatarUrl;

  /// Display name used to derive initials. Falls back to a single dot if blank.
  final String name;

  /// Diameter in logical pixels.
  final double size;

  /// Optional border color drawn around the circle.
  final Color? borderColor;

  /// Border width (only applied when [borderColor] is non-null).
  final double borderWidth;

  const AvatarFallback({
    super.key,
    required this.name,
    this.avatarUrl,
    this.size = 80,
    this.borderColor,
    this.borderWidth = 2,
  });

  String get _initials {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return '·';
    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length == 1) {
      final s = parts.first;
      return s.substring(0, s.length >= 2 ? 2 : 1).toUpperCase();
    }
    final first = parts.first.isNotEmpty ? parts.first[0] : '';
    final last = parts.last.isNotEmpty ? parts.last[0] : '';
    return (first + last).toUpperCase();
  }

  // Pick a stable gradient based on the name's hash so the same user keeps the
  // same color across sessions.
  List<Color> get _gradient {
    final palette = <List<Color>>[
      [const Color(0xFF6366F1), const Color(0xFF8B5CF6)], // indigo → violet
      [const Color(0xFF0EA5E9), const Color(0xFF22D3EE)], // sky → cyan
      [const Color(0xFF10B981), const Color(0xFF34D399)], // emerald
      [const Color(0xFFF59E0B), const Color(0xFFFB923C)], // amber → orange
      [const Color(0xFFEC4899), const Color(0xFFF472B6)], // pink
      [const Color(0xFF14B8A6), const Color(0xFF22D3EE)], // teal → cyan
    ];
    final seed = name.isEmpty ? 0 : name.codeUnits.fold<int>(0, (a, b) => a + b);
    return palette[seed % palette.length];
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = (avatarUrl ?? '').isNotEmpty;
    final initials = _initials;
    final gradient = _gradient;

    final inner = hasImage
        ? CachedNetworkImage(
            imageUrl: avatarUrl!,
            fit: BoxFit.cover,
            width: size,
            height: size,
            placeholder: (_, __) => _initialsCircle(initials, gradient),
            errorWidget: (_, __, ___) => _initialsCircle(initials, gradient),
          )
        : _initialsCircle(initials, gradient);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: borderColor != null
            ? Border.all(color: borderColor!, width: borderWidth)
            : null,
      ),
      child: ClipOval(child: inner),
    );
  }

  Widget _initialsCircle(String initials, List<Color> gradient) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: TextStyle(
          color: Colors.white,
          fontSize: size * 0.36,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
