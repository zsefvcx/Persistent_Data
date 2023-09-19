
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:photo_aql_lite/core/core.dart';
import 'package:photo_aql_lite/data/data.dart';
import 'package:photo_aql_lite/domain/domain.dart';

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
class PhotosBlocState with _$GroupsBlocState{
  const factory PhotosBlocState.loading() = _loadingState;
  const factory PhotosBlocState.loaded({required PhotosModelData model}) = _loadedState;
  const factory PhotosBlocState.error() = _errorState;
  const factory PhotosBlocState.timeOut() = _timeOut;
}

@freezed
class PhotosBlocEvent with _$GroupsBlocEvent{
  const factory PhotosBlocEvent.init() = _initEvent;
  const factory PhotosBlocEvent.get({required int page}) = _getEvent;
  const factory PhotosBlocEvent.insert({required Photo value}) = _insertEvent;
  const factory PhotosBlocEvent.update({required Photo oldValue, required Photo value}) = _updateEvent;
  const factory PhotosBlocEvent.delete({required Photo value}) = _deleteEvent;
}

@injectable
class PhotosBloc extends Bloc<PhotosBlocEvent, PhotosBlocState>{
  final PhotosRepository groupsRepository;


  PhotosModelData groupsModelData = const PhotosModelData(
    timeOut: false,
    data: PhotosModel(<Photo>[], 0),
    e: '',
    error: false,
  );

  PhotosBloc({
    required this.groupsRepository,
  }) : super(const PhotosBlocState.loading()) {
    on<PhotosBlocEvent>((event, emit) async {
      await event.map<FutureOr<void>>(
          init: (_initEvent value) async {
            emit(const PhotosBlocState.loading());
            await _get(0);
            _response(emit);
          },
          getGroups: (_getEvent value) async {
            emit(const PhotosBlocState.loading());
            await _get(value.page);
            _response(emit);
          },
          insertGroup: (_insertEvent value) async {
            emit(const PhotosBlocState.loading());
            await _insert(value.value);
            _response(emit);
          },
          updateGroup: (_updateEvent value) async {
            await _update(value.oldValue, value.value);
          },
          deleteGroup: (_deleteEvent value) async {
            emit(const PhotosBlocState.loading());
            await _delete(value.value);
            _response(emit);
          }

      );

    });

  }

  void _response(Emitter<PhotosBlocState> emit){
    if (groupsModelData.error){
      if(groupsModelData.timeOut){
        emit(const PhotosBlocState.timeOut());
      } else {
        emit(const PhotosBlocState.error());
      }
    } else{
      emit(PhotosBlocState.loaded(model: groupsModelData));
    }
  }

  Future<void> _get(int page) async {
    APhotosEntity? groupsModel;
    String? e;
    bool? error = false;
    bool? timeOut;
    try {
      //получаем первую страницу при инициализации
      var res = await groupsRepository.getGroups(page).timeout(const Duration(seconds: 2),
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
    groupsModelData = groupsModelData.copyWith(
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
      var res = await groupsRepository.insertGroup(value).timeout(const Duration(seconds: 2),
          onTimeout: () {
            e = null;
            error = true;
            timeOut  = true;
            return null;
          });
      if (res != null) {
        groupsModelData.data.photos.add(res);
      }
    } catch (ee, t){
      e = ee.toString();
      error = true;
      timeOut  = false;
      Logger.print("$ee\n$t", name: 'err', level: 0, error: false);
    }
    groupsModelData = groupsModelData.copyWith(
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
      var res = await groupsRepository.updateGroup(value).timeout(const Duration(seconds: 2),
          onTimeout: () {
            e = null;
            error = true;
            timeOut  = true;
            return 0;
          });
      if (res > 0) {
        groupsModelData.data.photos.remove(oldValue);
        groupsModelData.data.photos.add(value);
      }
    } catch (ee, t){
      e = ee.toString();
      error = true;
      timeOut  = false;
      Logger.print("$ee\n$t", name: 'err', level: 0, error: false);
    }
    groupsModelData = groupsModelData.copyWith(
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
      var res = await groupsRepository.deleteGroup(value).timeout(const Duration(seconds: 2),
          onTimeout: () {
            e = null;
            error = true;
            timeOut  = true;
            return 0;
          });
      if (res > 0)
      {
        groupsModelData.data.photos.remove(value);
      }
    } catch (ee, t){
      e = ee.toString();
      error = true;
      timeOut  = false;
      Logger.print("$ee\n$t", name: 'err', level: 0, error: false);
    }
    groupsModelData = groupsModelData.copyWith(
      timeOut: timeOut,
      e: e,
      error: error,
    );
  }
}