import 'package:flutter/material.dart';
import 'package:runpet_app/config/app_config.dart';

class PetAvatar extends StatefulWidget {
  const PetAvatar({
    super.key,
    this.size = 140,
    this.mood = 'happy',
    this.hatId,
    this.outfitId,
    this.bgId,
  });

  final double size;
  final String mood;
  final String? hatId;
  final String? outfitId;
  final String? bgId;

  @override
  State<PetAvatar> createState() => _PetAvatarState();
}

class _PetAvatarState extends State<PetAvatar> with SingleTickerProviderStateMixin {
  late final AnimationController _tailController;

  @override
  void initState() {
    super.initState();
    _tailController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _tailController.forward().then((_) {
      if (mounted) {
        _tailController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _tailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final use3D = AppConfig.enable3DPet && widget.size >= 80;
    if (use3D) {
      return _PetAvatar3D(
        size: widget.size,
        mood: widget.mood,
        hatId: widget.hatId,
        outfitId: widget.outfitId,
        bgId: widget.bgId,
      );
    }

    final mood = widget.mood.toLowerCase();
    final isTired = mood == 'tired';
    final isSad = mood == 'sad';
    final faceColor = isTired
        ? const Color(0xFFECCF9A)
        : (isSad ? const Color(0xFFF1D4B5) : const Color(0xFFF7DCA9));
    final earColor = isTired
        ? const Color(0xFFD5B37A)
        : (isSad ? const Color(0xFFE2BC92) : const Color(0xFFE9C186));
    final mouth = isTired ? '-' : (isSad ? 'n' : 'u');

    final bgGradient = _backgroundGradient(widget.bgId);
    final outfitColor = _outfitColor(widget.outfitId);
    final hatColor = _hatColor(widget.hatId);

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: bgGradient,
          borderRadius: BorderRadius.circular(widget.size * 0.18),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            AnimatedBuilder(
              animation: _tailController,
              builder: (context, child) {
                final angle = (_tailController.value - 0.5) * 0.9;
                return Positioned(
                  right: widget.size * 0.04,
                  bottom: widget.size * 0.2,
                  child: Transform.rotate(
                    angle: angle,
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      width: widget.size * 0.26,
                      height: widget.size * 0.08,
                      decoration: BoxDecoration(
                        color: earColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                );
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: widget.size * 0.62,
                height: widget.size * 0.36,
                decoration: BoxDecoration(
                  color: outfitColor,
                  borderRadius: BorderRadius.circular(widget.size * 0.22),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Transform.rotate(
                angle: -0.3,
                child: Container(
                  width: widget.size * 0.2,
                  height: widget.size * 0.2,
                  decoration: BoxDecoration(
                    color: earColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Transform.rotate(
                angle: 0.3,
                child: Container(
                  width: widget.size * 0.2,
                  height: widget.size * 0.2,
                  decoration: BoxDecoration(
                    color: earColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                width: widget.size * 0.76,
                height: widget.size * 0.7,
                decoration: BoxDecoration(
                  color: faceColor,
                  shape: BoxShape.circle,
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x22000000),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: widget.size * 0.22,
                      top: widget.size * 0.27,
                      child: const _Eye(),
                    ),
                    Positioned(
                      right: widget.size * 0.22,
                      top: widget.size * 0.27,
                      child: const _Eye(),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      top: widget.size * 0.4,
                      child: const Center(
                        child: Icon(Icons.circle, size: 8, color: Color(0xFF3B2E1A)),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      top: widget.size * 0.48,
                      child: Center(
                        child: Text(
                          mouth,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF3B2E1A),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (widget.hatId != null && widget.hatId!.isNotEmpty)
              Positioned(
                left: widget.size * 0.2,
                right: widget.size * 0.2,
                top: widget.size * 0.04,
                child: Container(
                  height: widget.size * 0.16,
                  decoration: BoxDecoration(
                    color: hatColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  LinearGradient _backgroundGradient(String? bgId) {
    if (bgId == 'background_city_night') {
      return const LinearGradient(
        colors: [Color(0xFF2A355C), Color(0xFF121A33)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    }
    if (bgId == 'background_park_day') {
      return const LinearGradient(
        colors: [Color(0xFFC8EFBA), Color(0xFF89D8AA)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    }
    return const LinearGradient(
      colors: [Color(0xFFE5F4FF), Color(0xFFCBE8FF)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
  }

  Color _outfitColor(String? outfitId) {
    if (outfitId == 'outfit_runner_red') {
      return const Color(0xFFD95C5C);
    }
    if (outfitId == 'outfit_runner_blue') {
      return const Color(0xFF4B79D1);
    }
    return const Color(0xFFE5E7EB);
  }

  Color _hatColor(String? hatId) {
    if (hatId == 'hat_sport_band') {
      return const Color(0xFF2B2B2B);
    }
    return const Color(0xFF2E6945);
  }
}

class _PetAvatar3D extends StatelessWidget {
  const _PetAvatar3D({
    required this.size,
    required this.mood,
    required this.hatId,
    required this.outfitId,
    required this.bgId,
  });

  final double size;
  final String mood;
  final String? hatId;
  final String? outfitId;
  final String? bgId;

  @override
  Widget build(BuildContext context) {
    final bgGradient = _backgroundGradient(bgId);
    final tilt = _tiltForMood(mood);
    return SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: bgGradient,
          borderRadius: BorderRadius.circular(size * 0.18),
        ),
        child: Stack(
          children: [
            Positioned(
              left: size * 0.2,
              right: size * 0.2,
              bottom: size * 0.08,
              child: Container(
                height: size * 0.08,
                decoration: BoxDecoration(
                  color: const Color(0x30000000),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            Center(
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.0012)
                  ..rotateX(tilt)
                  ..rotateY(tilt * 0.6),
                child: _Pseudo3DBody(
                  size: size * 0.82,
                  hatId: hatId,
                  outfitId: outfitId,
                ),
              ),
            ),
            if ((hatId ?? '').isNotEmpty || (outfitId ?? '').isNotEmpty)
              Positioned(
                left: 8,
                right: 8,
                bottom: 8,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: const Color(0xAA111827),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Text(
                      'H:${hatId ?? "-"} / O:${outfitId ?? "-"}',
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  LinearGradient _backgroundGradient(String? bgId) {
    if (bgId == 'background_city_night') {
      return const LinearGradient(
        colors: [Color(0xFF2A355C), Color(0xFF121A33)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    }
    if (bgId == 'background_park_day') {
      return const LinearGradient(
        colors: [Color(0xFFC8EFBA), Color(0xFF89D8AA)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    }
    return const LinearGradient(
      colors: [Color(0xFFE5F4FF), Color(0xFFCBE8FF)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
  }

  double _tiltForMood(String moodValue) {
    final normalized = moodValue.toLowerCase();
    if (normalized == 'tired') {
      return -0.18;
    }
    if (normalized == 'sad') {
      return 0.05;
    }
    return 0.22;
  }
}

class _Pseudo3DBody extends StatelessWidget {
  const _Pseudo3DBody({
    required this.size,
    required this.hatId,
    required this.outfitId,
  });

  final double size;
  final String? hatId;
  final String? outfitId;

  @override
  Widget build(BuildContext context) {
    final outfitColor = _outfitColor(outfitId);
    final hatColor = _hatColor(hatId);
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: size * 0.18,
            right: size * 0.18,
            bottom: size * 0.04,
            child: Container(
              height: size * 0.28,
              decoration: BoxDecoration(
                color: outfitColor,
                borderRadius: BorderRadius.circular(size * 0.2),
              ),
            ),
          ),
          Positioned(
            left: size * 0.12,
            right: size * 0.12,
            top: size * 0.12,
            bottom: size * 0.18,
            child: DecoratedBox(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFFF9E8C0), Color(0xFFE7C88F)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          if ((hatId ?? '').isNotEmpty)
            Positioned(
              left: size * 0.23,
              right: size * 0.23,
              top: size * 0.02,
              child: Container(
                height: size * 0.12,
                decoration: BoxDecoration(
                  color: hatColor,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Color _outfitColor(String? id) {
    if (id == 'outfit_runner_red') return const Color(0xFFD95C5C);
    if (id == 'outfit_runner_blue') return const Color(0xFF4B79D1);
    return const Color(0xFFE5E7EB);
  }

  Color _hatColor(String? id) {
    if (id == 'hat_sport_band') return const Color(0xFF2B2B2B);
    return const Color(0xFF2E6945);
  }
}

class _Eye extends StatelessWidget {
  const _Eye();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 10,
      decoration: BoxDecoration(
        color: const Color(0xFF2A251C),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
