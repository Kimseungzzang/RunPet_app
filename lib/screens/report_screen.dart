import 'package:flutter/material.dart';
import 'package:runpet_app/widgets/runpet_card.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('리포트', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        const RunpetCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('주간 요약', style: TextStyle(fontWeight: FontWeight.w700)),
              SizedBox(height: 8),
              Text('총 거리 12.4km · 러닝 4회'),
            ],
          ),
        ),
        const RunpetCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('최고 기록', style: TextStyle(fontWeight: FontWeight.w700)),
              SizedBox(height: 8),
              Text('최고 페이스 4\'58"'),
            ],
          ),
        ),
      ],
    );
  }
}

