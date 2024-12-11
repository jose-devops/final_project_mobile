import 'package:flutter/material.dart';
import '../../models/pedido_model.dart';

class PedidoCard extends StatelessWidget {
  final Pedido pedido;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const PedidoCard({
    Key? key,
    required this.pedido,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              pedido.descricao,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Cliente: ${pedido.clienteId}'), // Exibe o ID do cliente
            Text('Valor Total: R\$${pedido.valorTotal.toStringAsFixed(2)}'),
            Text('Status: ${pedido.status}'),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: onEdit,
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
