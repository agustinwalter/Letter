import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:letter/models/user_model.dart';
import 'package:letter/screens/subs_step_two_screen.dart';
import 'package:letter/widgets/my_button.dart';
import 'package:letter/widgets/my_dialog.dart';
import 'package:letter/widgets/my_text_field.dart';
import 'package:provider/provider.dart';

class AdressForm extends StatefulWidget {
  final String actionAfterSave;
  const AdressForm({Key key, this.actionAfterSave}) : super(key: key);
  @override
  _AdressFormState createState() => _AdressFormState();
}

class _AdressFormState extends State<AdressForm> {
  TextEditingController streetController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController floorController = TextEditingController();
  TextEditingController apartmentController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController postalController = TextEditingController();
  TextEditingController provinceController = TextEditingController();
  String addressStatus;
  final addressKey = GlobalKey<FormState>();
  bool autovalidate = false;
  bool buttonAddressLoading = false;

  @override
  void dispose() {
    super.dispose();
    streetController.dispose();
    numberController.dispose();
    floorController.dispose();
    apartmentController.dispose();
    cityController.dispose();
    postalController.dispose();
    provinceController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserModel>(
      builder: (context, user, child) {
        Map<dynamic, dynamic> address = user.getAddress();
        if(address != null){
          streetController.text = address['street'];
          numberController.text = address['number'];
          floorController.text = address['floor'];
          apartmentController.text = address['apartment'];
          cityController.text = address['city'];
          postalController.text = address['postal_code'];
          provinceController.text = address['province'];
        }
        return Form(
          key: addressKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  // Street
                  MyTextField(
                    hintText: 'Calle',
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    actionLeft: (){},
                    margin: EdgeInsets.fromLTRB(20, 20, 0, 0),
                    controller: streetController,
                    width: .43,
                    autovalidate: autovalidate,
                    validator: (value) {
                      if (value.isEmpty) return 'Campo obligatorio\n';
                      return null;
                    }
                  ),
                  // Number
                  MyTextField(
                    hintText: 'Número',
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    actionLeft: (){},
                    margin: EdgeInsets.fromLTRB(0, 20, 20, 0),
                    controller: numberController,
                    width: .43,
                    autovalidate: autovalidate,
                    validator: (value) {
                      if (value.isEmpty) return 'Campo obligatorio\n';
                      return null;
                    }
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  // Floor
                  MyTextField(
                    hintText: 'Piso',
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    actionLeft: (){},
                    margin: EdgeInsets.fromLTRB(20, 20, 0, 0),
                    controller: floorController,
                    width: .43,
                  ),
                  // Departamento
                  MyTextField(
                    hintText: 'Departamento',
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    actionLeft: (){},
                    margin: EdgeInsets.fromLTRB(0, 20, 20, 0),
                    controller: apartmentController,
                    width: .43,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  // City
                  MyTextField(
                    hintText: 'Ciudad',
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    actionLeft: (){},
                    margin: EdgeInsets.fromLTRB(20, 20, 0, 0),
                    controller: cityController,
                    width: .43,
                    autovalidate: autovalidate,
                    validator: (value) {
                      if (value.isEmpty) return 'Campo obligatorio\n';
                      return null;
                    }
                  ),
                  // Postal code
                  MyTextField(
                    hintText: 'Código postal',
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    actionLeft: (){},
                    margin: EdgeInsets.fromLTRB(0, 20, 20, 0),
                    controller: postalController,
                    width: .43,
                    autovalidate: autovalidate,
                    validator: (value) {
                      if (value.isEmpty) return 'Campo obligatorio\n';
                      return null;
                    }
                  ),
                ],
              ),

              // Province
              MyTextField(
                hintText: 'Provincia',
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.text,
                actionLeft: (){},
                margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                controller: provinceController,
                autovalidate: autovalidate,
                validator: (value) {
                  if (value.isEmpty) return 'Campo obligatorio\n';
                  return null;
                }
              ),

              SizedBox(height: 15),

              MyButton(
                buttonText: 'Guardar dirección',
                fontSize: 17,
                action: () => _saveAddress(),
                loading: buttonAddressLoading,
              ),

            ]
          ),
        );
      }
    );
  }

  _saveAddress(){
    if (addressKey.currentState.validate()) {
      setState(() {
        buttonAddressLoading = true;
        autovalidate = false;
      });
      Map<String, String> address = {
        'street': streetController.text,
        'number': numberController.text,
        'floor': floorController.text,
        'apartment': apartmentController.text,
        'city': cityController.text,
        'postal_code': postalController.text,
        'province': provinceController.text
      };
      UserModel user = Provider.of<UserModel>(context);
      user.updateAddress(address).then((res){
        setState(() => buttonAddressLoading = false);
        if(widget.actionAfterSave == 'GO_TO_COMPLETE_SUBSCRIPTION'){
          showDialog(
            context: context,
            builder: (BuildContext context) => MyDialog(
              title: '¡Dirección guardada!',
              description: 'Puedes continuar al siguiente paso.',
              primaryButtonText: 'CONTINUAR',
              primaryButtonTextColor: Colors.blueAccent,
              backgroundIconColor1: Colors.lime,
              backgroundIconColor2: Colors.green,
              icon: Icons.done_outline,
              showSecondaryButton: false,
              primaryButtonAction: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SubsStepTwoScreen()),
                );    
              },
            )
          );
        }else if(widget.actionAfterSave == 'BACK'){
          showDialog(
            context: context,
            builder: (BuildContext context) => MyDialog(
              title: '¡Dirección guardada!',
              description: 'Tu dirección de envío se actualizó con éxito.',
              primaryButtonText: 'ENTENDIDO',
              primaryButtonTextColor: Colors.blueAccent,
              backgroundIconColor1: Colors.lime,
              backgroundIconColor2: Colors.green,
              icon: Icons.done_outline,
              showSecondaryButton: false,
              primaryButtonAction: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            )
          );
        }
      });
    }else{
      setState(() => autovalidate = true);
    }
  }
  
}