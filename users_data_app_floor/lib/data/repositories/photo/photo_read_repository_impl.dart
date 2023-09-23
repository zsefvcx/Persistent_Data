
import 'dart:io';
import 'dart:typed_data';

import 'package:users_data_app_floor/core/core.dart';
import 'package:users_data_app_floor/data/data.dart';
import 'package:users_data_app_floor/domain/domain.dart';

class PhotoReadRepositoryImpl extends PhotoReadRepository{

  final PhotoReadFromIntFile photoReadFromIntFile;
  final NetworkInfo networkInfo;

  PhotoReadRepositoryImpl({
    required this.networkInfo,
    required this.photoReadFromIntFile
  });

  @override
  Future<APhotosModel> readCounter({required String locator, required String url}) async {
    return await photoReadFromIntFile.readCounter(locator: locator, url: url);
  }

  @override
  Future<(File, String)> writeCounter(String url, [String? locator]) async {
    if (await networkInfo.isConnected){
    return await photoReadFromIntFile.writeCounter(url, locator);
    } else {
      throw('No internet connection!');
    }
  }


}