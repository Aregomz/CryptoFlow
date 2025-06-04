import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'core/network/network_info.dart';
import 'features/cryptocurrency/data/datasources/cryptocurrency_remote_data_source.dart';
import 'features/cryptocurrency/data/repositories/cryptocurrency_repository_impl.dart';
import 'features/cryptocurrency/domain/repositories/cryptocurrency_repository.dart';
import 'features/cryptocurrency/presentation/bloc/cryptocurrency_bloc.dart';
import 'features/cryptocurrency/presentation/pages/home_page.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // Core
  getIt.registerLazySingleton(() => Dio());
  getIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(InternetConnectionChecker()),
  );

  // Data sources
  getIt.registerLazySingleton<CryptocurrencyRemoteDataSource>(
    () => CryptocurrencyRemoteDataSourceImpl(dio: getIt()),
  );

  // Repositories
  getIt.registerLazySingleton<CryptocurrencyRepository>(
    () => CryptocurrencyRepositoryImpl(
      remoteDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );

  // BLoCs
  getIt.registerFactory(
    () => CryptocurrencyBloc(repository: getIt()),
  );
}

void main() {
  setupDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CryptoFlow',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      home: BlocProvider(
        create: (context) => getIt<CryptocurrencyBloc>(),
        child: const HomePage(),
      ),
    );
  }
}
