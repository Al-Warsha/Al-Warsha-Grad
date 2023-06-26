class scheduleAppointment {
  String id;
  String? mechanicid;
   String? userid;
  int date;
  int hour; // New field for hour component
  int minute; // New field for minute component
  String description;
  String car;
  String rateDescription;
  int rate;
  String state;
  bool done;
  num Unotification_sent;
  num Bnotification_sent;

  //required this.mechanicid,required this.userid,
  scheduleAppointment({this.id='',required this.date, required this.mechanicid,required this.userid,
    required this.hour,required this.minute,
    required this.description, required this.car,  this.rateDescription='null', this.rate=0, this.state='pending',
    this.done=false, this.Unotification_sent=0, this.Bnotification_sent=0});

  Map<String, dynamic>toJson(){
    return{
      "id": id,
       "mechanicid": mechanicid,
       "userid": userid,
      "car": car,
      "description": description,
      "date":date,
      "hour":hour,
      "minute":minute,
      "rateDescription": rateDescription,
      "rate":rate,
      "state":state,
      "done":done,
      "Unotification_sent":Unotification_sent,
      "Bnotification_sent":Bnotification_sent,
    };
  }

  scheduleAppointment.fromJson(Map <String, dynamic> json):this(
      id: json['id'],
       mechanicid: json['mechanicid'],
      userid: json['userid'],
      car: json['car'],
      description: json['description'],
      date: json['date'],
      hour: json['hour'],
      minute: json['minute'],
      rateDescription: json['rateDescription'],
      rate: json['rate'],
      state: json['state'],
      done: json['done'],
      Unotification_sent: json['Unotification_sent'],
    Bnotification_sent: json['Bnotification_sent'],
  );
}

