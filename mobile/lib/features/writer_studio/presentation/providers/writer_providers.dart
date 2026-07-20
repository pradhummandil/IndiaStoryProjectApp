import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/providers.dart';
import '../../domain/models/writer_dashboard_models.dart';

/// Fetches the Writer Studio dashboard data from the backend API.
final writerDashboardProvider = FutureProvider<WriterDashboardResponse>((
  ref,
) async {
  final repo = ref.watch(writerRepositoryProvider);
  return repo.getDashboard();
});
