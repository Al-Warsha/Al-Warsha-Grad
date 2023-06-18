import 'dart:convert';

import 'package:flutter/material.dart';

class scheduleAppointment {
  String id;
  int date;
  int hour; // New field for hour component
  int minute; // New field for minute component
  String description;
  String car;


  scheduleAppointment({this.id='',required this.date, required this.hour,required this.minute, required this.description, required this.car});

  Map<String, dynamic>toJson(){
    return{
      "id": id,
      "car": car,
      "description": description,
      "date":date,
      "hour":hour,
      "minute":minute
    };
  }

  scheduleAppointment.fromJson(Map <String, dynamic> json):this(
    id: json['id'],
    car: json['car'],
    description: json['description'],
    date: json['date'],
    hour: json['hour'],
    minute: json['minute']
  );
}

