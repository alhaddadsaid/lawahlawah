import '../site_adapter.dart';

abstract final class NartoDramaConfig {
  /// Fill in the site's real host(s) once the integration is agreed.
  static const List<String> domains = [];

  /// Replace with the documented agreement details. While this stays
  /// [AdapterPermission.notDocumented] the adapter cannot activate.
  static const AdapterPermission permission = AdapterPermission.notDocumented;
}
