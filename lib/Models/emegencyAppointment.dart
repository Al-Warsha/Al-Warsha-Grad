


class emergencyAppointment {
  String id;
  String car;
  String description;
  //GeoPoint? currentlocation;
  double latitude;
  double longitude;
  int hour; // New field for hour component
  int minute; // New field for minute component


  emergencyAppointment({this.id='',required this.car, required this.description,required this.latitude, required this.longitude,
        required this.hour, required this.minute});

  Map<String, dynamic>toJson(){
    return{
      "id": id,
      "car": car,
      "description": description,
      "latitude": latitude,
      "longitude": longitude,
      "hour":hour,
      "minute":minute
    };
  }

  emergencyAppointment.fromJson(Map <String, dynamic> json):this(
      id: json['id'],
      car: json['car'],
      description: json['description'],
      latitude: json['latitude'],
     longitude: json['longitude'],
      hour: json['hour'],
      minute: json['minute']
  );
}



//emegencyAppointment