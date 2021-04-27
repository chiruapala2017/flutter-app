class EventDetails {
  String _channelName;
  DateTime _date;
  String _from;
  String _to;
  String _url;

  EventDetails(this._channelName, this._date, this._from, this._to, this._url);


  String getChannelName(){
    return  this._channelName;
  }

  DateTime getDate(){
    return  this._date;
  }

  String getFrom(){
    return  this._from;
  }

  String getTo(){
    return  this._to;
  }

  String getUrl(){
    return  this._url;
  }

}