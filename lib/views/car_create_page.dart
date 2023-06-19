import 'package:flutter/material.dart';
import 'package:wire_app2/api.dart';
import 'package:wire_app2/models/car_model.dart';

class CarCreatePage extends StatefulWidget {
  CarCreatePage({Key? key}) : super(key: key);

  @override
  _CarCreatePageState createState() => _CarCreatePageState();
}

class _CarCreatePageState extends State<CarCreatePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _carRangeController;
  late TextEditingController _efficiencyController;
  late TextEditingController _modelController;

  @override
  void initState() {
    super.initState();
    _carRangeController = TextEditingController();
    _efficiencyController = TextEditingController();
    _modelController = TextEditingController();
  }

  @override
  void dispose() {
    _carRangeController.dispose();
    _efficiencyController.dispose();
    _modelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Create a Car',
          style: TextStyle(color: Colors.orange),
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.orange),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 10,
                    bottom: MediaQuery.of(context).size.height / 20,
                  ),
                  child: formField(_carRangeController, 'Enter Car Range',
                      Icon(Icons.directions_car, color: Colors.grey)),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height / 15,
                  ),
                  child: formField(_efficiencyController, 'Enter Efficiency',
                      Icon(Icons.electric_car_outlined, color: Colors.grey)),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height / 15,
                  ),
                  child: formField(_modelController, 'Enter Model',
                      Icon(Icons.model_training, color: Colors.grey)),
                ),
                GestureDetector(
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      final carModel = CarModel(
                        carRange: int.tryParse(_carRangeController.text),
                        efficiency: _efficiencyController.text,
                        model: _modelController.text,
                      );

                      final createdCarModel =
                          await Api.createCar(car: carModel);
                      if (createdCarModel != null) {
                        // If the car is created successfully, navigate back to the previous page.
                        Navigator.pop(context);
                      } else {
                        // If the car creation failed, show a message.
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Car creation failed.')),
                        );
                      }
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height / 22,
                      width: MediaQuery.of(context).size.width / 2,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          'Create Car',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget formField(
      TextEditingController controller, String hintText, Icon icon) {
    return Container(
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.transparent,
      ),
      height: MediaQuery.of(context).size.height / 15,
      width: MediaQuery.of(context).size.width / 1.1,
      child: TextField(
        controller: controller,
        style: TextStyle(color: Colors.black),
        cursorColor: Colors.orange,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.orange),
            borderRadius: BorderRadius.circular(20),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.orange),
          ),
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.black.withOpacity(0.5),
            fontWeight: FontWeight.w400,
            fontFamily: "Poppins",
            fontStyle: FontStyle.normal,
            fontSize: 16.0,
          ),
          prefixIcon: icon,
        ),
      ),
    );
  }
}
