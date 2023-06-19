import 'package:flutter/material.dart';
import 'package:wire_app2/api.dart';
import 'package:wire_app2/models/car_model.dart';

class CarViewPage extends StatelessWidget {
  final int id;

  CarViewPage(this.id);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Car Details',
          style: TextStyle(color: Colors.orange),
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.orange),
      ),
      body: FutureBuilder(
        future: Api.getCar(id),
        builder: (BuildContext context, AsyncSnapshot<CarModel?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData) {
            return Text('No data found.');
          } else {
            CarModel car = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height / 3,
                    child: Image.asset(
                      "assets/undraw_City_driver_re_9xyv.png", // Replace this with your car image asset
                      // To center the image use fit: BoxFit.contain
                    ),
                  ),
                  SizedBox(
                      height: 10), // To create space between image and details
                  ListTile(
                    title: Text(
                      'Model',
                      style: TextStyle(color: Colors.orange, fontSize: 21),
                    ),
                    subtitle: Text(
                      '${car.model ?? 'N/A'}',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  SizedBox(height: 10),
                  ListTile(
                    title: Text(
                      'Car Range',
                      style: TextStyle(color: Colors.orange, fontSize: 21),
                    ),
                    subtitle: Text(
                      '${car.carRange ?? 'N/A'}',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  SizedBox(height: 10),
                  ListTile(
                    title: Text(
                      'Efficiency',
                      style: TextStyle(color: Colors.orange, fontSize: 21),
                    ),
                    subtitle: Text(
                      '${car.efficiency ?? 'N/A'}',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
