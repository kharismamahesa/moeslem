import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../../../shared/widgets/app_text_field.dart';

class CitySearchDialog extends StatefulWidget {
  const CitySearchDialog({super.key, this.initialCity});

  final String? initialCity;

  static Future<String?> show(BuildContext context, {String? initialCity}) =>
      showDialog<String>(
        context: context,
        builder: (_) => CitySearchDialog(initialCity: initialCity),
      );

  @override
  State<CitySearchDialog> createState() => _CitySearchDialogState();
}

class _CitySearchDialogState extends State<CitySearchDialog> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initialCity ?? '';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final city = _controller.text.trim();
    Navigator.of(context).pop(city.isEmpty ? null : city);
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const AppText('Cari kota', style: AppTextStyle.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AppText(
              'Contoh: Bandung, Pekanbaru',
              style: AppTextStyle.caption,
              color: AppColors.muted,
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: _controller,
              hint: 'Nama kota',
              prefixIcon: Icons.search_rounded,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _submit(),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
            child: Row(
              children: [
                Expanded(
                  child: AppButton(
                    'Batal',
                    variant: AppButtonVariant.outlined,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: AppButton(
                    'Cari',
                    icon: Icons.search_rounded,
                    onPressed: _submit,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
}
