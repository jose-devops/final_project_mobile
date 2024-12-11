import 'package:flutter/material.dart';
import '../../components/pedido/card_pedido.dart';
import '../../components/pedido/register_modal_client.dart';
import '../../components/navigation/bottom_menu_custom.dart';
import '../../models/pedido_model.dart';
import '../../services/pedido_service.dart';
import '../../services/cliente_service.dart';

class PedidosScreen extends StatefulWidget {
  const PedidosScreen({super.key});

  @override
  State<PedidosScreen> createState() => _PedidosScreenState();
}

class _PedidosScreenState extends State<PedidosScreen> {
  final PedidoService _pedidoService = PedidoService();
  final ClienteService _clienteService = ClienteService();
  final List<Pedido> _pedidos = [];
  final List<Map<String, String>> _clientes = [];
  bool _isLoading = true;
  bool _isLoadingClientes = true;

  @override
  void initState() {
    super.initState();
    _carregarPedidos();
    _carregarClientes();
  }

  Future<void> _carregarPedidos() async {
    try {
      final pedidos = await _pedidoService.fetchPedidos();
      setState(() {
        _pedidos.clear();
        _pedidos.addAll(pedidos);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar pedidos: $e')),
      );
    }
  }

  Future<void> _carregarClientes() async {
    try {
      final clientes = await _clienteService.fetchClientes(); // Busca os clientes do backend
      setState(() {
        _clientes.clear();
        _clientes.addAll(
          clientes.map((cliente) => {
            'id': cliente.id.toString(), // Converte o ID para String
            'nome': cliente.nome,       // Assume que o cliente possui a propriedade "nome"
          }),
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


  Future<void> _addPedido(String descricao, double valorTotal, String status, String clienteId) async {
    final novoPedido = Pedido(
      id: 0,
      descricao: descricao,
      valorTotal: valorTotal,
      status: status,
      clienteId: int.parse(clienteId),
    );

    try {
      await _pedidoService.createPedido(novoPedido);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pedido criado com sucesso!')),
      );
      _carregarPedidos();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao criar pedido: $e')),
      );
    }
  }

  Future<void> _deletePedido(int id) async {
    try {
      await _pedidoService.deletePedido(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pedido deletado com sucesso!')),
      );
      _carregarPedidos();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao deletar pedido: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 100,
              color: Colors.teal,
              child: const Center(
                child: Text(
                  'Lista de Pedidos',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
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
                      clientes: _clientes,
                      onSave: (descricao, valorTotal, status, clienteId) {
                        _addPedido(descricao, valorTotal, status, clienteId);
                      },
                    ),
                  );
                }
              },
              child: const Text('Adicionar Pedido'),
            ),
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
                      // Lógica para editar pedido
                    },
                    onDelete: () {
                      _deletePedido(pedido.id);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
