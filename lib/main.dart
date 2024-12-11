import 'package:final_project_mobile/screens/client/client_screen.dart';
import 'package:final_project_mobile/screens/pedido/pedido_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestão de Clientes e Pedidos',
      initialRoute: '/',
      routes: {
        '/': (context) => ClientesScreen(),
        '/clientes': (context) => ClientesScreen(),
        '/pedidos': (context) => PedidosScreen(),
      },
    );
  }
}
