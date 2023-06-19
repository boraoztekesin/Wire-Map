import 'package:flutter/material.dart';
import 'package:wire_app2/api.dart';
import 'package:wire_app2/views/car_create_page.dart';
import 'package:wire_app2/views/car_view.dart';
import 'package:wire_app2/views/reserve_page.dart';

import '../models/car_model.dart';
import '../models/reservation_model.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          "My Cars",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                      FutureBuilder<List<CarModel>?>(
                        future: Api.getCars(),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<CarModel>?> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text("An error occurred");
                          } else {
                            if (snapshot.hasData && snapshot.data != null) {
                              if (snapshot.data!.isEmpty) {
                                return Text("You do not have any cars yet");
                              } else {
                                return Container(
                                  height:
                                      MediaQuery.of(context).size.height / 3.5,
                                  child: ListView.builder(
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        title: Center(
                                          child: Text(
                                            (snapshot.data![index].model ??
                                                    'N/A') +
                                                "  Range: " +
                                                snapshot.data![index].carRange
                                                    .toString() +
                                                " km",
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CarViewPage(snapshot
                                                        .data![index]
                                                        .id!)), // modify this according to your CarViewPage
                                          );
                                        },
                                      );
                                    },
                                  ),
                                );
                              }
                            } else {
                              return Text("No data");
                            }
                          }
                        },
                      ),
                      GestureDetector(
                        onTap: () async {
                          Api().getDecodedId();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CarCreatePage()), // modify this according to your CarViewPage
                          );
                        },
                        child: Container(
                            height: MediaQuery.of(context).size.height / 22,
                            width: MediaQuery.of(context).size.width / 2.8,
                            decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(20)),
                            child: Center(
                                child: Text(
                              "Add Car",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ))),
                      )
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(28.0),
                        child: Text(
                          "My Reservations",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16),
                        ),
                      ),
                      FutureBuilder<List<ReservationModel>?>(
                        future: Api.getUserReservations(),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<ReservationModel>?> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text("An error occurred");
                          } else {
                            if (snapshot.hasData && snapshot.data != null) {
                              if (snapshot.data!.isEmpty) {
                                return Text("No reservations");
                              } else {
                                return Container(
                                  height:
                                      MediaQuery.of(context).size.height / 3,
                                  child: ListView.builder(
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () async {
                                          ReservationModel? reservation =
                                              await Api.getReservation(
                                                  snapshot.data![index].id!);

                                          if (reservation != null) {
                                            // ReservationDetailsPage'e yönlendir
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ReservationDetailsPage(
                                                            reservation:
                                                                reservation)));
                                          }
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  60),
                                          child: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                16,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey),
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: Center(
                                              child: Text(
                                                'Reservation ID: ${snapshot.data![index].id ?? 'N/A'}, Date: ${snapshot.data![index].date ?? 'N/A'}',
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }
                            } else {
                              return Text("No data");
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
