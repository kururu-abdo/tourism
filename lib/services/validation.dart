class Validators{


  static bool isValidPhoneNumber(String string) {
    // Null or empty string is invalid phone number
    // if (string == null || string.isEmpty) {
    //   return false;
    // }

    // // You may need to change this pattern to fit your requirement.
    // // I just copied the pattern from here: https://regexr.com/3c53v
    const pattern = r'^[0-9]{10}';
     final regExp = RegExp(pattern);
    return regExp.hasMatch(string);
    // if (!regExp.hasMatch(string)) {
    //   return false;
    // }
    // return true;
  }



 static bool isValidEmail(String str){
  const pattern = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";


       final regExp = RegExp(pattern);
 if (!regExp.hasMatch(str)) {
      return false;
    }
    return true;
 }


}