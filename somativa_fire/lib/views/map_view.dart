import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final LatLng _initialPosition = LatLng(-23.55052, -46.633308); // São Paulo exemplo
  Marker? _selectedMarker;

  void _onMapTap(TapPosition tapPosition, LatLng point) {
    setState(() {
      _selectedMarker = Marker(
        point: point,
        width: 80,
        height: 80,
        child: const Icon(
          Icons.location_on,
          color: Colors.red,
          size: 40,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa - Selecione a localização'),
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: _initialPosition,
          initialZoom: 14.0,
          onTap: _onMapTap,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
            userAgentPackageName: 'com.seuprojeto.exemplo', // substitua pelo seu package
          ),
          if (_selectedMarker != null)
            MarkerLayer(
              markers: [_selectedMarker!],
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_selectedMarker != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    'Local selecionado: ${_selectedMarker!.point.latitude}, ${_selectedMarker!.point.longitude}'),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Nenhum local selecionado.'),
              ),
            );
          }
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
