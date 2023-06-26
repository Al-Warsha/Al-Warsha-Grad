class winchAppointment {
  String id;
  String? mechanicid;
  String? userid;
  //String car;
  double latitude;
  double longitude;
  int hour; // New field for hour component
  int minute;// New field for minute component
  String rateDescription;
  int rate;
  String state;
  bool done;
  num Unotification_sent;
  num Bnotification_sent;

//, this.car='car 3 l7d mzbotha'
  winchAppointment({this.id='',required this.mechanicid,required this.userid,
    required this.latitude, required this.longitude,
    required this.hour, required this.minute, this.rateDescription='null', this.rate=0, this.state='pending',
    this.done=false, this.Unotification_sent=0,this.Bnotification_sent=0});

  Map<String, dynamic>toJson(){
    return{
      "id": id,
      "mechanicid": mechanicid,
      "userid": userid,
      //"car": car,
      "latitude": latitude,
      "longitude": longitude,
      "hour":hour,
      "minute":minute,
      "rateDescription": rateDescription,
      "rate":rate,
      "state":state,
      "done":done,
      "Unotification_sent":Unotification_sent,
      "Bnotification_sent":Bnotification_sent
    };
  }

  winchAppointment.fromJson(Map <String, dynamic> json):this(
      id: json['id'],
      mechanicid: json['mechanicid'],
      userid: json['userid'],
      //car: json['car'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      hour: json['hour'],
      minute: json['minute'],
      rateDescription: json['rateDescription'],
      rate: json['rate'],
      state: json['state'],
      done: json['done'],
      Unotification_sent: json['Unotification_sent'],
      Bnotification_sent: json['Bnotification_sent']
  );
}


