class AppConfig {
  static const apiBaseUrl = String.fromEnvironment(
    'CUBOX_API_BASE_URL',
    defaultValue: 'http://localhost:8000',
  );
}

class AppStrings {
  static const appName = 'Cubox';
  static const homeSubtitle = 'Learn and practice 3x3 PLL algorithms';
  static const pllAlgorithms = 'PLL Algorithms';
  static const pllAlgorithmsSubtitle = 'Browse all 21 PLL cases and notations';
  static const practiceMode = 'Practice Mode';
  static const practiceModeSubtitle = 'Recall an algorithm, reveal it, then continue';
  static const showAlgorithm = 'Show algorithm';
  static const hideAlgorithm = 'Hide algorithm';
  static const nextCase = 'Next case';
  static const practiceThisCase = 'Practice this case';
  static const noImage = 'No image';
  static const emptyAlgorithms = 'No PLL algorithms were returned.';
  static const backendUnavailable =
      'Could not reach the Cubox API. Check that the backend is running.';
}
