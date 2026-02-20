import 'package:flutter/material.dart';

class PetAvatar extends StatefulWidget {
  const PetAvatar({
    super.key,
    this.size = 140,
    this.mood = 'happy',
    this.hatId,
  });

  final double size;
  final String mood;
  final String? hatId;

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

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedBuilder(
            animation: _tailController,
            builder: (context, child) {
              final angle = (_tailController.value - 0.5) * 0.9;
              return Positioned(
                right: -8,
                bottom: 22,
                child: Transform.rotate(
                  angle: angle,
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    width: 34,
                    height: 10,
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
            alignment: Alignment.topLeft,
            child: Transform.rotate(
              angle: -0.3,
              child: Container(
                width: widget.size * 0.26,
                height: widget.size * 0.26,
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
                width: widget.size * 0.26,
                height: widget.size * 0.26,
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
              width: widget.size * 0.86,
              height: widget.size * 0.8,
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
                    left: widget.size * 0.24,
                    top: widget.size * 0.3,
                    child: const _Eye(),
                  ),
                  Positioned(
                    right: widget.size * 0.24,
                    top: widget.size * 0.3,
                    child: const _Eye(),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    top: widget.size * 0.44,
                    child: const Center(
                      child: Icon(Icons.circle, size: 8, color: Color(0xFF3B2E1A)),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    top: widget.size * 0.52,
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
              top: -6,
              child: Container(
                height: widget.size * 0.2,
                decoration: BoxDecoration(
                  color: const Color(0xFF2E6945),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'HAT',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
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
