import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class VoiceApp extends StatefulWidget {
  final BluetoothCharacteristic characteristic;

  VoiceApp(this.characteristic);

  @override
  _VoiceAppState createState() => _VoiceAppState(characteristic);
}

class _VoiceAppState extends State<VoiceApp> {
  final BluetoothCharacteristic characteristic;

  _VoiceAppState(this.characteristic);

  stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Press the button and start speaking';

  @override
  void initState() {
    _speech = stt.SpeechToText();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PreferredSizeWidget appBar = AppBar(
      title: Text('VoiceApp'),
    );
    return Scaffold(
        appBar: appBar,
        body: Center(
          child: SingleChildScrollView(
            reverse: true,
            child: Container(
              height: (MediaQuery.of(context).size.height -
                      appBar.preferredSize.height -
                      MediaQuery.of(context).padding.top) *
                  0.8,
              //margin: EdgeInsets.all(30),
              padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
              //decoration: BoxDecoration(
              //border: Border.all(
              //width: 1,
              //color: Theme.of(context).primaryColor,
              //),
              /////////////////////////////////////////////////////
              //child: TextHighlight(
              //textAlign: TextAlign.center,
              //text: _text,
              //words: _highlights,
              //textStyle: const TextStyle(
              //fontSize: 32.0,
              //color: Colors.black,
              //fontWeight: FontWeight.w400,
              //),
              child: Text(
                (_text.toLowerCase().contains('wave') ||
                        _text.toLowerCase().contains('1') ||
                        _text.toLowerCase().contains('2') ||
                        _text.toLowerCase().contains('3') ||
                        _text.toLowerCase().contains('4') ||
                        _text.toLowerCase().contains('5') ||
                        _text.toLowerCase().contains('hold') ||
                        _text.toLowerCase().contains('release') ||
                        _text.toLowerCase().contains('rock') ||
                        _text.toLowerCase().contains('cuss'))
                    //              (_text.toLowerCase() == 'wave' ||
                    //                      _text.toLowerCase() == '1' ||
                    //                      _text.toLowerCase() == '2' ||
                    //                      _text.toLowerCase() == '3' ||
                    //                      _text.toLowerCase() == '4' ||
                    //                      _text.toLowerCase() == '5' ||
                    //                      _text.toLowerCase() == 'hold' ||
                    //                      _text.toLowerCase() == 'release' ||
                    //                      _text.toLowerCase() == 'rock' ||
                    //                      _text.toLowerCase() == 'cuss')
                    ? _text.toUpperCase()
                    : _text,
                style: TextStyle(
                  fontSize: 32,
                  color: (_text.toLowerCase().contains('wave') ||
                          _text.toLowerCase().contains('1') ||
                          _text.toLowerCase().contains('2') ||
                          _text.toLowerCase().contains('3') ||
                          _text.toLowerCase().contains('4') ||
                          _text.toLowerCase().contains('5') ||
                          _text.toLowerCase().contains('hold') ||
                          _text.toLowerCase().contains('release') ||
                          _text.toLowerCase().contains('rock') ||
                          _text.toLowerCase().contains('cuss'))
                      ? Colors.green
                      : Colors.black,
                  fontWeight: (_text.toLowerCase().contains('wave') ||
                          _text.toLowerCase().contains('1') ||
                          _text.toLowerCase().contains('2') ||
                          _text.toLowerCase().contains('3') ||
                          _text.toLowerCase().contains('4') ||
                          _text.toLowerCase().contains('5') ||
                          _text.toLowerCase().contains('hold') ||
                          _text.toLowerCase().contains('release') ||
                          _text.toLowerCase().contains('rock') ||
                          _text.toLowerCase().contains('cuss'))
                      ? FontWeight.bold
                      : FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: AvatarGlow(
          animate: _isListening,
          endRadius: 75,
          glowColor: Theme.of(context).accentColor,
          duration: const Duration(milliseconds: 2500),
          repeatPauseDuration: const Duration(milliseconds: 50),
          repeat: true,
          child: FloatingActionButton(
            backgroundColor: Theme.of(context).primaryColor,
            onPressed: _listen,
            child: _isListening
                ? Icon(
                    Icons.mic,
                    color: Theme.of(context).accentColor,
                  )
                : Icon(
                    Icons.mic_none,
                    color: Colors.white,
                  ),
          ),
        ));
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      setState(() => _isListening = true);
      if (available) {
        //setState(() => _isListening = true);
        _speech.listen(onResult: (val) {
          setState(() {
            _text = val.recognizedWords;
          });
          if (_text.toLowerCase() == 'rock') {
            characteristic.write(utf8.encode('z'));
          }
          if (_text.toLowerCase() == 'cool') {
            characteristic.write(utf8.encode('y'));
          }
          if (_text.toLowerCase() == 'cuss') {
            characteristic.write(utf8.encode('x'));
          }
          if (_text.toLowerCase() == 'wave') {
            characteristic.write(utf8.encode('w'));
          } else if (_text.toLowerCase() == 'hold' ||
              _text.toLowerCase() == 'old' ||
              _text.toLowerCase() == 'cold') {
            characteristic.write(utf8.encode('h'));
          } else if (_text.toLowerCase() == 'release') {
            characteristic.write(utf8.encode('r'));
          } else if (_text.toLowerCase() == '1' ||
              _text.toLowerCase() == 'one') {
            characteristic.write(utf8.encode('1'));
          } else if (_text.toLowerCase() == '2' ||
              _text.toLowerCase() == 'two' ||
              _text.toLowerCase() == 'tu') {
            characteristic.write(utf8.encode('2'));
          } else if (_text.toLowerCase() == '3' ||
              _text.toLowerCase() == 'three' ||
              _text.toLowerCase() == 'tee') {
            characteristic.write(utf8.encode('3'));
          } else if (_text.toLowerCase() == '4' ||
              _text.toLowerCase() == 'four') {
            characteristic.write(utf8.encode('4'));
          } else if (_text.toLowerCase() == '5' ||
              _text.toLowerCase() == 'five') {
            characteristic.write(utf8.encode('5'));
          } else {
            characteristic.write(utf8.encode(_text));
          }
        });
      } else {
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            characteristic.write(utf8.encode(_text));
          }),
        );
      }
    } else {
      setState(() {
        _isListening = false;
        //_text = 'Just a sec';
      });
      _speech.stop();
    }
  }

  String get speechName {
    return _text;
  }
}
