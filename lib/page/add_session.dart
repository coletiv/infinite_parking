import 'package:coletiv_infinite_parking/data/model/fare_cost.dart';
import 'package:coletiv_infinite_parking/data/model/municipal.dart';
import 'package:coletiv_infinite_parking/data/model/municipal_zone.dart';
import 'package:coletiv_infinite_parking/data/model/vehicle.dart';
import 'package:coletiv_infinite_parking/network/client/municipal_client.dart';
import 'package:coletiv_infinite_parking/network/client/vehicle_client.dart';
import 'package:coletiv_infinite_parking/widgets/VehicleDialog.dart';
import 'package:flutter/material.dart';

class AddSessionPage extends StatefulWidget {
  @override
  State createState() => _AddSessionPageState();
}

class _AddSessionPageState extends State<AddSessionPage> {
  BuildContext buildContext;

  bool areVehiclesLoading = false;
  Vehicle selectedVehicle;
  List<Vehicle> vehicles;

  bool areMunicipalsLoading = false;
  Municipal selectedMunicipal;
  List<Municipal> municipals;

  bool areZonesLoading = false;
  MunicipalZone selectedZone;
  List<MunicipalZone> zones;

  bool areFaresLoading = false;
  FareCost selectedFare;
  List<FareCost> fares;

  @override
  void initState() {
    super.initState();

    getMunicipals();
  }

  void getVehicles() async {
    setState(() {
      areVehiclesLoading = true;
    });

    final updatedVehicles = await vehicleClient.getVehicles();

    setState(() {
      vehicles = updatedVehicles;
      areVehiclesLoading = false;
    });
  }

  void getMunicipals() async {
    setState(() {
      areMunicipalsLoading = true;
    });

    final updatedMunicipals = await municipalClient.getMunicipals();

    setState(() {
      municipals = updatedMunicipals;
      areMunicipalsLoading = false;
    });
  }

  void getZones() async {
    setState(() {
      areZonesLoading = true;
    });

    final updatedZones =
    await municipalClient.getMunicipalZones(selectedMunicipal.token);

    setState(() {
      zones = updatedZones;
      areZonesLoading = false;
    });
  }

  void getFares() async {
    setState(() {
      areFaresLoading = true;
    });

    final fare = await municipalClient.getFare(selectedZone, selectedVehicle);

    setState(() {
      fares = fare.values;
      areFaresLoading = false;
    });
  }

  void addSession() {
    // TODO add session
  }

  void selectVehicle() {
    showDialog(
        context: context, builder: (BuildContext context) => VehicleDialog());
  }

  void selectMunicipal() {
    if (municipals == null) {
      getMunicipals();
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Choose the municipal:"),
          contentPadding: EdgeInsets.symmetric(vertical: 16.0),
          content: Stack(
            alignment: AlignmentDirectional.center,
            children: <Widget>[
              Opacity(
                opacity: areMunicipalsLoading ? 1.0 : 0.0,
                child: CircularProgressIndicator(),
              ),
              Opacity(
                opacity: areMunicipalsLoading ? 0.0 : 1.0,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: municipals.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(municipals[index].name),
                      onTap: () {
                        setState(() {
                          selectedMunicipal = municipals[index];
                        });

                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void selectZone() {
    if (selectedMunicipal == null) {
      // TODO show alert saying that he must choose the municipal first
      return;
    } else {
      getZones();
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Choose the zone:"),
          contentPadding: EdgeInsets.symmetric(vertical: 16.0),
          content: Stack(
            alignment: AlignmentDirectional.center,
            children: <Widget>[
              Opacity(
                opacity: areZonesLoading ? 1.0 : 0.0,
                child: CircularProgressIndicator(),
              ),
              Opacity(
                opacity: areZonesLoading ? 0.0 : 1.0,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: zones.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(zones[index].name),
                      onTap: () {
                        setState(() {
                          selectedZone = zones[index];
                        });

                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void selectFare() {
    if (selectedVehicle == null) {
      // TODO show alert saying that he must choose the vehicle first
      return;
    } else if (selectedZone == null) {
      // TODO show alert saying that he must choose the zone first
      return;
    } else {
      getFares();
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Choose the fare:"),
          contentPadding: EdgeInsets.symmetric(vertical: 16.0),
          content: Stack(
            alignment: AlignmentDirectional.center,
            children: <Widget>[
              Opacity(
                opacity: areFaresLoading ? 1.0 : 0.0,
                child: CircularProgressIndicator(),
              ),
              Opacity(
                opacity: areFaresLoading ? 0.0 : 1.0,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: fares.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(fares[index].chargedCost.toString()),
                      onTap: () {
                        setState(() {
                          selectedFare = fares[index];
                        });

                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
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
          return ListView(
            children: <Widget>[
              ListTile(
                title: Text("Vehicle"),
                subtitle: Text(selectedVehicle != null
                    ? selectedVehicle.number
                    : "Select a vehicle"),
                onTap: selectVehicle,
              ),
              ListTile(
                title: Text("Municipal"),
                subtitle: Text(selectedMunicipal != null
                    ? selectedMunicipal.name
                    : "Select municipal"),
                onTap: selectMunicipal,
              ),
              ListTile(
                title: Text("Zone"),
                subtitle: Text(
                    selectedZone != null ? selectedZone.name : "Select zone"),
                onTap: selectZone,
              ),
              ListTile(
                title: Text("Fare"),
                subtitle: Text(selectedFare != null
                    ? selectedFare.chargedCost.toString()
                    : "Select fare"),
                onTap: selectFare,
              ),
            ],
          );
        },
      ),
    );
  }
}
