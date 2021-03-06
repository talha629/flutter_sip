import 'package:flutter/material.dart';
import 'package:sip_ua/sip_ua.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterWidget extends StatefulWidget {
  final SIPUAHelper _helper;
  RegisterWidget(this._helper, {Key key}) : super(key: key);
  @override
  _MyRegisterWidget createState() => _MyRegisterWidget();
}

class _MyRegisterWidget extends State<RegisterWidget>
    implements SipUaHelperListener {
  String _password;
  String _wsUri;
  String _sipUri;
  String _displayName;
  String _authorizationUser;
  Map<String, String> _wsExtraHeaders = {
    'Origin': ' https://stream.prankdial.com',
    'Host': 'stream.prankdial.com:8089'
  };
  SharedPreferences _preferences;
  RegistrationState _registerState;

  SIPUAHelper get helper => widget._helper;

  @override
  initState() {
    super.initState();
    _registerState = helper.registerState;
    helper.addSipUaHelperListener(this);
    _loadSettings();
  }

  @override
  deactivate() {
    super.deactivate();
    helper.removeSipUaHelperListener(this);
    _saveSettings();
  }
  String pdWebSocket = 'wss://' + "stream.prankdial.com" + ':8089/ws';
  String pdURI = 'ws_stream' + "@" + 'stream.prankdial.com';
  String pdUser = 'ws_stream';
  String pdPass = '12345';


  String testWebSocket = 'ws://' + "3.20.234.178" + ':8088/ws';
  String testURI = '1060@3.20.234.178:50600';
  String testUser = '1060';
  String testPass = 'password';



  void _loadSettings() async {
    _preferences = await SharedPreferences.getInstance();
    this.setState(() {
      _wsUri = testWebSocket;
      _sipUri = testURI;
      _displayName = testUser;
      _password = testPass;
      _authorizationUser = testUser;

//      _wsUri = pdWebSocket;
//      _sipUri = pdURI;
//      _displayName = pdUser;
//      _password = pdPass;
//      _authorizationUser = pdUser;
          //_preferences.getString('ws_uri') ?? 'wss://3.214.113.227:8089';

          //_preferences.getString('sip_uri') ?? 'outbound@3.214.113.227';

          //_preferences.getString('display_name') ?? 'Flutter SIP UA';

          //_preferences.getString('password') ?? '12345678';

          //_preferences.getString('auth_user') ?? 'outbound';
    });
  }

  void _saveSettings() {
    _preferences.setString('ws_uri', _wsUri);
    _preferences.setString('sip_uri', _sipUri);
    _preferences.setString('display_name', _displayName);
    _preferences.setString('password', _password);
    _preferences.setString('auth_user', _authorizationUser);
  }

  @override
  void registrationStateChanged(RegistrationState state) {
    this.setState(() {
      _registerState = state;
    });
  }

  void _alert(BuildContext context, String alertFieldName) {
    showDialog<Null>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$alertFieldName is empty'),
          content: Text('Please enter $alertFieldName!'),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _handleSave(BuildContext context) {
    if (_wsUri == null) {
      _alert(context, "WebSocket URL");
    } else if (_sipUri == null) {
      _alert(context, "SIP URI");
    }

    UaSettings settings = UaSettings();

    settings.webSocketUrl = _wsUri;
//    settings.webSocketSettings.extraHeaders = _wsExtraHeaders;
//    settings.webSocketSettings.allowBadCertificate = true;
//    settings.webSocketSettings.userAgent = 'Dart/2.8 (dart:io) for OpenSIPS.';

    settings.uri = _sipUri;
    settings.authorizationUser = _authorizationUser;
    settings.password = _password;
    settings.displayName = _displayName;
    settings.userAgent = 'Dart SIP Client v1.0.0';

    helper.start(settings);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("SIP Account"),
        ),
        body: Align(
            alignment: Alignment(0, 0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(48.0, 18.0, 48.0, 18.0),
                        child: Center(
                            child: Text(
                          'Register Status: ${EnumHelper.getName(_registerState.state)}',
                          style: TextStyle(fontSize: 18, color: Colors.black54),
                        )),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(48.0, 18.0, 48.0, 0),
                        child: Align(
                          child: Text('WebSocket:'),
                          alignment: Alignment.centerLeft,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(48.0, 0.0, 48.0, 0),
                        child: TextField(
                          keyboardType: TextInputType.text,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black12)),
                            hintText: _wsUri,
                          ),
                          onChanged: (value) {
                            setState(() {
                              _wsUri = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(46.0, 18.0, 48.0, 0),
                        child: Align(
                          child: Text('SIP URI:'),
                          alignment: Alignment.centerLeft,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(48.0, 0.0, 48.0, 0),
                        child: TextField(
                          keyboardType: TextInputType.text,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black12)),
                            hintText: _sipUri,
                          ),
                          onChanged: (value) {
                            setState(() {
                              _sipUri = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(46.0, 18.0, 48.0, 0),
                        child: Align(
                          child: Text('Authorization User:'),
                          alignment: Alignment.centerLeft,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(48.0, 0.0, 48.0, 0),
                        child: TextField(
                          keyboardType: TextInputType.text,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black12)),
                            hintText: _authorizationUser ?? '[Empty]',
                          ),
                          onChanged: (value) {
                            setState(() {
                              _authorizationUser = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(46.0, 18.0, 48.0, 0),
                        child: Align(
                          child: Text('Password:'),
                          alignment: Alignment.centerLeft,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(48.0, 0.0, 48.0, 0),
                        child: TextField(
                          keyboardType: TextInputType.text,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black12)),
                            hintText: _password ?? '[Empty]',
                          ),
                          onChanged: (value) {
                            setState(() {
                              _password = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(46.0, 18.0, 48.0, 0),
                        child: Align(
                          child: Text('Display Name:'),
                          alignment: Alignment.centerLeft,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(48.0, 0.0, 48.0, 0),
                        child: TextField(
                          keyboardType: TextInputType.text,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black12)),
                            hintText: _displayName,
                          ),
                          onChanged: (value) {
                            setState(() {
                              _displayName = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 18.0, 0.0, 0.0),
                      child: Container(
                        height: 48.0,
                        width: 160.0,
                        child: MaterialButton(
                          child: Text(
                            'Register',
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.white),
                          ),
                          color: Colors.blue,
                          textColor: Colors.white,
                          onPressed: () => _handleSave(context),
                        ),
                      ))
                ])));
  }

  @override
  void callStateChanged(Call call, CallState state) {
    //NO OP
  }

  @override
  void transportStateChanged(TransportState state) {}

  @override
  void onNewMessage(SIPMessageRequest msg) {
    // NO OP
  }
}
