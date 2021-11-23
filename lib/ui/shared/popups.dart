import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:tourapp/ui/shared/app_colors.dart';
import 'package:tourapp/ui/shared/custom_alert_dialog.dart';
import 'package:tourapp/core/enums/dialog_type.dart' as type;

class Popups {

static AwesomeDialog showSuccess(
      String title, String body, ScaffoldState state, DialogType dialogType) {
     AwesomeDialog dialog;
    dialog = AwesomeDialog(
        context: state.context,
        animType: AnimType.SCALE,
        headerAnimationLoop: false,
        dialogType: dialogType,
        tittle: title,
        desc: body,
        btnOkOnPress: () {},
        btnOkColor: dialogType == DialogType.SUCCES
            ? AppColors.primaryColor
            : AppColors.dangerColor,
        btnOkIcon:
            dialogType == DialogType.SUCCES ? Icons.check_circle : Icons.error,
        
        
        
        );
    return dialog;
  }




static ShowDialog(BuildContext context  ,  
 String title, String description ,
 {  type.DialogType type,
   VoidCallback btnOkPressed,
     VoidCallback btnCacelPressed,
}
){

  showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialog(
              title: title, description:description, type: type,  btnCacelPressed: btnCacelPressed,  btnOkPressed: btnOkPressed,);
        });



}

}