import 'package:flutter/material.dart';

import '../../data/models/collection.dart';
import '../theme/app_colors.dart';

/// Extensions on [Collection] for UI convenience.
extension CollectionColorX on Collection {
  /// Resolves the stored color key to a [Color].
  Color get resolvedColor =>
      AppColors.templateColors[color] ?? AppColors.blue;
}
