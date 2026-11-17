
import 'package:fit_track_pro/features/weigths/models/weight_model.dart';
import 'package:fit_track_pro/features/weigths/screens/add_weight_screen.dart';
import 'package:fit_track_pro/features/workouts/screens/home_screen.dart';
import 'package:flutter/material.dart';

class WeightScreen extends StatefulWidget{
  const WeightScreen({super.key});

  @override
  State<WeightScreen> createState () => _WeightScreenState();
}

class _WeightScreenState extends State<WeightScreen>{
  List<WeightModel> weightList = [];

  Future<void> _navigateToAddWeigth() async{
    final newWeight = await Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => AddWeightScreen())
      );
    if(newWeight !=  null && newWeight is WeightModel){
      setState(() {
         weightList.add(WeightModel(
        fecha: newWeight.fecha, pesoKilos: newWeight.pesoKilos));
      });

    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        title: Center(child: Text("Mis pesos"),),
      ),
      body: weightList.isEmpty
        ? Center(child: Text('No hay registros'))
        : ListView.builder(
          itemCount: weightList.length,
          itemBuilder: (context, index){
            final weightItem = weightList[index];
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 12, vertical:6),
              child: ListTile(
                leading: Icon(Icons.monitor_heart),
                title: Text(weightItem.fecha),
                subtitle: Text('${weightItem.pesoKilos} kg'),
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _navigateToAddWeigth,
          child: Icon(Icons.add),),
    );

  }
}