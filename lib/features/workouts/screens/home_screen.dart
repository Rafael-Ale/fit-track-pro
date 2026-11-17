import 'package:fit_track_pro/core/storage/local_storage_service.dart';
import 'package:fit_track_pro/features/auth/screens/login_screen.dart';
import 'package:fit_track_pro/features/workouts/models/workout_model.dart';
import 'package:fit_track_pro/features/workouts/screens/add_workout_screen.dart';
import 'package:fit_track_pro/features/workouts/screens/detail_workout.dart';
import 'package:fit_track_pro/features/workouts/services/local_workout_service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget{
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  final LocalWorkoutService _dbService = LocalWorkoutService();

  List<WorkoutModel> _workouts = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadWorkouts();
  }

  Future<void> _loadWorkouts() async{
    setState((){
      _isLoading = true;
    });

    final workouts = await _dbService.getWorkouts();

    setState(() {
      _workouts = workouts;
      _isLoading = false;
    });
  }

  void _logout() async{
    final storage = LocalStorageService();
    await storage.deleteToken();
    if(!mounted) return;
    
    Navigator.pushAndRemoveUntil(context, 
      MaterialPageRoute(
        builder: (context) => LoginScreen()),
        (Route<dynamic> route) => false,
    );
  }

  Future<void> _navigateToAddWorkout() async{
    final newWorkout = await Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => AddWorkoutScreen()),  
    );
    if(newWorkout != null && newWorkout is WorkoutModel){
      await _dbService.insertWorkout(newWorkout);
      await _loadWorkouts();

      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Rutina creada exitosamente'),
            backgroundColor: Colors.green,
          )
        );
      }
    }
  }



  Future<void> _deleteWorkout(int id, String title) async{
    await _dbService.deleteWorkout(id);
    _loadWorkouts();

    if(mounted){
      _loadWorkouts();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Rutina eliminada: $title'))
      );
    }
  }

  Future <void> _updateWorkout(WorkoutModel workout) async{
    final TextEditingController titleController = TextEditingController(
      text: workout.title
    );
    final List<String> categories = ['Fuerza', 'Cardio', 'Flexibilidad'];
    final TextEditingController durationController = TextEditingController(
      text: workout.durationMinutes.toString()
    );

    String? selectedCategory = categories.contains(workout.category)? workout.category : null;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Editar rutina'),
        content: StatefulBuilder(
          builder: (context, setDialogState){
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText:'Título'),
                ),
                DropdownButtonFormField(
                  initialValue: selectedCategory,
                  decoration: InputDecoration(labelText: 'Categoría'),
                  items: categories.map((category)=> DropdownMenuItem(value: category, child: Text(category))).toList(),
                  onChanged: (value) {
                    setDialogState(() => selectedCategory = value);
                  },
                ),
                TextField(
                  controller: durationController,
                  decoration: InputDecoration(labelText: 'Duración(min)'),
                  keyboardType: TextInputType.number,
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: ()=>Navigator.pop(context, false), 
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: ()=>Navigator.pop(context, true), 
            child: Text('Guardar')
          ),
        ],
      ),
    );
    if(confirmed == true){
      final updatedWorkout = WorkoutModel(
        localID: workout.localID,
        title: titleController.text.trim(),
        category: selectedCategory ?? workout.category,
        durationMinutes: int.tryParse(durationController.text) ?? workout.durationMinutes,
      );

      await _dbService.updateWorkout(updatedWorkout);
      _loadWorkouts();
      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Rutina actualizada: ${updatedWorkout.title}'))
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mis entrenamientos"),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: (){
              showDialog(
                context: context, 
                builder: (context) => AlertDialog(
                  title: Text('¿Cerrar sesión?'),
                  content: Text('Tendras que volver a ingresar tus datos'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context), 
                      child: Text('Cancelar')
                    ),
                    ElevatedButton(
                      onPressed: (){
                        Navigator.pop(context);
                        _logout();
                      }, 
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red
                      ),
                      child: Text(
                        'Salir',
                        style: TextStyle(color:Colors.white),
                      )
                    )
                  ],
                )
              );
            }, 
            icon:Icon(Icons.logout))
        ],
      ),
      body: _isLoading
      ? Center(child: CircularProgressIndicator(),)
        : _workouts.isEmpty 
        ? Center(child:Text('No tienes rutinas creadas'),)
          : ListView.builder(
            itemCount:_workouts.length,
            itemBuilder: (context, index){
            final workout = _workouts[index];
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: CircleAvatar(child: Icon(Icons.fitness_center),),
                title: Text(workout.title, style: TextStyle(fontWeight: FontWeight.bold),),
                subtitle: Text('${workout.category} - ${workout.durationMinutes} min'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => _deleteWorkout(workout.localID!, workout.title), 
                      icon: Icon(Icons.delete, color: Colors.red)
                    ),
                    IconButton(
                      onPressed: () => _updateWorkout(workout), 
                      icon: Icon(Icons.edit, color: Colors.blue)
                    ),
                  ],
                ),
                // trailing: IconButton(
                //   onPressed: () => _deleteWorkout(workout.localID!, workout.title), 
                //   icon: Icon(Icons.delete, color: Colors.red)),
                onTap: () {
                  Navigator.push(context,
                  MaterialPageRoute(builder: (context) => DetailWorkout(workout: workout)));
                },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddWorkout(),
        child: Icon(Icons.add),
      ),
    );
  }
}


//   void _showAddWorkoutDialog(){
//     final titleController = TextEditingController();
//     final categoryController = TextEditingController();
//     final durationMinutesController = TextEditingController();

//     showDialog(
//       context: context, 
//       builder: (context) => AlertDialog(
//         title : Text('Nueva rutina'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: titleController,
//               decoration: InputDecoration(labelText: 'Nombre'),
//             ),
//             TextField(
//               controller: categoryController,
//               decoration: InputDecoration(labelText: 'Categoría'),
//             ),
//             TextField(
//               controller: durationMinutesController,
//               decoration: InputDecoration(labelText: 'Duración (minutos)'),
//               keyboardType: TextInputType.number,
//             )
//           ],
//         ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(context), 
//           child: Text('Cancelar')
//         ),
//         ElevatedButton(
//           onPressed: () async {
//             if(titleController.text.isNotEmpty && durationMinutesController.text.isNotEmpty && categoryController.text.isNotEmpty){
//               final newWorkout = WorkoutModel(
//                 title: titleController.text,
//                 category: categoryController.text,
//                 durationMinutes: int.parse(durationMinutesController.text)
//               );

//               await _dbService.insertWorkout(newWorkout);

//               if(mounted){
//                 Navigator.pop(context);
//                 _loadWorkouts();
//               }
//             }
//           }, 
//           child: Text('Guardar')
//         ),
//       ],
//     )
//   );
// }