class WorkoutModel{
  final int? localID;
  //final int? apiID;
  final String title;
  final String category;
  final int durationMinutes;

  WorkoutModel({
    this.localID,
    //this.apiID,
    required this.title,
    required this.category,
    required this.durationMinutes,
  });

  Map<String, dynamic> toMap(){
    return{
      'id' : localID,
      //'api_id' : apiID,
      'title' : title,
      'category' : category,
      'duration_minutes' : durationMinutes,
    };
  }

  factory WorkoutModel.fromMap(Map<String, dynamic> map){
    return WorkoutModel(
      localID: map['id'],
      //apiID: map['api_id'],
      title: map['title'], 
      category: map['category'], 
      durationMinutes: map['duration_minutes'],
    );
  }
}