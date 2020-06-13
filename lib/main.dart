import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:math';
import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:mic_stream/mic_stream.dart';
import 'package:vibration/vibration.dart';
import 'circle_painter.dart';

enum Command {
  start,
  stop,
  change,
}

var volume = new NumberFormat("###,###", "en-US");

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Am I Too Loud',
      theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          scaffoldBackgroundColor: Colors.blueGrey[100]),
      home: AmITooLoudApp(),
    );
  }
}

class AmITooLoudApp extends StatefulWidget {
  @override
  _AmITooLoudAppState createState() => _AmITooLoudAppState();
}

class _AmITooLoudAppState extends State<AmITooLoudApp>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  Stream<List<int>> stream;
  StreamSubscription<List<int>> listener;
  List<int> currentSamples;
  final AUDIO_FORMAT = AudioFormat.ENCODING_PCM_16BIT;

  // Refreshes the Widget for every possible tick to force a rebuild of the sound wave
  AnimationController controller;

  Color _iconColor = Colors.white;
  bool isRecording = false;
  bool memRecordingState = false;
  bool isActive;
  DateTime startTime;

  double currentVolume = 0;
  double maxVolume = 0;
  int countMeasurements = 0;
  int loudMeasurements = 0;
  double averageVolume = 0;

  double volumeThreshold;
  double loudThreshold;

  int page = 0;
  List state = ["TooLoud", "Dashboard"];

  @override
  void initState() {
    print("Init application");
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    getThresholds();
    setState(() {
      initPlatformState();
    });
  }

  void _controlPage(int index) => setState(() => page = index);

  // Responsible for switching between recording / idle state
  void _controlMicStream({Command command: Command.change}) async {
    switch (command) {
      case Command.change:
        _changeListening();
        break;
      case Command.start:
        _startListening();
        break;
      case Command.stop:
        _stopListening();
        break;
    }
  }

  bool _changeListening() =>
      !isRecording ? _startListening() : _stopListening();

  bool _startListening() {
    if (isRecording) return false;
    stream = microphone(
        audioSource: AudioSource.DEFAULT,
        sampleRate: 16000,
        channelConfig: ChannelConfig.CHANNEL_IN_MONO,
        audioFormat: AUDIO_FORMAT);

    setState(() {
      isRecording = true;
      startTime = DateTime.now();
      currentVolume = 0;
      maxVolume = 0;
      countMeasurements = 0;
      averageVolume = 0;
      loudMeasurements = 0;
    });

    print("Start Listening to the microphone");
    listener = stream.listen((samples) => updateVolume(samples));
    return true;
  }

  void updateVolume(List<int> samples) {
    setState(() {
      currentSamples = samples;
      currentVolume = log(
          samples.map((i) => pow(i, 2)).reduce((j, k) => j + k) /
              samples.length);
      print("volume limit: $volumeThreshold, volume: $currentVolume");
      maxVolume = max(maxVolume, currentVolume);
      if (currentVolume > volumeThreshold) {
        countMeasurements = countMeasurements + 1;
        averageVolume =
            (averageVolume * (countMeasurements - 1) + currentVolume) /
                countMeasurements;
      }
      if (currentVolume > loudThreshold) {
        loudMeasurements = loudMeasurements + 1;
        Vibration.vibrate(duration: 500);
      }
    });
  }

  bool _stopListening() {
    if (!isRecording) return false;
    print("Stop Listening to the microphone");
    listener.cancel();

    setState(() {
      isRecording = false;
      currentSamples = null;
      startTime = null;
    });
    return true;
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    if (!mounted) return;
    isActive = true;

    controller =
        AnimationController(duration: Duration(seconds: 1), vsync: this)
          ..addListener(() {
            if (isRecording) {
              setState(() {});
            }
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed)
              controller.reverse();
            else if (status == AnimationStatus.dismissed) controller.forward();
          })
          ..forward();
  }

  Color _getVolColor() => (currentVolume > loudThreshold)
      ? Colors.red[300]
      : Colors.greenAccent[200];
  Color _getBgColor() => (isRecording) ? Colors.red : Colors.cyan;
  Icon _getIcon() =>
      (isRecording) ? Icon(Icons.stop) : Icon(Icons.keyboard_voice);

  void setThresholds(double volumeThreshold, double loudThreshold) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('volumeThreshold', volumeThreshold);
    await prefs.setDouble('loudThreshold', loudThreshold);
  }

  void getThresholds() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double volume = (prefs.getDouble('volumeThreshold') ?? 11);
    double loud = (prefs.getDouble('loudThreshold') ?? 16);
    setState(() {
      volumeThreshold = volume;
      loudThreshold = loud;
    });
    print('Volume: $volumeThreshold , Loud: $loudThreshold.');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Am I Too Loud?'),
        ),
        floatingActionButton: (page == 0)
            ? null
            : FloatingActionButton(
                onPressed: _controlMicStream,
                child: _getIcon(),
                foregroundColor: _iconColor,
                backgroundColor: _getBgColor(),
                tooltip: (isRecording) ? "Stop recording" : "Start recording",
              ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.face),
              title: Text("Am I Too Loud"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.view_list),
              title: Text("Dashboard"),
            ),
          ],
          backgroundColor: Colors.black26,
          elevation: 20,
          currentIndex: page,
          onTap: _controlPage,
        ),
        body: Center(
          child: (page == 0)
              ? Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Container(
                      child: CustomPaint(
                        painter: CirclePainter(
                          currentSamples,
                          _getVolColor(),
                          context,
                        ),
                      ),
                    ),
                    MaterialButton(
                      onPressed: _controlMicStream,
                      color: _getBgColor(),
                      textColor: _iconColor,
                      child: Icon(
                        (isRecording) ? Icons.stop : Icons.volume_up,
                        size: 96,
                      ),
                      padding: EdgeInsets.all(16),
                      shape: CircleBorder(),
                    ),
                  ],
                )
              : Column(children: <Widget>[
                  ListTile(
                      leading: Icon(Icons.title),
                      title: Text("Am I too loud right now?")),
                  ListTile(
                    leading: Icon(Icons.mic),
                    title: Text((isRecording ? "Recording" : "Not recording")),
                  ),
                  ListTile(
                    leading: Icon(Icons.ring_volume),
                    title: Text((isRecording
                        ? "Current Volume: ${volume.format(currentVolume)}"
                        : "Not recording")),
                  ),
                  ListTile(
                    leading: Icon(Icons.volume_down),
                    title:
                        Text("Average Volume: ${volume.format(averageVolume)}"),
                  ),
                  ListTile(
                    leading: Icon(Icons.volume_up),
                    title: Text("Max Volume: ${volume.format(maxVolume)}"),
                  ),
                  ListTile(
                    leading: Icon(Icons.format_list_numbered),
                    title: Text("# of Measurements: $countMeasurements"),
                  ),
                  ListTile(
                    leading: Icon(Icons.face),
                    title: Text("Loud Seconds: $loudMeasurements"),
                  ),
                  ListTile(
                      leading: Icon(Icons.access_time),
                      title: Text((isRecording
                          ? "Recording time: ${DateTime.now().difference(startTime).toString()}"
                          : "Not recording"))),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Colors.red[700],
                      inactiveTrackColor: Colors.red[100],
                      trackShape: RoundedRectSliderTrackShape(),
                      trackHeight: 4.0,
                      thumbShape:
                          RoundSliderThumbShape(enabledThumbRadius: 12.0),
                      thumbColor: Colors.redAccent,
                      overlayColor: Colors.red.withAlpha(32),
                      overlayShape:
                          RoundSliderOverlayShape(overlayRadius: 28.0),
                      tickMarkShape: RoundSliderTickMarkShape(),
                      activeTickMarkColor: Colors.red[700],
                      inactiveTickMarkColor: Colors.red[100],
                      valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                      valueIndicatorColor: Colors.redAccent,
                      valueIndicatorTextStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    child: RangeSlider(
                      values: RangeValues(volumeThreshold, loudThreshold),
                      min: 0,
                      max: 25,
                      divisions: 25,
                      labels: RangeLabels('${volume.format(volumeThreshold)}',
                          '${volume.format(loudThreshold)}'),
                      onChanged: (values) {
                        setThresholds(values.start, values.end);
                        getThresholds();
                      },
                    ),
                  ),
                ]),
        ),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      isActive = true;
      print("Resume app");

      _controlMicStream(
          command: memRecordingState ? Command.start : Command.stop);
    } else if (isActive) {
      memRecordingState = isRecording;
      _controlMicStream(command: Command.stop);

      print("Pause app");
      isActive = false;
    }
  }

  @override
  void dispose() {
    listener.cancel();
    controller.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}

//ToDO: fine-tune values
//https://stackoverflow.com/questions/49097889/how-to-calculate-the-decibel-of-audio-signal-and-record-the-audio-in-java

//TODO: package for release on store
//TODO: add icon

//TODO: re-design to make prettier
//TODO: prettier sound circle
//TODO: put some data into the button
//TODO: behavior for buttons
//Todo: Slider colors and labels to make more sense
