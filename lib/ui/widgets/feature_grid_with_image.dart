import 'package:flutter/material.dart';
import 'package:moviles252/ui/theme/app_colors.dart';

class FeatureGridOption {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  const FeatureGridOption({
    required this.label,
    required this.icon,
    this.onTap,
  });
}

class FeatureGridWithImage extends StatelessWidget {
  const FeatureGridWithImage({
    super.key,
    required this.imageAsset,
    required this.options,
    this.height = 210,
  }) : assert(options.length >= 4, 'Se requieren al menos 4 opciones.');

  final String imageAsset;
  final List<FeatureGridOption> options;
  final double height;

  @override
  Widget build(BuildContext context) {
    final firstRow = options.take(2).toList();
    final secondRow = options.skip(2).take(2).toList();

    Widget buildRow(List<FeatureGridOption> rowOptions) {
      return Expanded(
        child: Row(
          children: rowOptions
              .map(
                (opt) => Expanded(
                  child: _FeatureOptionTile(option: opt),
                ),
              )
              .toList(),
        ),
      );
    }

    return SizedBox(
      height: height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.asset(
              imageAsset,
              width: 100,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildRow(firstRow),
                const SizedBox(height: 8),
                buildRow(secondRow),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureOptionTile extends StatelessWidget {
  const _FeatureOptionTile({required this.option});

  final FeatureGridOption option;

  @override
  Widget build(BuildContext context) {
    final tile = Container(
      height: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: AppColors.greySurface,
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white24),
              color: Colors.white.withOpacity(0.08),
            ),
            child: Icon(option.icon, color: Colors.white70, size: 16),
          ),
          const SizedBox(height: 12),
          Text(
            option.label,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );

    if (option.onTap == null) return tile;
    return InkWell(onTap: option.onTap, borderRadius: BorderRadius.circular(18), child: tile);
  }
}

