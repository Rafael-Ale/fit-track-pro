import 'package:fit_track_pro/features/weigths/models/weight_model.dart';
import 'package:flutter/material.dart';

class AddWeightScreen extends StatefulWidget{
  const AddWeightScreen({super.key});

  @override
  State<AddWeightScreen> createState() => _AddWeightScreenState();

}

class _AddWeightScreenState extends State<AddWeightScreen>{
  final _formKey = GlobalKey<FormState>();
  final _fechaController = TextEditingController();
  final _pesoKgController = TextEditingController();


  void _saveWeight(){
    if(_formKey.currentState!.validate()){
      final pesoKg = double.parse(_pesoKgController.text.trim().replaceAll(',', '.'));
      final newWeight = WeightModel(
        fecha: _fechaController.text.trim(), 
        pesoKilos: pesoKg
      );
      Navigator.pop(context, newWeight);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Agregar peso')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _fechaController,
                decoration: InputDecoration(
                  labelText: 'Fecha',
                  hintText: 'Ej. 17 de noviembre',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.date_range)
                ),
                validator: (value) {
                  if(value == null || value.trim().isEmpty){
                    return 'Por favor, ingrese una fecha';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20,),
              TextFormField(
                controller: _pesoKgController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText : 'Peso (kg)',
                  hintText: 'Ej. 75.5',
                  border: OutlineInputBorder(), 
                ),
                validator: (value){
                  if(value == null || value.trim().isEmpty){
                    return 'Por favor, ingrese un peso válido';
                  }
                  final numero = double.tryParse(value.trim().replaceAll(',','.'));
                  if(numero == null){
                    return 'Por favor ingrese un número válido';
                  }
                  if(numero <= 0){
                    return 'El peso debe ser mayor a cero';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20,),
              ElevatedButton(
                onPressed: _saveWeight, 
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(12),
                  )
                ),
                child: Text('Guardar rutina', style: TextStyle(fontSize: 18),),
                )
            ],
          ),
        )
      )
    );
  }
}
