import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/cliente_model.dart';
import '../models/pedido_model.dart';

class PedidoService {
  final String _baseUrl = 'http://localhost:8080/pedido'; // Base URL do backend

  // Método para buscar todos os pedidos
  Future<List<Pedido>> fetchPedidos() async {
    final url = Uri.parse('$_baseUrl/listPedidos');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Pedido.fromJson(e)).toList();
    } else {
      throw Exception('Erro ao buscar pedidos: ${response.body}');
    }
  }

  Future<List<Cliente>> fetchClientes() async {
    final url = Uri.parse('http://localhost:8080/client/listClients');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Cliente.fromJson(e)).toList();
    } else {
      throw Exception('Erro ao buscar clientes: ${response.body}');
    }
  }


  // Método para criar um pedido
  Future<void> createPedido(Pedido pedido) async {
    final url = Uri.parse('$_baseUrl/createPedido');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(pedido.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Erro ao criar pedido: ${response.body}');
    }
  }

  // Método para editar um pedido
  Future<void> updatePedido(Pedido pedido) async {
    final url = Uri.parse('$_baseUrl/updatePedido/${pedido.id}');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(pedido.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao atualizar pedido: ${response.body}');
    }
  }

  // Método para deletar um pedido
  Future<void> deletePedido(int id) async {
    final url = Uri.parse('$_baseUrl/deletePedido/$id');
    final response = await http.delete(url);

    if (response.statusCode != 200) {
      throw Exception('Erro ao deletar pedido: ${response.body}');
    }
  }
}
