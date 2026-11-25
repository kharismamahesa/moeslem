import 'package:flutter/material.dart';

enum AppTextStyle {
  display,
  headline,
  title,
  subtitle,
  body,
  bodyMedium,
  labelLarge,
  caption,
}

class AppText extends StatelessWidget {
  const AppText(
    this.text, {
    super.key,
    this.style = AppTextStyle.body,
    this.color,
    this.weight,
    this.align = TextAlign.start,
    this.maxLines,
  });

  final String text;
  final AppTextStyle style;
  final Color? color;
  final FontWeight? weight;
  final TextAlign align;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final base = switch (style) {
      AppTextStyle.display => theme.displaySmall,
      AppTextStyle.headline => theme.headlineSmall,
      AppTextStyle.title => theme.titleLarge,
      AppTextStyle.subtitle => theme.titleMedium,
      AppTextStyle.body => theme.bodyLarge,
      AppTextStyle.bodyMedium => theme.bodyMedium,
      AppTextStyle.labelLarge => theme.labelLarge,
      AppTextStyle.caption => theme.bodySmall,
    };

    return Text(
      text,
      textAlign: align,
      maxLines: maxLines,
      overflow: maxLines == null ? null : TextOverflow.ellipsis,
      style: base?.copyWith(color: color, fontWeight: weight),
    );
  }
}
