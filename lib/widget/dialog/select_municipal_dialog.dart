import 'package:coletiv_infinite_parking/data/model/municipal.dart';
import 'package:coletiv_infinite_parking/network/client/municipal_client.dart';
import 'package:flutter/material.dart';

class SelectMunicipalDialog extends StatefulWidget {
  final Municipal selectedMunicipal;

  const SelectMunicipalDialog({@required this.selectedMunicipal});

  @override
  SelectMunicipalDialogState createState() => SelectMunicipalDialogState();
}

class SelectMunicipalDialogState extends State<SelectMunicipalDialog> {
  @override
  void initState() {
    super.initState();

    _getMunicipals();
    _selectedMunicipal = widget.selectedMunicipal;
  }

  bool _isLoading = false;
  Municipal _selectedMunicipal;
  final _municipals = List<Municipal>();

  void _getMunicipals() async {
    _updateLoadingState(true);

    final municipals = await municipalClient.getMunicipals();

    setState(() {
      _municipals.clear();
      _municipals.addAll(municipals);
    });

    _updateLoadingState(false);
  }

  void _updateLoadingState(bool isLoading) {
    setState(() {
      this._isLoading = isLoading;
    });
  }

  void _onMunicipalSelected(Municipal municipal) {
    Navigator.pop(context, municipal);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select a municipal"),
      ),
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          Opacity(
            opacity: _isLoading ? 1.0 : 0.0,
            child: CircularProgressIndicator(),
          ),
          Opacity(
            opacity: !_isLoading && _municipals.isEmpty ? 1.0 : 0.0,
            child: Text(
              "Some error happened trying to load municipals. Please try again later",
              textAlign: TextAlign.center,
            ),
          ),
          Opacity(
            opacity: !_isLoading && _municipals.isNotEmpty ? 1.0 : 0.0,
            child: ListView.builder(
              shrinkWrap: false,
              itemCount: _municipals.length,
              itemBuilder: (context, index) {
                Municipal municipal = _municipals[index];
                bool isSelected = _selectedMunicipal != null
                    ? _selectedMunicipal.token == municipal.token
                    : false;

                return ListTile(
                  title: Text(municipal.name),
                  selected: isSelected,
                  trailing:
                      isSelected ? Icon(Icons.check) : Icon(Icons.arrow_right),
                  onTap: () {
                    _onMunicipalSelected(municipal);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
