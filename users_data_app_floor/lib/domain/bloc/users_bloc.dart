
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../core/core.dart';
import '../../data/data.dart';
import '../domain.dart';

part 'users_bloc.freezed.dart';

@injectable
class UsersModelData {

  final bool timeOut;
  final AUsersEntity data;
  final bool error;
  final String e;

  bool get isLoaded => data.users.isNotEmpty;
  bool get isTimeOut => timeOut;
  bool get isError => error;

  const UsersModelData({
    required this.data,
    required this.e,
    required this.timeOut,
    required this.error,
  });

  UsersModelData copyWith({
    AUsersEntity? data,
    String? e,
    bool? timeOut,
    bool? error,
  }){
    return UsersModelData(
      data: data ?? this.data,
      e: e ?? this.e,
      timeOut: timeOut ?? this.timeOut,
      error: error ?? this.error,
    );
  }
}

@freezed
class UsersBlocState with _$UsersBlocState{
  const factory UsersBlocState.loading() = _loadingState;
  const factory UsersBlocState.loaded({required UsersModelData model}) = _loadedState;
  const factory UsersBlocState.error() = _errorState;
  const factory UsersBlocState.timeOut() = _timeOut;
}

@freezed
class UsersBlocEvent with _$UsersBlocEvent{
  const factory UsersBlocEvent.init() = _initEvent;
  const factory UsersBlocEvent.get({required int page}) = _getEvent;//Completer
  const factory UsersBlocEvent.getCompleter({required int page, required Completer completer}) = _getCompleterEvent;
  const factory UsersBlocEvent.insert({required User value}) = _insertEvent;
  const factory UsersBlocEvent.update({required User oldValue, required User value}) = _updateEvent;
  const factory UsersBlocEvent.insertCard({required CardDetail value}) = _insertCardEvent;
  const factory UsersBlocEvent.updateCard({required CardDetail value}) = _updateCardEvent;
  const factory UsersBlocEvent.delete({required User value}) = _deleteEvent;
}

@injectable
class UsersBloc extends Bloc<UsersBlocEvent, UsersBlocState>{
  final UsersRepository usersRepository;
  final PhotoReadRepository photoReadRepository;
  final CardSecureRepository cardSecureRepository;

  UsersModelData usersModelData = const UsersModelData(
    timeOut: false,
    data: UsersModel(<User>{}, 0),
    e: '',
    error: false,
  );

  UsersBloc({
    required this.photoReadRepository,
    required this.usersRepository,
    required this.cardSecureRepository,
  }) : super(const UsersBlocState.loading()) {
    on<UsersBlocEvent>((event, emit) async {
      await event.map<FutureOr<void>>(
          init: (_initEvent value) async {
            emit(const UsersBlocState.loading());
            await _get(0);
            await Future.delayed(const Duration(seconds: 2));
            _response(emit);
          },
          get: (_getEvent value) async {
            emit(const UsersBlocState.loading());
            await _get(value.page);
            await Future.delayed(const Duration(seconds: 2));
            _response(emit);
          },
          getCompleter: (_getCompleterEvent value) async {
            await _get(value.page);
            await Future.delayed(const Duration(seconds: 2));
            _response(emit);
            value.completer.complete();
          },
          insert: (_insertEvent value) async {
            emit(const UsersBlocState.loading());
            await _insert(value.value);
            await Future.delayed(const Duration(seconds: 2));
            _response(emit);
          },
          update: (_updateEvent value) async {
            await _update(value.oldValue, value.value);
            await Future.delayed(const Duration(seconds: 2));
          },
          delete: (_deleteEvent value) async {
            emit(const UsersBlocState.loading());
            await _delete(value.value);
            await Future.delayed(const Duration(seconds: 2));
            _response(emit);
          },
          insertCard: (_insertCardEvent value) async {
            var (error, timeOut, res) = await _insertCard(value: value.value);
          },
          updateCard: (_updateCardEvent value) async {
            var (error, timeOut, res) = await _updateCard(value: value.value);
          },
      )
      ;
    });
  }

  Future<(bool, bool, bool?)> _insertCard({required CardDetail value}) async {
    bool error = false;
    bool timeOut = false;
    bool? res;
    try{
      res = await cardSecureRepository.insertCard(value: value).timeout(const Duration(seconds: 2),
          onTimeout: () {
            error = true;
            timeOut  = true;
            return null;
          });
    } catch(ee, t){
      Logger.print("$ee\n$t", name: 'err', level: 0, error: false);
      error = true;
    }
    return (error, timeOut, res);
  }

  Future<(bool, bool, CardDetail?)> readCard({required String uuidUser}) async {
    bool error = false;
    bool timeOut = false;
    CardDetail? res;
    try{
      res = await cardSecureRepository.readCard(uuidUser: uuidUser).timeout(const Duration(seconds: 2),
          onTimeout: () {
            error = true;
            timeOut  = true;
            return null;
          });
    } catch(ee, t){
      Logger.print("$ee\n$t", name: 'err', level: 0, error: false);
      error = true;
    }
    return (error, timeOut, res);
  }

  Future<(bool, bool, bool?)> _updateCard({required CardDetail value}) async {
    bool error = false;
    bool timeOut = false;
    bool? res;
    try{
      res = await cardSecureRepository.updateCard(value: value).timeout(const Duration(seconds: 2),
          onTimeout: () {
            error = true;
            timeOut  = true;
            return null;
          });
    } catch(ee, t){
      Logger.print("$ee\n$t", name: 'err', level: 0, error: false);
      error = true;
    }
    return (error, timeOut, res);
  }

  Future<(bool, bool, bool?)> _deleteCard({required String uuidUser}) async {
    bool error = false;
    bool timeOut = false;
    bool? res;
    try{
      res = await cardSecureRepository.deleteCard(uuidUser: uuidUser).timeout(const Duration(seconds: 2),
          onTimeout: () {
            error = true;
            timeOut  = true;
            return null;
          });
    } catch(ee, t){
      Logger.print("$ee\n$t", name: 'err', level: 0, error: false);
      error = true;
    }
    return (error, timeOut, res);
  }

  Future<APhotosModel?> getUint8List(String locator, String url) async {
    await Future.delayed(const Duration(seconds: 2));
    APhotosModel? res;
    try{
      res = await photoReadRepository.readCounter(locator: locator, url: url);
    } catch(ee, t){
      Logger.print("$ee\n$t", name: 'err', level: 0, error: false);
    }
    return res;
  }

  Future<(bool, bool, String?)> _insertPhoto({required String url, String? locator}) async {
    bool error = false;
    bool timeOut = false;
    String? res;
    try{
      res = (await photoReadRepository.writeCounter(url: url, locator: locator).timeout(const Duration(seconds: 2),
          onTimeout: () {
            error = true;
            timeOut  = true;
            return (null, null);
          })

      ).$2;
    } catch(ee, t){
      Logger.print("$ee\n$t", name: 'err', level: 0, error: false);
      error = true;
    }
    return (error, timeOut, res);
  }

  Future<(bool, bool, bool?)> _deletePhoto({required String locator}) async {
    bool error = false;
    bool timeOut = false;
    bool? res;
    try{
      res = await photoReadRepository.deletePhoto(locator: locator).timeout(const Duration(seconds: 2),
          onTimeout: () {
            error = true;
            timeOut  = true;
            return null;
          });
    } catch(ee, t){
      Logger.print("$ee\n$t", name: 'err', level: 0, error: false);
      error = true;
    }
    return (error, timeOut, res);
  }

  void _response(Emitter<UsersBlocState> emit){
    if (usersModelData.error){
      if(usersModelData.timeOut){
        emit(const UsersBlocState.timeOut());
      } else {
        emit(const UsersBlocState.error());
      }
    } else{
      emit(UsersBlocState.loaded(model: usersModelData));
    }
  }

  Future<void> _get(int page) async {
    AUsersEntity? groupsModel;
    String? e;
    bool? error = false;
    bool? timeOut;
    try {
      //получаем первую страницу при инициализации
      var res = await usersRepository.get(page: page).timeout(const Duration(seconds: 2),
          onTimeout: () {
            e = null;
            error = true;
            timeOut  = true;
            return null;
          });
      if (res != null) {
        final AUsersEntity getModel = UsersModel(res.toSet(), page);
        if(getModel == usersModelData.data){
          Logger.print("Identical! No need load data.", name: 'err', level: 0, error: false);
        } else {
          groupsModel = getModel;
        }

      }
    } catch (ee, t){
      e = ee.toString();
      error = true;
      timeOut  = false;
      Logger.print("$ee\n$t", name: 'err', level: 0, error: false);
    }
    usersModelData = usersModelData.copyWith(
      data: groupsModel,
      timeOut: timeOut,
      e: e,
      error: error,
    );

  }

  Future<void> _insert(User value) async {
    String? e;
    bool? error = false;
    bool? timeOut;
    try {
      String? locator= (await _insertPhoto(url: value.image, locator: value.locator)).$3;
      if(locator == null) {
        Logger.print('Image is not loaded', name: 'log', level: 0, error: false);
      }
      value = value.copyWith(
        locator: locator,
      );
      var res = await usersRepository.insert(value: value).timeout(const Duration(seconds: 2),
          onTimeout: () {
            e = null;
            error = true;
            timeOut  = true;
            return null;
          });
      if (res != null) {
        usersModelData.data.users.add(res);
      }
    } catch (ee, t){
      e = ee.toString();
      error = true;
      timeOut  = false;
      Logger.print("$ee\n$t", name: 'err', level: 0, error: false);
    }
    usersModelData = usersModelData.copyWith(
      timeOut: timeOut,
      e: e,
      error: error,
    );
  }

  Future<void> _update(User oldValue, User value) async {
    String? e;
    bool? error = false;
    bool? timeOut;
    try {
      if(value.image != oldValue.image || oldValue.locator == null){
        String? locator= (await _insertPhoto(url: value.image, locator: value.locator)).$3;
        if(locator == null) {
          Logger.print('Image is not loaded', name: 'log', level: 0, error: false);
        }
        value = value.copyWith(
          locator: locator,
        );
      }
      var res = await usersRepository.update(value: value).timeout(const Duration(seconds: 2),
          onTimeout: () {
            e = null;
            error = true;
            timeOut  = true;
            return 0;
          });
      if (res > 0) {
        usersModelData.data.users.remove(oldValue);
        usersModelData.data.users.add(value);
      }
    } catch (ee, t){
      e = ee.toString();
      error = true;
      timeOut  = false;
      Logger.print("$ee\n$t", name: 'err', level: 0, error: false);
    }
    usersModelData = usersModelData.copyWith(
      timeOut: timeOut,
      e: e,
      error: error,
    );
  }

  Future<void> _delete(User value) async {
    String? e;
    bool? error = false;
    bool? timeOut;
    try {
      await _deleteCard(uuidUser: value.uuid);
      await _deletePhoto(locator: value.locator??'');
      var res = await usersRepository.delete(value: value).timeout(const Duration(seconds: 2),
          onTimeout: () {
            e = null;
            error = true;
            timeOut  = true;
            return 0;
          });
      if (res > 0)
      {
        usersModelData.data.users.remove(value);
      }
    } catch (ee, t){
      e = ee.toString();
      error = true;
      timeOut  = false;
      Logger.print("$ee\n$t", name: 'err', level: 0, error: false);
    }
    usersModelData = usersModelData.copyWith(
      timeOut: timeOut,
      e: e,
      error: error,
    );
  }
}