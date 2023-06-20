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

  //required this.mechanicid,required this.userid,
  scheduleAppointment({this.id='',required this.date, required this.mechanicid,required this.userid,
    required this.hour,required this.minute,
    required this.description, required this.car,  this.rateDescription='null', this.rate=0, this.state='pending',
    this.done=false});

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
      "done":done
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
      done: json['done']
  );
}

