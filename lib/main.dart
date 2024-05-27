import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blue[800],
        hintColor: Colors.blue[600],
        scaffoldBackgroundColor: Colors.blue[50],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue[800],
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.blue[700],
          textTheme: ButtonTextTheme.primary,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue[700],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        textTheme: TextTheme(
          titleLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.blue[800]),
        ),
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String iotToken =
      "SharedAccessSignature sr=5fd8ae45-473a-43c2-b7cb-6adc3dc6a751&sig=GTKv4rXlxVTYh%2FoY1o6C%2Br7o7AlqLPqjyHAlh7QvdAM%3D&skn=UFF&se=1746555308829";

  Future<void> listarDispositivosCadastrados() async {
    final String url =
        "https://bikefacil-iot-central.azureiotcentral.com/api/devices?api-version=2022-07-31";

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Authorization": iotToken,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DeviceListScreen(devices: data['value']),
        ),
      );
    } else {
      print("Erro: ${response.statusCode} - ${response.reasonPhrase}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bike Fácil'),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[900]!, Colors.blue[300]!],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: listarDispositivosCadastrados,
                    child: Text('Listar Dispositivos Cadastrados'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Placeholder action
                    },
                    child: Text('Placeholder Button 1'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Placeholder action
                    },
                    child: Text('Placeholder Button 2'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Placeholder action
                    },
                    child: Text('Placeholder Button 3'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DeviceListScreen extends StatelessWidget {
  final List<dynamic> devices;

  DeviceListScreen({required this.devices});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dispositivos Cadastrados'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[900]!, Colors.blue[300]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.builder(
          itemCount: devices.length,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 5,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DeviceDetailScreen(
                        deviceId: devices[index]['id'],
                        isEnabled: devices[index]['enabled'],
                      ),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(15),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      Icon(Icons.electric_bike, color: Colors.blue[800], size: 40),
                      SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              devices[index]['id'],
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5),
                            Text(
                              devices[index]['enabled'] ? 'A doca está disponível' : 'A doca não está disponível',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: devices[index]['enabled'] ? Colors.green : Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, color: Colors.grey[700]),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}


class DeviceDetailScreen extends StatelessWidget {
  final String deviceId;
  final bool isEnabled;

  DeviceDetailScreen({required this.deviceId, required this.isEnabled});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Dispositivo $deviceId'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[900]!, Colors.blue[300]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Detalhes do dispositivo com ID: $deviceId',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
              SizedBox(height: 20),
              isEnabled
                  ? Text(
                      'O dispositivo está habilitado',
                      style: TextStyle(fontSize: 20, color: Colors.green[400]),
                    )
                  : Text(
                      'O dispositivo está desabilitado',
                      style: TextStyle(fontSize: 20, color: Colors.red[400]),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
