class scheduleAppointment {
  String id;
  String? mechanicid;
   String? userid;
  int scheduleddate;
  int scheduledhour; // New field for hour component
  int scheduledminute; // New field for minute component
  String description;
  String car;
  String rateDescription;
  int rate;
  String state;
  bool done;
  num Unotification_sent;
  num Bnotification_sent;
  String timestamp;

  //required this.mechanicid,required this.userid,
  scheduleAppointment({this.id='',required this.scheduleddate, required this.mechanicid,required this.userid,
    required this.scheduledhour,required this.scheduledminute, required this.timestamp,
    required this.description, required this.car,  this.rateDescription='null', this.rate=0, this.state='pending',
    this.done=false, this.Unotification_sent=0, this.Bnotification_sent=0});

  Map<String, dynamic>toJson(){
    return{
      "id": id,
       "mechanicid": mechanicid,
       "userid": userid,
      "car": car,
      "description": description,
      "scheduleddate":scheduleddate,
      "scheduledhour":scheduledhour,
      "scheduledminute":scheduledminute,
      "rateDescription": rateDescription,
      "rate":rate,
      "state":state,
      "done":done,
      "Unotification_sent":Unotification_sent,
      "Bnotification_sent":Bnotification_sent,
      'timestamp': timestamp,
    };
  }

  scheduleAppointment.fromJson(Map <String, dynamic> json):this(
      id: json['id'],
       mechanicid: json['mechanicid'],
    timestamp: json['timestamp'],
      userid: json['userid'],
      car: json['car'],
      description: json['description'],
    scheduleddate: json['scheduleddate'],
    scheduledhour: json['scheduledhour'],
    scheduledminute: json['scheduledminute'],
      rateDescription: json['rateDescription'],
      rate: json['rate'],
      state: json['state'],
      done: json['done'],
      Unotification_sent: json['Unotification_sent'],
    Bnotification_sent: json['Bnotification_sent'],
  );
}

