import 'package:flutter/material.dart';
import 'package:users_data_app_floor/core/core.dart';
import 'package:users_data_app_floor/presentation/widgets/dialogs/dialog_field.dart';

class DialogUsersFieldsAndControllers{
  static final formKey = GlobalKey<FormState>();

  static late TextEditingController _firstName;
  static late TextEditingController _lastname;
  static late TextEditingController _name;
  static late TextEditingController _image;
  static late TextEditingController _phone;
  static late TextEditingController _age;

  static void initControllers({required User data}){
    _firstName = TextEditingController();
    _firstName.text = data.firstName;
    _lastname = TextEditingController();
    _lastname.text = data.lastName;
    _name = TextEditingController();
    _name.text = data.name;
    _image = TextEditingController();
    _image.text = data.image;
    _phone = TextEditingController();
    _phone.text = data.phone;
    _age = TextEditingController();
    _age.text = data.age.toString();
  }

  static void disposeControllers(){
    _firstName.dispose();
    _lastname.dispose();
    _name.dispose();
    _image.dispose();
    _phone.dispose();
    _age.dispose();
  }

  static User userData({required User oldData}) {
    final age = int.parse(_age.text);
    return User(
      id: oldData.id,
      uuid: oldData.uuid,
      firstName: _firstName.text,
      name:  _name.text,
      lastName: _lastname.text,
      phone: _phone.text,
      age: age,
      image: _image.text,
      locator: oldData.locator,
    );
  }
  
  static List<DialogField> get allFields => <DialogField>[
    DialogField(controller: _firstName,
      label: 'First Name',
      validator: ValidatorFields.checkName,
    ),
    DialogField(controller: _name,
      label: 'Name',
      validator: ValidatorFields.checkName,
    ),
    DialogField(controller: _lastname,
      label: 'Last Name',
      validator: ValidatorFields.checkLastName,
    ),
    DialogField(controller: _age,
      label: 'Age',
      validator: ValidatorFields.checkAge,
    ),
    DialogField(controller: _phone,
      label: 'Phone int format +7 (XXX) XXX-XX-XX',
      validator: ValidatorFields.checkPhone,
    ),
    DialogField(controller: _image,
      label: 'Photo URL',
      validator: ValidatorFields.checkValidUrl,
    ),
  ];

}
