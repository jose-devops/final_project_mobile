import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cliente_model.dart';

class ClienteService {
  final String _baseUrl = 'http://localhost:8080/client'; // URL base do backend

  // Método para buscar clientes
  Future<List<Cliente>> fetchClientes() async {
    final url = Uri.parse('$_baseUrl/listClients'); // Endpoint para listar clientes
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Cliente.fromJson(e)).toList();
    } else {
      throw Exception('Erro ao buscar clientes: ${response.body}');
    }
  }

  // Método para criar cliente
  Future<bool> createCliente(Cliente cliente) async {
    final url = Uri.parse('$_baseUrl/createClient');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(cliente.toJson()),
    );

    if (response.statusCode == 201) {
      return true; // Operação bem-sucedida
    } else {
      print('Erro ao criar cliente: ${response.body}');
      return false; // Operação falhou
    }
  }

  // Método para atualizar cliente
  Future<void> updateClient(Cliente cliente) async {
    // Atualize o URL para o backend correto
    final url = Uri.parse('$_baseUrl/updateClient/${cliente.id}');

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(cliente.toJson()),
    );

    if (response.statusCode == 200) {
      print('Cliente atualizado com sucesso!');
    } else {
      throw Exception('Erro ao atualizar cliente: ${response.body}');
    }
  }



  // Método para deletar cliente
  Future<void> deleteCliente(String id) async {
    // Monta a URL com o ID do cliente
    final url = Uri.parse('http://localhost:8080/client/deleteClient/$id');

    // Faz a requisição DELETE ao backend
    final response = await http.delete(url);

    if (response.statusCode == 204) {
      print('Cliente deletado com sucesso.');
    } else if (response.statusCode == 404) {
      throw Exception('Cliente não encontrado.');
    } else {
      throw Exception('Erro ao deletar cliente: ${response.body}');
    }
  }

}
