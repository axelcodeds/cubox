import 'package:flutter/material.dart';

import '../../../core/api/api_client.dart';
import '../../../core/config/app_config.dart';
import '../../../shared/widgets/algorithm_image.dart';
import '../../../shared/widgets/error_state.dart';
import '../../../shared/widgets/loading_state.dart';
import '../../algorithms/models/algorithm.dart';

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({
    super.key,
    required this.apiClient,
    this.initialAlgorithm,
  });

  final ApiClient apiClient;
  final Algorithm? initialAlgorithm;

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  Algorithm? _currentAlgorithm;
  bool _showAlgorithm = false;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _currentAlgorithm = widget.initialAlgorithm;
    if (_currentAlgorithm == null) {
      _loadNextCase();
    }
  }

  Future<void> _loadNextCase() async {
    setState(() {
      _isLoading = true;
      _showAlgorithm = false;
      _errorMessage = null;
    });

    try {
      final algorithm = await widget.apiClient.fetchRandomPllCase();
      if (!mounted) {
        return;
      }
      setState(() {
        _currentAlgorithm = algorithm;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoading = false;
        _errorMessage = AppStrings.backendUnavailable;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.practiceMode)),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_isLoading && _currentAlgorithm == null) {
      return const LoadingState();
    }

    if (_errorMessage != null && _currentAlgorithm == null) {
      return ErrorState(message: _errorMessage, onRetry: _loadNextCase);
    }

    final algorithm = _currentAlgorithm;
    if (algorithm == null) {
      return const Center(child: Text(AppStrings.emptyAlgorithms));
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        AlgorithmImage(imageUrl: algorithm.imageUrl, height: 180),
        const SizedBox(height: 18),
        Text(
          algorithm.name,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 6),
        Text(
          'Try to recall the algorithm before revealing the answer.',
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: const Color(0xFF64748B)),
        ),
        const SizedBox(height: 18),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: _showAlgorithm
              ? _AlgorithmAnswer(algorithm: algorithm)
              : const _HiddenAlgorithmCard(),
        ),
        if (_errorMessage != null) ...[
          const SizedBox(height: 12),
          Text(
            _errorMessage!,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ],
        const SizedBox(height: 20),
        FilledButton.icon(
          onPressed: () {
            setState(() {
              _showAlgorithm = !_showAlgorithm;
            });
          },
          icon: Icon(
            _showAlgorithm
                ? Icons.visibility_off_rounded
                : Icons.visibility_rounded,
          ),
          label: Text(
            _showAlgorithm
                ? AppStrings.hideAlgorithm
                : AppStrings.showAlgorithm,
          ),
        ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: _isLoading ? null : _loadNextCase,
          icon: _isLoading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.skip_next_rounded),
          label: const Text(AppStrings.nextCase),
        ),
      ],
    );
  }
}

class _HiddenAlgorithmCard extends StatelessWidget {
  const _HiddenAlgorithmCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      key: const ValueKey('hidden'),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Icon(
              Icons.lock_outline_rounded,
              size: 36,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 10),
            const Text(
              'Algorithm hidden',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

class _AlgorithmAnswer extends StatelessWidget {
  const _AlgorithmAnswer({required this.algorithm});

  final Algorithm algorithm;

  @override
  Widget build(BuildContext context) {
    return Card(
      key: const ValueKey('answer'),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Answer',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            SelectableText(
              algorithm.cleanAlgorithm,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              algorithm.groupedAlgorithm,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF64748B),
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
