import 'package:flutter/material.dart';
import 'package:runpet_app/widgets/runpet_card.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Report', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        const RunpetCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Weekly summary', style: TextStyle(fontWeight: FontWeight.w700)),
              SizedBox(height: 8),
              Text('Total distance 12.4km • Runs 4'),
            ],
          ),
        ),
        const RunpetCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Best record', style: TextStyle(fontWeight: FontWeight.w700)),
              SizedBox(height: 8),
              Text('Best pace 4\'58"'),
            ],
          ),
        ),
      ],
    );
  }
}
