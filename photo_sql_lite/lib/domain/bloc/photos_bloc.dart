
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:photo_sql_lite/core/core.dart';
import 'package:photo_sql_lite/data/data.dart';
import 'package:photo_sql_lite/domain/domain.dart';

part 'photos_bloc.freezed.dart';

@injectable
class PhotosModelData {

  final bool timeOut;
  final APhotosEntity data;
  final bool error;
  final String e;

  bool get isLoaded => data.photos.isNotEmpty;
  bool get isTimeOut => timeOut;
  bool get isError => error;

  const PhotosModelData({
    required this.data,
    required this.e,
    required this.timeOut,
    required this.error,
  });

  PhotosModelData copyWith({
    APhotosEntity? data,
    String? e,
    bool? timeOut,
    bool? error,
  }){
    return PhotosModelData(
      data: data ?? this.data,
      e: e ?? this.e,
      timeOut: timeOut ?? this.timeOut,
      error: error ?? this.error,
    );
  }
}

@freezed
class PhotosBlocState with _$PhotosBlocState{
  const factory PhotosBlocState.loading() = _loadingState;
  const factory PhotosBlocState.loaded({required PhotosModelData model}) = _loadedState;
  const factory PhotosBlocState.error() = _errorState;
  const factory PhotosBlocState.timeOut() = _timeOut;
}

@freezed
class PhotosBlocEvent with _$PhotosBlocEvent{
  const factory PhotosBlocEvent.init() = _initEvent;
  const factory PhotosBlocEvent.get({required int page}) = _getEvent;
  const factory PhotosBlocEvent.insert({required Photo value}) = _insertEvent;
  const factory PhotosBlocEvent.update({required Photo oldValue, required Photo value}) = _updateEvent;
  const factory PhotosBlocEvent.delete({required Photo value}) = _deleteEvent;
}

@injectable
class PhotosBloc extends Bloc<PhotosBlocEvent, PhotosBlocState>{
  final PhotosRepository photosRepository;


  PhotosModelData photosModelData = const PhotosModelData(
    timeOut: false,
    data: PhotosModel(<Photo>[], 0),
    e: '',
    error: false,
  );

  PhotosBloc({
    required this.photosRepository,
  }) : super(const PhotosBlocState.loading()) {
    on<PhotosBlocEvent>((event, emit) async {
      await event.map<FutureOr<void>>(
          init: (_initEvent value) async {
            emit(const PhotosBlocState.loading());
            await _get(0);
            _response(emit);
          },
          get: (_getEvent value) async {
            emit(const PhotosBlocState.loading());
            await _get(value.page);
            _response(emit);
          },
          insert: (_insertEvent value) async {
            emit(const PhotosBlocState.loading());
            await _insert(value.value);
            _response(emit);
          },
          update: (_updateEvent value) async {
            await _update(value.oldValue, value.value);
          },
          delete: (_deleteEvent value) async {
            emit(const PhotosBlocState.loading());
            await _delete(value.value);
            _response(emit);
          }

      );

    });

  }

  Future<Uint8List> getUint8List(String locator) async {
    return (await PhotoReadFromIntFile().readCounter(uuid: locator)).$1;
  }

  Future<String> writeToFile(String url , [String? locator]) async {
    return (await PhotoReadFromIntFile().writeCounter(url, locator)).$2;
  }


  void _response(Emitter<PhotosBlocState> emit){
    if (photosModelData.error){
      if(photosModelData.timeOut){
        emit(const PhotosBlocState.timeOut());
      } else {
        emit(const PhotosBlocState.error());
      }
    } else{
      emit(PhotosBlocState.loaded(model: photosModelData));
    }
  }

  Future<void> _get(int page) async {
    APhotosEntity? groupsModel;
    String? e;
    bool? error = false;
    bool? timeOut;
    try {
      //получаем первую страницу при инициализации
      var res = await photosRepository.get(page).timeout(const Duration(seconds: 2),
          onTimeout: () {
            e = null;
            error = true;
            timeOut  = true;
            return null;
          });
      if (res != null) {
        groupsModel = PhotosModel(res, page);
      }
    } catch (ee, t){
      e = ee.toString();
      error = true;
      timeOut  = false;
      Logger.print("$ee\n$t", name: 'err', level: 0, error: false);
    }
    photosModelData = photosModelData.copyWith(
      data: groupsModel,
      timeOut: timeOut,
      e: e,
      error: error,
    );

  }

  Future<void> _insert(Photo value) async {
    String? e;
    bool? error = false;
    bool? timeOut;
    try {
      var res = await photosRepository.insert(value).timeout(const Duration(seconds: 2),
          onTimeout: () {
            e = null;
            error = true;
            timeOut  = true;
            return null;
          });
      if (res != null) {
        photosModelData.data.photos.add(res);
      }
    } catch (ee, t){
      e = ee.toString();
      error = true;
      timeOut  = false;
      Logger.print("$ee\n$t", name: 'err', level: 0, error: false);
    }
    photosModelData = photosModelData.copyWith(
      timeOut: timeOut,
      e: e,
      error: error,
    );
  }

  Future<void> _update(Photo oldValue, Photo value) async {
    String? e;
    bool? error = false;
    bool? timeOut;
    try {
      var res = await photosRepository.update(value).timeout(const Duration(seconds: 2),
          onTimeout: () {
            e = null;
            error = true;
            timeOut  = true;
            return 0;
          });
      if (res > 0) {
        photosModelData.data.photos.remove(oldValue);
        photosModelData.data.photos.add(value);
      }
    } catch (ee, t){
      e = ee.toString();
      error = true;
      timeOut  = false;
      Logger.print("$ee\n$t", name: 'err', level: 0, error: false);
    }
    photosModelData = photosModelData.copyWith(
      timeOut: timeOut,
      e: e,
      error: error,
    );
  }

  Future<void> _delete(Photo value) async {
    String? e;
    bool? error = false;
    bool? timeOut;
    try {
      var res = await photosRepository.delete(value).timeout(const Duration(seconds: 2),
          onTimeout: () {
            e = null;
            error = true;
            timeOut  = true;
            return 0;
          });
      if (res > 0)
      {
        photosModelData.data.photos.remove(value);
      }
    } catch (ee, t){
      e = ee.toString();
      error = true;
      timeOut  = false;
      Logger.print("$ee\n$t", name: 'err', level: 0, error: false);
    }
    photosModelData = photosModelData.copyWith(
      timeOut: timeOut,
      e: e,
      error: error,
    );
  }
}