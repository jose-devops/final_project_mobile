import 'package:flutter/material.dart';
import '../../components/pedido/card_pedido.dart'; // Card para pedidos
import '../../components/pedido/register_modal_client.dart';

import '../../components/navigation/bottom_menu_custom.dart';
import '../../models/pedido_model.dart';
import '../../services/pedido_service.dart';
import '../../services/cliente_service.dart'; // Serviço para buscar clientes

class PedidosScreen extends StatefulWidget {
  const PedidosScreen({super.key});

  @override
  State<PedidosScreen> createState() => _PedidosScreenState();
}

class _PedidosScreenState extends State<PedidosScreen> {
  final PedidoService _pedidoService = PedidoService(); // Serviço de pedidos
  final ClienteService _clienteService = ClienteService(); // Serviço de clientes
  final List<Pedido> _pedidos = []; // Lista de pedidos
  final List<Map<String, String>> _clientes = []; // Lista de clientes para o dropdown
  bool _isLoading = true; // Indica se está carregando os pedidos
  bool _isLoadingClientes = true; // Indica se está carregando os clientes

  @override
  void initState() {
    super.initState();
    _carregarPedidos(); // Carrega os pedidos ao iniciar a tela
    _carregarClientes(); // Carrega os clientes ao iniciar a tela
  }

  // Método para carregar pedidos do backend
  Future<void> _carregarPedidos() async {
    try {
      final pedidos = await _pedidoService.fetchPedidos();
      setState(() {
        _pedidos.clear();
        _pedidos.addAll(pedidos);
        _isLoading = false;
      });
      print(_pedidos); // Verifique se os pedidos estão sendo carregados
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar pedidos: $e')),
      );
    }
  }


  // Método para carregar clientes do backend
  Future<void> _carregarClientes() async {
    try {
      final clientes = await _clienteService.fetchClientes(); // Busca os clientes do backend
      setState(() {
        _clientes.clear();
        _clientes.addAll(
          clientes.map((cliente) => {'id': cliente.id.toString(), 'nome': cliente.nome}).toList(),
        );
        _isLoadingClientes = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingClientes = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar clientes: $e')),
      );
    }
  }

  // Método para adicionar um novo pedido
  Future<void> _addPedido(String descricao, double valorTotal, String status, String clienteId) async {
    print('Dados enviados para criar pedido:');
    print('Descrição: $descricao');
    print('Valor Total: $valorTotal');
    print('Status: $status');
    print('Cliente ID: $clienteId');

    final novoPedido = Pedido(
      descricao: descricao,
      valorTotal: valorTotal,
      status: status,
      clienteId: clienteId,
    );


    try {
      await _pedidoService.createPedido(novoPedido);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pedido criado com sucesso!')),
      );
      _carregarPedidos(); // Atualiza a lista após criar
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao criar pedido: $e')),
      );
    }
  }


  // Método para deletar um pedido
  Future<void> _deletePedido(int id) async {
    try {
      await _pedidoService.deletePedido(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pedido deletado com sucesso!')),
      );
      _carregarPedidos(); // Recarrega a lista após deletar
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao deletar pedido: $e')),
      );
    }
  }

  void _navigateTo(int index) {
    if (index == 0) {
      // Navega para a tela de clientes
      Navigator.pushReplacementNamed(context, '/clientes');
    } else if (index == 1) {
      // Já está na tela de pedidos, não faz nada
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header com título
            Container(
              height: 100,
              color: Colors.teal,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Lista de Pedidos',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Botão Adicionar Pedido
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_isLoadingClientes) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Clientes ainda estão sendo carregados')),
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => RegisterModalPedido(
                            clientes: _clientes, // Passa a lista de clientes
                            onSave: (descricao, valorTotal, status, clienteId) {
                              _addPedido(descricao, valorTotal, status, clienteId); // Adiciona o pedido
                            },
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.teal,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(12),
                    ),
                    child: const Icon(Icons.add),
                  ),

                ],
              ),
            ),

            // Lista de Pedidos
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                itemCount: _pedidos.length,
                itemBuilder: (context, index) {
                  final pedido = _pedidos[index];
                  return PedidoCard(
                    pedido: pedido,
                    onEdit: () {
                      // Lógica para editar o pedido
                    },
                    onDelete: () {
                      _deletePedido(index);
                    },
                  );
                },
              ),
            ),


          ],
        ),
      ),
      bottomNavigationBar: BottomMenu(
        currentIndex: 1, // Índice para Pedidos
        onTabTapped: _navigateTo,
      ),
    );
  }
}
