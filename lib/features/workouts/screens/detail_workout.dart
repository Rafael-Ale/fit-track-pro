import 'package:fit_track_pro/features/workouts/models/workout_model.dart';
import 'package:flutter/material.dart';

class DetailWorkout extends StatelessWidget {
  final WorkoutModel workout;
  const DetailWorkout({super.key, required this.workout});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text(workout.title)),
      body: Center(
        child:Padding(
          padding: const EdgeInsets.all(24),
          child: Column(          
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                workout.title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium
              ),
              const SizedBox(height: 24,),
              Text(
                workout.category,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium
              ),
              const SizedBox(height: 8,),
              Text(
                workout.durationMinutes.toString(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium
              ),
              const SizedBox(height: 32,),
              ElevatedButton(
                onPressed: ()=>Navigator.pop(context), 
                child: const Text('Volver')
                ),
              ],
            ),
        ),
      ),
    );
  }
}