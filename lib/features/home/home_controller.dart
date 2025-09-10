import 'package:flutter_application_1/common/widgets/ArtistSection.dart';
import 'package:flutter_application_1/features/home/home_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeServicesProvider = Provider((ref) => HomeServices());

final artistProvider = FutureProvider<List<Artist>>((ref) async {
  final homeServices = ref.watch(homeServicesProvider);
  return await homeServices.getArtists();
});
