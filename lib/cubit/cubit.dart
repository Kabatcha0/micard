import 'dart:developer';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:micard/cubit/states.dart';
import 'package:micard/shared/local.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MicardCubit extends Cubit<MicardStates> {
  MicardCubit() : super(MiCardInitialState());
  static MicardCubit get(context) => BlocProvider.of(context);
  bool check = false;
  void changeMode() {
    check = !check;
    CacheHelper.setData(key: "key", value: check);
    emit(MiCardChangeModeState());
  }

  File? file;
  void imagePicker() {
    ImagePicker.platform
        .getImageFromSource(source: ImageSource.gallery)
        .then((value) {
      if (value != null) {
        file = File(file!.path);
        emit(MiCardImagePickerState());
      } else {
        return null;
      }
    }).catchError((e) {
      log(e.toString());
    });
  }
}
