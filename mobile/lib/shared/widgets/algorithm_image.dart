import 'package:flutter/material.dart';

import '../../core/config/app_config.dart';

class AlgorithmImage extends StatelessWidget {
  const AlgorithmImage({super.key, required this.imageUrl, this.height = 104});

  final String? imageUrl;
  final double height;

  @override
  Widget build(BuildContext context) {
    final url = imageUrl?.trim();
    if (url == null || url.isEmpty) {
      return _ImagePlaceholder(height: height);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        url,
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _ImagePlaceholder(height: height),
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFE2E8F0),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_not_supported_outlined, color: Color(0xFF64748B)),
          SizedBox(height: 6),
          Text(AppStrings.noImage, style: TextStyle(color: Color(0xFF64748B))),
        ],
      ),
    );
  }
}
