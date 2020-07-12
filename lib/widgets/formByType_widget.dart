import 'package:flutter/material.dart';
import 'package:qrcode/blocs/blocs.dart';
import 'package:qrcode/environment/environment.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrcode/utils/utils.dart' as utils;

class FormByScanType extends StatelessWidget {
  final String scanType;
  final Color color;
  final PanelController panelCtrl;

  const FormByScanType(
      {Key key,
      @required this.scanType,
      this.color = Colors.black,
      this.panelCtrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (scanType == ScanTypes.url.value) return UrlForm(panelCtrl: panelCtrl);
    if (scanType == ScanTypes.wifi.value) return WifiForm(panelCtrl: panelCtrl);
    if (scanType == ScanTypes.location.value)
      return LocationForm(panelCtrl: panelCtrl);
    if (scanType == ScanTypes.email.value)
      return EmailForm(panelCtrl: panelCtrl);
    if (scanType == ScanTypes.phone.value)
      return PhoneForm(panelCtrl: panelCtrl);
    if (scanType == ScanTypes.sms.value) return SmsForm(panelCtrl: panelCtrl);
    if (scanType == ScanTypes.text.value) return TextForm(panelCtrl: panelCtrl);
    // Si no encuentra ninguno por defecto es el primero
    return UrlForm(panelCtrl: panelCtrl);
  }
}

class TextForm extends StatelessWidget {
  const TextForm({
    Key key,
    @required this.panelCtrl,
  }) : super(key: key);

  final PanelController panelCtrl;

  @override
  Widget build(BuildContext context) {
    final TextEditingController _textCtrl =
        context.bloc<CreateQRBloc>().textCtrl;
    return Form(
      onChanged: () {
        // Asignamos el texto de los campos en las variables
        final String _text = _textCtrl.text;
        context.bloc<CreateQRBloc>().add(ChangeQRData(data: _text));
      },
      child: Column(
        children: <Widget>[
          Separator(),
          TextField(
            editingController: _textCtrl,
            panelCtrl: panelCtrl,
            label: "Text",
            maxLines: null,
            textInputType: TextInputType.multiline,
          ),
        ],
      ),
    );
  }
}

class SmsForm extends StatelessWidget {
  const SmsForm({
    Key key,
    @required this.panelCtrl,
  }) : super(key: key);

  final PanelController panelCtrl;

  @override
  Widget build(BuildContext context) {
    final TextEditingController _smsNumberCtrl =
        context.bloc<CreateQRBloc>().smsNumberCtrl;
    final TextEditingController _smsBodyCtrl =
        context.bloc<CreateQRBloc>().smsBodyCtrl;
    return Form(
      onChanged: () {
        // Asignamos el texto de los campos en las variables
        final String _number = _smsNumberCtrl.text;
        final String _body = _smsBodyCtrl.text;
        // Obtenemos el formato de guardado
        final String _smsDataFormat =
            utils.smsFieldsToQRFormat(phoneNumber: _number, body: _body);
        context.bloc<CreateQRBloc>().add(ChangeQRData(data: _smsDataFormat));
      },
      child: Column(
        children: <Widget>[
          Separator(),
          TextField(
            editingController: _smsNumberCtrl,
            panelCtrl: panelCtrl,
            label: "Phone Number",
            textInputType: TextInputType.phone,
          ),
          Separator(),
          TextField(
            editingController: _smsBodyCtrl,
            panelCtrl: panelCtrl,
            label: "Message",
          ),
        ],
      ),
    );
  }
}

class PhoneForm extends StatelessWidget {
  const PhoneForm({
    Key key,
    @required this.panelCtrl,
  }) : super(key: key);

  final PanelController panelCtrl;

  @override
  Widget build(BuildContext context) {
    final TextEditingController _phoneNumberCtrl =
        context.bloc<CreateQRBloc>().phoneNumberCtrl;
    return Form(
      onChanged: () {
        // Asignamos el texto de los campos en las variables
        final String _number = _phoneNumberCtrl.text;
        // Obtenemos el formato de guardado
        final String _phoneDataFormat =
            utils.phoneFieldsToQRFormat(phoneNumber: _number);
        context.bloc<CreateQRBloc>().add(ChangeQRData(data: _phoneDataFormat));
      },
      child: Column(
        children: <Widget>[
          Separator(),
          TextField(
            editingController: _phoneNumberCtrl,
            panelCtrl: panelCtrl,
            label: "Phone Number",
            textInputType: TextInputType.phone,
          ),
        ],
      ),
    );
  }
}

class EmailForm extends StatelessWidget {
  const EmailForm({
    Key key,
    @required this.panelCtrl,
  }) : super(key: key);

  final PanelController panelCtrl;

  @override
  Widget build(BuildContext context) {
    final TextEditingController _emailCtrl =
        context.bloc<CreateQRBloc>().emailCtrl;
    final TextEditingController _emailSubjectCtrl =
        context.bloc<CreateQRBloc>().emailSubjectCtrl;
    final TextEditingController _emailBody =
        context.bloc<CreateQRBloc>().emailBodyCtrl;
    return Form(
      onChanged: () {
        // Asignamos el texto de los campos en las variables
        final String _email = _emailCtrl.text;
        final String _subject = _emailSubjectCtrl.text;
        final String _body = _emailBody.text;
        // Obtenemos el formato de guardado
        final String _emailDataFormat = utils.emailFieldsToQRFormat(
            email: _email, subject: _subject, body: _body);
        context.bloc<CreateQRBloc>().add(ChangeQRData(data: _emailDataFormat));
      },
      child: Column(
        children: <Widget>[
          Separator(),
          TextField(
            editingController: _emailCtrl,
            panelCtrl: panelCtrl,
            label: "Email",
            textInputType: TextInputType.emailAddress,
          ),
          Separator(),
          TextField(
            editingController: _emailSubjectCtrl,
            panelCtrl: panelCtrl,
            label: "Subject",
          ),
          Separator(),
          TextField(
            editingController: _emailBody,
            panelCtrl: panelCtrl,
            label: "Message",
          ),
        ],
      ),
    );
  }
}

class LocationForm extends StatelessWidget {
  const LocationForm({
    Key key,
    @required this.panelCtrl,
  }) : super(key: key);

  final PanelController panelCtrl;

  @override
  Widget build(BuildContext context) {
    final TextEditingController _locationLatCtrl =
        context.bloc<CreateQRBloc>().locationLatCtrl;
    final TextEditingController _locationLonCtrl =
        context.bloc<CreateQRBloc>().locationLonCtrl;
    return Form(
      onChanged: () {
        // Asignamos el texto de los campos en las variables
        final String _lat = _locationLatCtrl.text;
        final String _lon = _locationLonCtrl.text;
        // Obtenemos el formato de guardado
        final String _locationDataFormat =
            utils.locationFieldsToQRFormat(latitude: _lat, longitude: _lon);
        context
            .bloc<CreateQRBloc>()
            .add(ChangeQRData(data: _locationDataFormat));
      },
      child: Column(
        children: <Widget>[
          Separator(),
          TextField(
            editingController: _locationLatCtrl,
            panelCtrl: panelCtrl,
            label: "Latitude",
            textInputType: TextInputType.number,
          ),
          Separator(),
          TextField(
            editingController: _locationLonCtrl,
            panelCtrl: panelCtrl,
            label: "Longitude",
            textInputType: TextInputType.number,
          ),
          // Separator(),
          // Text("or"),
          // Separator(),
          // TextField(
          //   panelCtrl: panelCtrl,
          //   label: "URL",
          //   textInputType: TextInputType.url,
          // ),
        ],
      ),
    );
  }
}

class WifiForm extends StatelessWidget {
  const WifiForm({
    Key key,
    @required this.panelCtrl,
  }) : super(key: key);

  final PanelController panelCtrl;

  @override
  Widget build(BuildContext context) {
    final TextEditingController _wifiSSIDCtrl =
        context.bloc<CreateQRBloc>().wifiSSIDCtrl;
    final TextEditingController _wifiPasswordCtrl =
        context.bloc<CreateQRBloc>().wifiPasswordCtrl;
    final TextEditingController _wifiEncryptionCtrl =
        context.bloc<CreateQRBloc>().wifiEncryptionCtrl;

    return Form(
      onChanged: () {
        // Asignamos el texto de los campos en las variables
        final String _ssid = _wifiSSIDCtrl.text;
        final String _password = _wifiPasswordCtrl.text;
        final String _encryption = _wifiEncryptionCtrl.text;
        // Obtenemos el formato de guardado
        final String _wifiDataFormat = utils.wifiFieldsToQRFormat(
            ssid: _ssid, password: _password, encryption: _encryption);
        context.bloc<CreateQRBloc>().add(ChangeQRData(data: _wifiDataFormat));
      },
      child: Column(
        children: <Widget>[
          Separator(),
          TextField(
            editingController: _wifiSSIDCtrl,
            panelCtrl: panelCtrl,
            label: "SSID",
          ),
          Separator(),
          TextField(
            editingController: _wifiPasswordCtrl,
            panelCtrl: panelCtrl,
            label: "Password",
            textInputType: TextInputType.visiblePassword,
          ),
          Separator(),
          TextField(
            editingController: _wifiEncryptionCtrl,
            panelCtrl: panelCtrl,
            label: "Encryption",
          ),
        ],
      ),
    );
  }
}

class UrlForm extends StatelessWidget {
  const UrlForm({
    Key key,
    @required this.panelCtrl,
  }) : super(key: key);

  final PanelController panelCtrl;

  @override
  Widget build(BuildContext context) {
    final TextEditingController _urlController =
        context.bloc<CreateQRBloc>().urlController;
    return Form(
      onChanged: () {
        final String _url = _urlController.text;
        context.bloc<CreateQRBloc>().add(ChangeQRData(data: _url));
      },
      child: Column(
        children: <Widget>[
          Separator(),
          TextField(
            panelCtrl: panelCtrl,
            label: "URL",
            textInputType: TextInputType.url,
            editingController: _urlController,
          ),
        ],
      ),
    );
  }
}

class TextField extends StatelessWidget {
  const TextField(
      {Key key,
      @required this.panelCtrl,
      @required this.label,
      this.maxLines = 1,
      this.textInputType = TextInputType.text,
      this.editingController})
      : super(key: key);

  final PanelController panelCtrl;
  final String label;
  final int maxLines;
  final TextInputType textInputType;
  final TextEditingController editingController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: () => panelCtrl.open(),
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      controller: editingController,
      maxLines: maxLines,
      keyboardType: textInputType,
      onChanged: (value) {},
      onSaved: (value) {},
      // autofocus: true,
    );
  }
}

class Separator extends StatelessWidget {
  const Separator({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 10.0,
    );
  }
}
