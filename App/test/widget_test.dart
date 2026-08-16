import 'package:flutter_test/flutter_test.dart';

import 'package:app/core/theme/app_theme.dart';

void main() {
  test('app theme uses the shared HabitCloud primary blue', () {
    final theme = buildAppTheme();
    expect(theme.colorScheme.primary, AppColors.primaryBlue);
  });
}
