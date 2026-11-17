import 'package:fit_track_pro/core/storage/local_storage_service.dart';
import 'package:fit_track_pro/features/auth/screens/login_screen.dart';
import 'package:fit_track_pro/features/weigths/screens/weight_screen.dart';
import 'package:fit_track_pro/features/workouts/screens/home_screen.dart';
import 'package:flutter/material.dart';

class AuthCheckScreen extends StatefulWidget{
  const AuthCheckScreen({super.key});

  @override
  State<AuthCheckScreen> createState() => _AuthCheckScreenState();
}

class _AuthCheckScreenState extends State<AuthCheckScreen>{
  final LocalStorageService _storage = LocalStorageService();
  
  @override
  void initState(){
    super.initState();
    _checkToken();
  }

  Future<void> _checkToken() async{
    final token = await _storage.getToken();
    if(!mounted) return;

    if(token != null && token.isNotEmpty ){
      //HOme
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => WeightScreen()),
      );
    }else{
      //Login
      Navigator.pushReplacement(context, 
      MaterialPageRoute(builder: (context)=>LoginScreen())
      );
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(body:Center(child: CircularProgressIndicator(),));
  }
}