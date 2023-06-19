import 'package:flutter/material.dart';
import 'package:wire_app2/api.dart';
import 'package:wire_app2/views/reserve_page.dart';
import '../models/station_model.dart';

class StationListPage extends StatefulWidget {
  @override
  _StationListPageState createState() => _StationListPageState();
}

class _StationListPageState extends State<StationListPage> {
  Future<List<StationModel>?>? _futureStations;

  @override
  void initState() {
    super.initState();
    _futureStations = Api.getStations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<StationModel>?>(
        future: _futureStations,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.error != null) {
            return Text('Error: ${snapshot.error}');
          } else {
            return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                final station = snapshot.data![index];
                return ListTile(
                  title: Text('Station ${station.id}'),
                  subtitle: Text(
                      'Charge Speed: ${station.chargeSpeed}, ${station.isBeingUsed == false && station.isBlocked == false ? 'Available' : 'Currently not available'}'),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StationDetailPage(station: station),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class StationDetailPage extends StatelessWidget {
  final StationModel station;

  StationDetailPage({required this.station});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Station Details',
          style: TextStyle(color: Colors.orange),
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.orange),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height / 4.5,
                child: Image.asset(
                  "assets/undraw_Order_ride_re_372k.png",
                  fit: BoxFit
                      .contain, // Görüntüyü tam ortalamak için fit: BoxFit.contain ekledik
                ),
              ),
              ListTile(
                  title: Text("Station ID",
                      style: TextStyle(color: Colors.orange)),
                  subtitle:
                      Text('${station.id}', style: TextStyle(fontSize: 20))),
              ListTile(
                  title:
                      Text("Host ID ", style: TextStyle(color: Colors.orange)),
                  subtitle:
                      Text('${station.host}', style: TextStyle(fontSize: 20))),
              ListTile(
                  title: Text("Charge Speed",
                      style: TextStyle(color: Colors.orange)),
                  subtitle: Text('${station.chargeSpeed}',
                      style: TextStyle(fontSize: 20))),
              ListTile(
                title: Text(
                  "Status",
                  style: TextStyle(color: Colors.orange),
                ),
                subtitle: station.isBlocked == false
                    ? Text(
                        'Active',
                        style: TextStyle(fontSize: 20),
                      )
                    : Text(
                        'Inactive',
                        style: TextStyle(fontSize: 20),
                      ),
              ),
              ListTile(
                title: Text(
                  "Availability",
                  style: TextStyle(color: Colors.orange),
                ),
                subtitle: station.isBeingUsed == false
                    ? Text(
                        'Available',
                        style: TextStyle(fontSize: 20),
                      )
                    : Text(
                        'Currently in use',
                        style: TextStyle(fontSize: 20),
                      ),
              ),
              ListTile(
                  title: Text("Price", style: TextStyle(color: Colors.orange)),
                  subtitle: Text(
                    '${station.price}',
                    style: TextStyle(fontSize: 20),
                  )),
              ListTile(
                title: Center(
                  child: Text(
                    'Reserve!',
                    style: TextStyle(color: Colors.orange),
                    textAlign: TextAlign.center,
                  ),
                ),
                onTap: () {
                  if (station.isBlocked == false) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReservePage(station: station),
                      ),
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
