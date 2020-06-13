import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:math';

////class Dashboard extends StatelessWidget {
////  final bool isRecording;
////  List<int> samples;
////  final DateTime startTime;
////
////  Dashboard(this.isRecording, {this.samples, this.startTime});
////
////  @override
////  Widget build(BuildContext context) {
////    return ListView(children: <Widget>[
////      ListTile(
////          leading: Icon(Icons.title),
////          title: Text("Microphone Streaming Example App")),
////      ListTile(
////          leading: Icon(Icons.input),
////          title: MaterialButton(
////            onPressed: null,
////            child: Text("This button does nothing"),
////          )),
////      ListTile(
////        leading: Icon(Icons.keyboard_voice),
////        title: Text((isRecording ? "Recording" : "Not recording")),
////      ),
////      ListTile(
////        leading: Icon(Icons.volume_up),
////        title: Text((isRecording
////            ? pow(samples.map((i) => pow(i, 2)).reduce((j, k) => j + k), 0.5)
////                .toString()
////            : "Not recording")),
////      ),
////      ListTile(
////          leading: Icon(Icons.access_time),
////          title: Text((isRecording
////              ? DateTime.now().difference(startTime).toString()
////              : "Not recording"))),
////    ]);
////  }
////}
//class Statistics extends StatelessWidget {
//  final bool isRecording;
//  List<int> samples;
//  final DateTime startTime;
//
//  Statistics(this.isRecording, {this.samples, this.startTime});
//
//  @override
//  Widget build(BuildContext context) {
//    return ListView(children: <Widget>[
//      ListTile(
//          leading: Icon(Icons.title),
//          title: Text("Microphone Streaming Example App")),
//      ListTile(
//          leading: Icon(Icons.input),
//          title: MaterialButton(
//            onPressed: null,
//            child: Text("This button does nothing"),
//          )),
//      ListTile(
//        leading: Icon(Icons.keyboard_voice),
//        title: Text((isRecording ? "Recording" : "Not recording")),
//      ),
//      ListTile(
//        leading: Icon(Icons.volume_up),
//        title: Text((isRecording
//            ? pow(samples.map((i) => pow(i, 2)).reduce((j, k) => j + k), 0.5)
//                .toString()
//            : "Not recording")),
//      ),
//      ListTile(
//          leading: Icon(Icons.access_time),
//          title: Text((isRecording
//              ? DateTime.now().difference(startTime).toString()
//              : "Not recording"))),
//    ]);
//  }
//}
//
//ListView(children: <Widget>[
//          ListTile(
//              leading: Icon(Icons.title),
//              title: Text("Am I too loud right now?")),
//          ListTile(
//            leading: Icon(Icons.keyboard_voice),
//            title: Text((isRecording ? "Recording" : "Not recording")),
//          ),
//          ListTile(
//            leading: Icon(Icons.ring_volume),
//            title: Text((isRecording
//                ? "Current Volume: ${volume.format(currentVolume)}"
//                : "Not recording")),
//          ),
//          ListTile(
//            leading: Icon(Icons.volume_down),
//            title: Text((isRecording
//                ? "Average Volume: ${volume.format(averageVolume)}2"
//                : "Not recording")),
//          ),
//          ListTile(
//            leading: Icon(Icons.volume_up),
//            title: Text((isRecording
//                ? "Max Volume: ${volume.format(maxVolume)}"
//                : "Not recording")),
//          ),
//          ListTile(
//            leading: Icon(Icons.format_list_numbered),
//            title: Text((isRecording
//                ? "# of Measurements: $countMeasurements"
//                : "Not recording")),
//          ),
//          ListTile(
//              leading: Icon(Icons.access_time),
//              title: Text((isRecording
//                  ? DateTime.now().difference(startTime).toString()
//                  : "Not recording"))),
//        ])
