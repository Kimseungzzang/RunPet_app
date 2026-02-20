import 'package:flutter/material.dart';
import 'package:runpet_app/models/pet_model.dart';
import 'package:runpet_app/widgets/pet_avatar.dart';
import 'package:runpet_app/widgets/runpet_card.dart';

class PetScreen extends StatelessWidget {
  const PetScreen({
    super.key,
    required this.onGoShop,
    required this.onEquipHat,
    this.pet,
    this.isBusy = false,
  });

  final VoidCallback onGoShop;
  final VoidCallback onEquipHat;
  final PetModel? pet;
  final bool isBusy;

  @override
  Widget build(BuildContext context) {
    final level = pet?.petLevel ?? 1;
    final exp = pet?.petExp ?? 0;
    final mood = pet?.petMood ?? 'happy';

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Pet customization', style: Theme.of(context).textTheme.headlineSmall),
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
          child: Center(
            child: PetAvatar(
              size: 94,
              mood: mood,
              hatId: pet?.equippedHatId,
            ),
          ),
        ),
        const SizedBox(height: 10),
        RunpetCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Level Lv.$level', style: const TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              LinearProgressIndicator(value: exp / 100, minHeight: 8),
              const SizedBox(height: 6),
              Text('EXP $exp / 100'),
              const SizedBox(height: 6),
              Text('Coins ${pet?.coinBalance ?? 0}'),
            ],
          ),
        ),
        RunpetCard(
          child: Column(
            children: [
              _ItemRow(slot: 'Hat', name: pet?.equippedHatId ?? 'None'),
              _ItemRow(slot: 'Outfit', name: pet?.equippedOutfitId ?? 'None'),
              _ItemRow(slot: 'Background', name: pet?.equippedBgId ?? 'None'),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: isBusy ? null : onEquipHat,
          child: Text(isBusy ? 'Updating...' : 'Quick equip sample hat'),
        ),
        const SizedBox(height: 8),
        FilledButton.tonal(onPressed: onGoShop, child: const Text('Open shop')),
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
