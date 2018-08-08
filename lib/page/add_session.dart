import 'package:coletiv_infinite_parking/data/model/municipal.dart';
import 'package:coletiv_infinite_parking/data/model/vehicle.dart';
import 'package:coletiv_infinite_parking/network/client/municipal_client.dart';
import 'package:coletiv_infinite_parking/network/client/vehicle_client.dart';
import 'package:flutter/material.dart';

class AddSessionPage extends StatefulWidget {
  @override
  State createState() => _AddSessionPageState();
}

class _AddSessionPageState extends State<AddSessionPage> {
  BuildContext buildContext;

  Municipal selectedMunicipal;
  final municipals = List<Municipal>();

  Vehicle selectedVehicle;
  final vehicles = List<Vehicle>();

  void addSession() {
    // TODO add session
  }

  void getMunicipals() async {
    final municipals = await municipalClient.getMunicipals();

    setState(() {
      this.municipals.addAll(municipals);
    });
  }

  void getVehicles() async {
    final vehicles = await vehicleClient.getVehicles();

    setState(() {
      this.vehicles.addAll(vehicles);
    });
  }

  void onMunicipalSelected(String value) {
    setState(() {
      selectedMunicipal = municipals.firstWhere(
              (municipal) => municipal.name == value,
          orElse: () => null);
    });
  }

  void onVehicleSelected(String value) {
    setState(() {
      selectedVehicle = vehicles
          .firstWhere((vehicle) => vehicle.number == value, orElse: () => null);
    });
  }

  @override
  void initState() {
    super.initState();

    getMunicipals();
    getVehicles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Session'),
      ),
      body: Builder(
        builder: (BuildContext context) {
          buildContext = context;
          return Container(
            margin: EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text("Plate:"),
                    DropdownButton(
                        value: selectedVehicle?.number,
                        items: vehicles.map((municipal) {
                          return DropdownMenuItem<String>(
                            value: municipal.number,
                            child: Text(municipal.number),
                          );
                        }).toList(),
                        onChanged: onVehicleSelected),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text("Municipals:"),
                    DropdownButton(
                        value: selectedMunicipal?.name,
                        items: municipals.map((municipal) {
                          return DropdownMenuItem<String>(
                            value: municipal.name,
                            child: Text(municipal.name),
                          );
                        }).toList(),
                        onChanged: onMunicipalSelected),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
