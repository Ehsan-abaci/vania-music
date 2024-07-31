import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vania_music/config/theme/bloc/theme_bloc.dart';
import 'package:vania_music/core/resources/network_info.dart';
import 'package:vania_music/features/favorite/data/data_source/local/favorite_music_cache.dart';
import 'package:vania_music/features/favorite/data/repository/favorite_music_repositoryImpl.dart';
import 'package:vania_music/features/favorite/domain/repository/favorite_music_repository.dart';
import 'package:vania_music/features/favorite/domain/usecase/add_favorite_music_usecase.dart';
import 'package:vania_music/features/favorite/domain/usecase/get_favorite_music_usecase.dart';
import 'package:vania_music/features/favorite/domain/usecase/remove_favorite_music_usecase.dart';
import 'package:vania_music/features/favorite/presentation/bloc/favorite/favorite_bloc.dart';
import 'package:vania_music/features/file_manager/data/repository/file_manager_repositoryImpl.dart';
import 'package:vania_music/features/file_manager/data/repository/file_storage_manager_repositoryImpl.dart';
import 'package:vania_music/features/file_manager/domain/repository/file_manager_repository.dart';
import 'package:vania_music/features/file_manager/domain/repository/file_storage_manager_repository.dart';
import 'package:vania_music/features/file_manager/presentation/value_notifier/download_file.dart';
import 'package:vania_music/features/music/data/data_source/local/music_cache.dart';
import 'package:vania_music/features/music/data/data_source/remote/music_api_provider.dart';
import 'package:vania_music/features/music/data/repository/music_repositoryImpl.dart';
import 'package:vania_music/features/music/domain/repository/music_repository.dart';
import 'package:vania_music/features/music/domain/usecases/get_music_usecase.dart';
import 'package:vania_music/features/music/presentation/bloc/cubit/appbar_expanded_cubit.dart';
import 'package:vania_music/features/music/presentation/bloc/music/music_bloc.dart';
import 'package:vania_music/features/music_album/data/data_source/local/music_album_cache.dart';
import 'package:vania_music/features/music_album/data/data_source/remote/music_album_api_provider.dart';
import 'package:vania_music/features/music_album/data/repository/music_album_repositoryImpl.dart';
import 'package:vania_music/features/music_album/domain/repository/music_album_repository.dart';
import 'package:vania_music/features/music_album/domain/usecases/get_music_album_usecase.dart';
import 'package:vania_music/features/music_album/presentation/bloc/music_album/music_album_bloc.dart';
import 'package:vania_music/features/player/data/repository/player_repositoryImpl.dart';
import 'package:vania_music/features/player/data/repository/visualiser_repositoryImpl.dart';
import 'package:vania_music/features/player/domain/repository/player_repository.dart';
import 'package:vania_music/features/player/domain/repository/visualiser_repository.dart';
import 'package:vania_music/features/player/domain/usecase/extract_waveform_usecase.dart';
import 'package:vania_music/features/player/presentation/bloc/player/player_bloc.dart';
import 'package:vania_music/features/player/presentation/bloc/visualiser/visualiser_cubit.dart';

final di = GetIt.instance;

Future<void> initAppModule() async {
  final SharedPreferences sp = await SharedPreferences.getInstance();
  di.registerLazySingleton(() => sp);

  /// Network info
  di.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(InternetConnectionChecker()));

  /// Data sources
  di.registerLazySingleton(() => MusicAlbumCache());
  di.registerLazySingleton(() => MusicAlbumApiProvider());
  di.registerLazySingleton(() => MusicCache());
  di.registerLazySingleton(() => MusicApiProvider());
  di.registerLazySingleton(() => FavoriteMusicCache());

  /// Repositories
  di.registerLazySingleton<FileStorageManagerRepository>(
      () => FileStorageManagerRepositoryImpl());
  di.registerLazySingleton<FileManagerRepository>(
      () => FileManagerRepositoryImpl(di()));
  di.registerLazySingleton<PlayerRepository>(() => PlayerRepositoryImpl());
  di.registerLazySingleton<MusicAlbumRepository>(
      () => MusicAlbumRepositoryImpl(di(), di(), di()));
  di.registerLazySingleton<MusicRepository>(
      () => MusicRepositoryImpl(di(), di(), di()));
  di.registerLazySingleton<FavoriteMusicRepository>(
      () => FavoriteMusicRepositoryImpl(di()));
  di.registerLazySingleton<VisualiserRepository>(
      () => VisualiserRepositoryImpl(di()));

  /// Usecases
  di.registerLazySingleton(() => GetMusicAlbumUseCase(di()));
  di.registerLazySingleton(() => GetMusicUseCase(di()));
  di.registerLazySingleton(() => AddFavoriteMusicUseCase(di()));
  di.registerLazySingleton(() => RemoveFavoriteMusicUseCase(di()));
  di.registerLazySingleton(() => GetFavoriteMusicUseCase(di()));
  di.registerLazySingleton(() => ExtractWaveformUseCase(di()));

  /// Blocs
  di.registerLazySingleton(() => FavoriteBloc(di(), di(), di()));
  di.registerLazySingleton(() => MusicAlbumBloc(di()));
  di.registerLazySingleton(() => MusicBloc(di(), di()));
  di.registerLazySingleton(() => PlayerBloc(di()));
  di.registerLazySingleton(() => ThemeBloc(
      di<PlayerRepository>().currentMediaItemStreamController.stream));
  di.registerLazySingleton(() => VisualiserCubit(di()));
  di.registerLazySingleton(() => AppbarExpandedCubit());

  /// Value notifier
  di.registerLazySingleton(() => DownloadFile(di(), di(), di()));
}
