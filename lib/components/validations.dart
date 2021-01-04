class Validations {
  String validateName(String value) {
    if (value.isEmpty) return 'Name is required.';
    final RegExp nameExp = new RegExp(r'^[A-za-z ]+$');
    if (!nameExp.hasMatch(value))
      return 'Please enter only alphabetical characters.';
    return null;
  }

  String validateAddress(String value) {
    if (value.isEmpty) return 'Select an address';
    return null;
  }

  String validateAmount(String value) {
    if (value.isEmpty) return 'Enter amount to top up';
    return null;
  }

  String validateDate(String value) {
    if (value.isEmpty) return 'Select a date';
    return null;
  }

  String validateSenderPhone(String value) {
    if (value.isEmpty) return 'Enter sender\'s phone number';
    return null;
  }

  String validateReceiverPhone(String value) {
    if (value.isEmpty) return 'Enter receiver\'s phone number';
    return null;
  }

  String validateReceiverName(String value) {
    if (value.isEmpty) return 'Enter receiver\'s name';
    return null;
  }

  String validateSenderName(String value) {
    if (value.isEmpty) return 'Sender\'s name is required';
    return null;
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  String validatePassword(String value) {
    if (value.isEmpty) return 'Please choose a password.';
    return null;
  }

  String validateMobile(String value) {
    if (value.length != 11)
      return 'Mobile Number must be of 11 digits';
    else return null;
  }
}
