import 'package:flutter/material.dart';
import 'package:runpet_app/widgets/runpet_card.dart';

class PetScreen extends StatelessWidget {
  const PetScreen({super.key, required this.onGoShop});

  final VoidCallback onGoShop;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('펫 꾸미기', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        Container(
          height: 128,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: const LinearGradient(
              colors: [Color(0xFFC8EFBA), Color(0xFF89D8AA)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: const Center(child: Icon(Icons.pets, size: 48)),
        ),
        const SizedBox(height: 10),
        const RunpetCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('레벨 Lv.7', style: TextStyle(fontWeight: FontWeight.w700)),
              SizedBox(height: 8),
              LinearProgressIndicator(value: 0.62, minHeight: 8),
              SizedBox(height: 6),
              Text('다음 레벨까지 38%'),
            ],
          ),
        ),
        const RunpetCard(
          child: Column(
            children: [
              _ItemRow(slot: '모자', name: '리프 캡'),
              _ItemRow(slot: '의상', name: '러너 셋업'),
              _ItemRow(slot: '배경', name: '공원 오전'),
            ],
          ),
        ),
        ElevatedButton(onPressed: onGoShop, child: const Text('상점 가기')),
      ],
    );
  }
}

class _ItemRow extends StatelessWidget {
  const _ItemRow({required this.slot, required this.name});
  final String slot;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(slot),
          const Spacer(),
          Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

