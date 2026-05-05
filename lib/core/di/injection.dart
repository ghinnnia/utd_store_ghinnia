import 'package:get_it/get_it.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../data/services/dio_client.dart';
import '../../data/services/bookmark_service.dart';
import '../../data/services/websocket_service.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../../domain/usecases/get_splash_delay_usecase.dart';
import '../../domain/usecases/calculate_tax_usecase.dart';
import '../../presentation/cubit/product_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Register BookmarkService
  final bookmarkService = BookmarkService();
  await bookmarkService.init();
  sl.registerSingleton<BookmarkService>(bookmarkService);

  // Register DioClient
  sl.registerLazySingleton(() => DioClient());

  // Register WebSocketService
  sl.registerLazySingleton(() => WebSocketService());

  // Register ProductRepository with dependency
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(dioClient: sl()),
  );

  // Register Usecases
  sl.registerLazySingleton(() => GetProductsUseCase(sl()));
  sl.registerLazySingleton(() => GetSplashDelayUseCase());
  sl.registerLazySingleton(() => CalculateTaxUseCase());

  // Register Cubit
  sl.registerFactory(() => ProductCubit(sl()));
}