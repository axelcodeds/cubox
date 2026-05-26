import 'package:flutter/material.dart';

import '../../../core/api/api_client.dart';
import '../../../core/config/app_config.dart';
import '../../../shared/widgets/algorithm_image.dart';
import '../../practice/screens/practice_screen.dart';
import '../models/algorithm.dart';

class AlgorithmDetailScreen extends StatelessWidget {
  const AlgorithmDetailScreen({
    super.key,
    required this.apiClient,
    required this.algorithm,
  });

  final ApiClient apiClient;
  final Algorithm algorithm;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(algorithm.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AlgorithmImage(imageUrl: algorithm.imageUrl, height: 180),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: Text(
                  algorithm.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Chip(label: Text(algorithm.category)),
            ],
          ),
          if (algorithm.fullNameEn != null) ...[
            const SizedBox(height: 4),
            Text(
              algorithm.fullNameEn!,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: const Color(0xFF64748B),
              ),
            ),
          ],
          const SizedBox(height: 18),
          _DetailSection(
            title: 'Algorithm',
            child: SelectableText(
              algorithm.cleanAlgorithm,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                height: 1.45,
              ),
            ),
          ),
          const SizedBox(height: 12),
          _DetailSection(
            title: 'Grouped notation',
            child: SelectableText(
              algorithm.groupedAlgorithm,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                height: 1.45,
                color: const Color(0xFF334155),
              ),
            ),
          ),
          if (algorithm.descriptionEn != null) ...[
            const SizedBox(height: 12),
            _DetailSection(
              title: 'Description',
              child: Text(algorithm.descriptionEn!),
            ),
          ],
          if (algorithm.recognitionEn != null) ...[
            const SizedBox(height: 12),
            _DetailSection(
              title: 'Recognition',
              child: Text(algorithm.recognitionEn!),
            ),
          ],
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => PracticeScreen(
                    apiClient: apiClient,
                    initialAlgorithm: algorithm,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.psychology_alt_rounded),
            label: const Text(AppStrings.practiceThisCase),
          ),
        ],
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  const _DetailSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }
}
