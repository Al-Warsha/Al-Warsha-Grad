class emergencyAppointment {
  String id;
  String? mechanicid;
  String? userid;
  String car;
  String description;
  double latitude;
  double longitude;
  // int hour; // New field for hour component
  // int minute;// New field for minute component
  String rateDescription;
  int rate;
  String state;
  bool done;
  num Unotification_sent;
  num Bnotification_sent;
  String timestamp;


  // required this.hour, required this.minute,

  emergencyAppointment({this.id='',required this.car, required this.mechanicid,required this.userid,
    required this.description,required this.latitude, required this.longitude, required this.timestamp,
     this.rateDescription='null', this.rate=0, this.state='pending',
    this.done=false, this.Unotification_sent=0,this.Bnotification_sent=0});

  Map<String, dynamic>toJson(){
    return{
      "id": id,
      "mechanicid": mechanicid,
      "userid": userid,
      "car": car,
      "description": description,
      "latitude": latitude,
      "longitude": longitude,
      // "hour":hour,
      // "minute":minute,
      "rateDescription": rateDescription,
      "rate":rate,
      "state":state,
      "done":done,
      "Unotification_sent":Unotification_sent,
      "Bnotification_sent":Bnotification_sent,
      'timestamp': timestamp,

    };
  }

  emergencyAppointment.fromJson(Map <String, dynamic> json):this(
      id: json['id'],
      mechanicid: json['mechanicid'],
      userid: json['userid'],
      car: json['car'],
      description: json['description'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      // hour: json['hour'],
      // minute: json['minute'],
      rateDescription: json['rateDescription'],
      rate: json['rate'],
      state: json['state'],
      done: json['done'],
      Unotification_sent: json['Unotification_sent'],
      Bnotification_sent: json['Bnotification_sent'],
    timestamp: json['timestamp'],
  );
}
