import 'package:flutter/material.dart';

class RegisterModalPedido extends StatefulWidget {
  final Function(String descricao, double valorTotal, String status, String clienteId) onSave;
  final List<Map<String, String>> clientes; // Lista de clientes passada como parâmetro

  const RegisterModalPedido({Key? key, required this.onSave, required this.clientes}) : super(key: key);

  @override
  State<RegisterModalPedido> createState() => _RegisterModalPedidoState();
}

class _RegisterModalPedidoState extends State<RegisterModalPedido> {
  final TextEditingController descricaoController = TextEditingController();
  final TextEditingController valorController = TextEditingController();
  String? selectedStatus; // Status selecionado
  String? selectedCliente; // Cliente selecionado

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Cadastrar Pedido',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Campo Descrição
            TextField(
              controller: descricaoController,
              decoration: const InputDecoration(
                labelText: 'Descrição',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // Campo Valor Total
            TextField(
              controller: valorController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Valor Total',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // Dropdown de Status
            DropdownButtonFormField<String>(
              value: selectedStatus,
              items: const [
                DropdownMenuItem(
                  value: '',
                  child: Text('Selecione um status'),
                ),
                DropdownMenuItem(
                  value: 'PROCESSAMENTO',
                  child: Text('Processamento'),
                ),
                DropdownMenuItem(
                  value: 'ENVIADO',
                  child: Text('Enviado'),
                ),
                DropdownMenuItem(
                  value: 'ENTREGUE',
                  child: Text('Entregue'),
                ),
                DropdownMenuItem(
                  value: 'CANCELADO',
                  child: Text('Cancelado'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  selectedStatus = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // Dropdown de Clientes
            DropdownButtonFormField<String>(
              value: selectedCliente,
              items: widget.clientes
                  .map(
                    (cliente) => DropdownMenuItem(
                  value: cliente['id'], // Valor do cliente (ID)
                  child: Text(cliente['nome'] ?? ''), // Exibe o nome do cliente
                ),
              )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedCliente = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Cliente',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                final descricao = descricaoController.text;
                final valorTotal = double.tryParse(valorController.text) ?? 0.0;

                if (descricao.isNotEmpty &&
                    valorTotal > 0 &&
                    selectedStatus != null &&
                    selectedStatus!.isNotEmpty &&
                    selectedCliente != null &&
                    selectedCliente!.isNotEmpty) {
                  widget.onSave(descricao, valorTotal, selectedStatus!, selectedCliente!); // Salva o pedido
                  Navigator.of(context).pop(); // Fecha o modal
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Preencha todos os campos corretamente')),
                  );
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
