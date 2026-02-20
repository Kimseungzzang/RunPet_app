import 'package:flutter/material.dart';
import 'package:runpet_app/theme/app_theme.dart';
import 'package:runpet_app/widgets/runpet_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.onRunStart,
    required this.onGoPet,
  });

  final VoidCallback onRunStart;
  final VoidCallback onGoPet;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('오늘도 달려볼까요?', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        Container(
          height: 128,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFC8EFBA), Color(0xFF89D8AA)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.line),
          ),
          child: const Center(
            child: Icon(Icons.pets, color: AppTheme.leaf, size: 48),
          ),
        ),
        const SizedBox(height: 12),
        const RunpetCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CardHeader(title: '오늘 목표', rightText: '3.0 km'),
              SizedBox(height: 8),
              Text('현재 1.4km 완료'),
              SizedBox(height: 8),
              LinearProgressIndicator(value: 0.46, minHeight: 8),
            ],
          ),
        ),
        const RunpetCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CardHeader(title: '펫 상태', rightText: 'Lv.7'),
              SizedBox(height: 8),
              Text('기분 좋음 · 에너지 82%'),
            ],
          ),
        ),
        ElevatedButton(onPressed: onRunStart, child: const Text('러닝 시작')),
        const SizedBox(height: 10),
        OutlinedButton(onPressed: onGoPet, child: const Text('펫 화면 가기')),
      ],
    );
  }
}

class _CardHeader extends StatelessWidget {
  const _CardHeader({required this.title, required this.rightText});
  final String title;
  final String rightText;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.mint.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(rightText, style: const TextStyle(fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }
}

