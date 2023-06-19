import 'package:flutter/material.dart';
import 'package:wire_app2/api.dart';
import 'package:wire_app2/main.dart';
import 'package:wire_app2/models/reservation_model.dart';
import 'package:wire_app2/models/station_model.dart';

class ReservePage extends StatefulWidget {
  final StationModel station;

  ReservePage({required this.station});

  @override
  _ReservePageState createState() => _ReservePageState();
}

class _ReservePageState extends State<ReservePage> {
  TextEditingController durationController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Reserve',
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
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 3.8,
                child: Image.asset(
                  "assets/undraw_order_a_car_3tww.png",
                  fit: BoxFit
                      .contain, // Görüntüyü tam ortalamak için fit: BoxFit.contain ekledik
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 10,
                  bottom: MediaQuery.of(context).size.height / 20,
                ),
                child: Container(
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.transparent,
                  ),
                  height: MediaQuery.of(context).size.height / 15,
                  width: MediaQuery.of(context).size.width / 1.1,
                  child: TextField(
                    controller: durationController,
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
                      hintText: 'Duration',
                      hintStyle: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                        fontWeight: FontWeight.w400,
                        fontFamily: "Poppins",
                        fontStyle: FontStyle.normal,
                        fontSize: 16.0,
                      ),
                      prefixIcon: Icon(Icons.access_time, color: Colors.grey),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height / 15,
                ),
                child: Container(
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.transparent,
                  ),
                  height: MediaQuery.of(context).size.height / 15,
                  width: MediaQuery.of(context).size.width / 1.1,
                  child: TextField(
                    controller: dateController,
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
                      hintText: 'Date (year-month-day ex: 2023-01-01)',
                      hintStyle: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                        fontWeight: FontWeight.w400,
                        fontFamily: "Poppins",
                        fontStyle: FontStyle.normal,
                        fontSize: 16.0,
                      ),
                      prefixIcon:
                          Icon(Icons.calendar_today, color: Colors.grey),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  final duration = int.tryParse(durationController.text);
                  final date = dateController.text;

                  if (duration != null && date.isNotEmpty) {
                    int clientID = await Api().getDecodedId();
                    final reservationRequest = ReservationModel(
                      host: widget.station.host,
                      client: clientID,
                      station: widget.station.id,
                      duration: duration,
                      date: date,
                      price: widget.station.price,
                      isApproved: true,
                    );
                    final reservation = await Api.createReservation(
                      reservationRequest: reservationRequest,
                    );

                    if (reservation != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Reservation completed'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      // 2 saniye bekletip, Home sayfasına yönlendir.
                      await Future.delayed(Duration(seconds: 2));
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Home()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Reservation failed'),
                          duration: Duration(seconds: 2),
                        ),
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
                        'Complete My Reservation',
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
    );
  }
}

class ReservationDetailsPage extends StatelessWidget {
  final ReservationModel reservation;

  ReservationDetailsPage({required this.reservation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Reservation Details',
          style: TextStyle(color: Colors.orange),
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.orange),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            ListTile(
              title: Text(
                'Host',
                style: TextStyle(color: Colors.orange, fontSize: 21),
              ),
              subtitle: Text(
                '${reservation.host}',
                style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(height: 10),
            ListTile(
              title: Text(
                'Client ID',
                style: TextStyle(color: Colors.orange, fontSize: 21),
              ),
              subtitle: Text(
                '${reservation.client}',
                style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(height: 10),
            ListTile(
              title: Text(
                'Station ID',
                style: TextStyle(color: Colors.orange, fontSize: 21),
              ),
              subtitle: Text(
                '${reservation.station}',
                style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(height: 10),
            ListTile(
              title: Text(
                'Duration',
                style: TextStyle(color: Colors.orange, fontSize: 21),
              ),
              subtitle: Text(
                '${reservation.duration}',
                style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(height: 10),
            ListTile(
              title: Text(
                'Date',
                style: TextStyle(color: Colors.orange, fontSize: 21),
              ),
              subtitle: Text(
                '${reservation.date}',
                style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(height: 10),
            ListTile(
              title: Text(
                'Price',
                style: TextStyle(color: Colors.orange, fontSize: 21),
              ),
              subtitle: Text(
                '${reservation.price}',
                style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: GestureDetector(
                onTap: () async {
                  await Api.deleteReservation(reservation.id!);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Reservation deleted'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  await Future.delayed(Duration(seconds: 2));
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Home()),
                  );
                },
                child: Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height / 22,
                  width: MediaQuery.of(context).size.width / 2.8,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      "Delete Reservation",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
