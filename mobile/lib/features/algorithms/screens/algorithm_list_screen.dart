import 'package:flutter/material.dart';

import '../../../core/api/api_client.dart';
import '../../../core/config/app_config.dart';
import '../../../shared/widgets/algorithm_image.dart';
import '../../../shared/widgets/error_state.dart';
import '../../../shared/widgets/loading_state.dart';
import '../models/algorithm.dart';
import 'algorithm_detail_screen.dart';

class AlgorithmListScreen extends StatefulWidget {
  const AlgorithmListScreen({super.key, required this.apiClient});

  final ApiClient apiClient;

  @override
  State<AlgorithmListScreen> createState() => _AlgorithmListScreenState();
}

class _AlgorithmListScreenState extends State<AlgorithmListScreen> {
  late Future<List<Algorithm>> _algorithmsFuture;

  @override
  void initState() {
    super.initState();
    _algorithmsFuture = widget.apiClient.fetchPllAlgorithms();
  }

  void _reload() {
    setState(() {
      _algorithmsFuture = widget.apiClient.fetchPllAlgorithms();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.pllAlgorithms)),
      body: FutureBuilder<List<Algorithm>>(
        future: _algorithmsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingState();
          }

          if (snapshot.hasError) {
            return ErrorState(onRetry: _reload);
          }

          final algorithms = snapshot.data ?? const <Algorithm>[];
          if (algorithms.isEmpty) {
            return const _EmptyAlgorithmsState();
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: algorithms.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final algorithm = algorithms[index];
              return _AlgorithmCard(
                algorithm: algorithm,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => AlgorithmDetailScreen(
                        apiClient: widget.apiClient,
                        algorithm: algorithm,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _AlgorithmCard extends StatelessWidget {
  const _AlgorithmCard({required this.algorithm, required this.onTap});

  final Algorithm algorithm;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 92,
                child: AlgorithmImage(imageUrl: algorithm.imageUrl, height: 92),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            algorithm.name,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                        ),
                        _CategoryPill(label: algorithm.category),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      algorithm.groupedAlgorithm,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        height: 1.35,
                        color: const Color(0xFF334155),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryPill extends StatelessWidget {
  const _CategoryPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Theme.of(context).colorScheme.onSecondaryContainer,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _EmptyAlgorithmsState extends StatelessWidget {
  const _EmptyAlgorithmsState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text(AppStrings.emptyAlgorithms, textAlign: TextAlign.center),
      ),
    );
  }
}
