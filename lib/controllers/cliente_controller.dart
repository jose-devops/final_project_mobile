import 'package:flutter/material.dart';
import '../models/cliente_model.dart';
import '../services/cliente_service.dart';

class ClienteController with ChangeNotifier {
  final ClienteService _service = ClienteService();
  List<Cliente> _clientes = [];

  List<Cliente> get clientes => _clientes;

  // Método para buscar clientes
  Future<void> fetchClientes() async {
    try {
      _clientes = await _service.fetchClientes();
      notifyListeners(); // Notifica os ouvintes para atualizar a interface
    } catch (e) {
      print('Erro ao buscar clientes: $e');
      rethrow;
    }
  }

  // Método para criar cliente
  Future<void> createCliente(Cliente cliente) async {
    try {
      if (cliente.nome.isEmpty || cliente.cpf.isEmpty || cliente.telefone.isEmpty) {
        throw Exception('Todos os campos devem ser preenchidos.');
      }

      await _service.createCliente(cliente);
      await fetchClientes(); // Atualiza a lista após criar
    } catch (e) {
      print('Erro ao criar cliente: $e');
      rethrow;
    }
  }

  // Método para atualizar cliente
  // Future<void> updateCliente(Cliente cliente) async {
  //   try {
  //     if (cliente.id == null) {
  //       throw Exception('ID do cliente não pode ser nulo.');
  //     }
  //     if (cliente.nome.isEmpty || cliente.cpf.isEmpty || cliente.telefone.isEmpty) {
  //       throw Exception('Todos os campos devem ser preenchidos.');
  //     }
  //
  //     await _service.updateCliente(cliente);
  //     await fetchClientes(); // Atualiza a lista após atualizar
  //   } catch (e) {
  //     print('Erro ao atualizar cliente: $e');
  //     rethrow;
  //   }
  // }

  // // Método para deletar cliente
  // Future<void> deleteCliente(int id) async {
  //   try {
  //     if (id <= 0) {
  //       throw Exception('ID inválido para exclusão.');
  //     }
  //
  //     await _service.deleteCliente(id);
  //     await fetchClientes(); // Atualiza a lista após excluir
  //   } catch (e) {
  //     print('Erro ao excluir cliente: $e');
  //     rethrow;
  //   }
  // }
}
