
import 'package:flutter/material.dart';
import '../models/pedido_model.dart';
import '../services/pedido_service.dart';

class PedidoController with ChangeNotifier {
  final PedidoService _service = PedidoService();
  List<Pedido> _pedidos = [];

  List<Pedido> get pedidos => _pedidos;

  Future<void> fetchPedidos() async {
    _pedidos = await _service.fetchPedidos();
    notifyListeners();
  }

  Future<void> createPedido(Pedido pedido) async {
    await _service.createPedido(pedido);
    await fetchPedidos();
  }

  Future<void> updatePedido(Pedido pedido) async {
    await _service.updatePedido(pedido);
    await fetchPedidos();
  }

  Future<void> deletePedido(int id) async {
    await _service.deletePedido(id);
    await fetchPedidos();
  }
}
