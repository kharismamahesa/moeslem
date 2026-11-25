import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_chip.dart';
import '../../../../shared/widgets/app_text.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Profil')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: AppCard(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: AppColors.lime.withValues(alpha: 0.25),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person_rounded,
                        size: 46, color: AppColors.dark),
                  ),
                  const SizedBox(height: 18),
                  const AppText('Profil Pengguna', style: AppTextStyle.title),
                  const SizedBox(height: 8),
                  const AppText(
                    'Halaman ini akan segera dihubungkan dengan akun Google.',
                    align: TextAlign.center,
                    style: AppTextStyle.caption,
                  ),
                  const SizedBox(height: 14),
                  const AppChip(
                    label: 'Segera hadir',
                    icon: Icons.auto_awesome_rounded,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
